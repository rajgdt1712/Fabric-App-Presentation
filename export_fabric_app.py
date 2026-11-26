"""Export all item definitions, metadata, and OneLake files from a Microsoft Fabric workspace."""

from __future__ import annotations

import base64
import json
import os
import re
import time
from pathlib import Path
from typing import Any
from urllib.parse import quote

import requests
from azure.identity import AzureCliCredential

FABRIC_API = "https://api.fabric.microsoft.com/v1"
ONELAKE_DFS = "https://onelake.dfs.fabric.microsoft.com"
WORKSPACE_ID = "42aeae0f-446d-4ed0-881d-e27299f64ccb"
OUT_ROOT = Path(r"C:\Users\Ghanshyam DataTech\.gemini\antigravity\scratch\fabric-export\Fabric_Apps_Full")


def sanitize(name: str) -> str:
    return re.sub(r'[<>:"/\\|?*]+', "_", name).strip()


def get_headers(cred: AzureCliCredential, scope: str) -> dict[str, str]:
    token = cred.get_token(scope).token
    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }


def poll_lro(resp: requests.Response, headers: dict[str, str]) -> dict[str, Any] | None:
    if resp.status_code == 200:
        return resp.json() if resp.text else {}
    if resp.status_code != 202:
        print(f"  [WARN] HTTP {resp.status_code}: {resp.text[:500]}")
        return None

    location = resp.headers.get("Location")
    op_id = resp.headers.get("x-ms-operation-id")
    if not location and op_id:
        location = f"{FABRIC_API}/operations/{op_id}"
    if not location:
        print("  [WARN] 202 returned without Location or x-ms-operation-id")
        return None

    for _ in range(60):
        wait = int(resp.headers.get("Retry-After", "2"))
        time.sleep(max(1, min(wait, 10)))
        poll = requests.get(location, headers=headers, timeout=60)
        if poll.status_code == 200:
            data = poll.json()
            status = data.get("status")
            if status in (None, "Succeeded", "Completed"):
                # If this was an operations status endpoint, fetch /result
                if "definition" not in data and "/operations/" in location and not location.endswith("/result"):
                    res = requests.get(f"{location.rstrip('/')}/result", headers=headers, timeout=60)
                    if res.status_code == 200:
                        return res.json()
                return data
            if status in ("Failed", "Cancelled"):
                print(f"  [ERR] Operation {status}: {json.dumps(data)[:500]}")
                return None
        elif poll.status_code == 202:
            resp = poll
        else:
            print(f"  [WARN] Poll HTTP {poll.status_code}: {poll.text[:300]}")
            return None
    print("  [WARN] Timed out polling LRO")
    return None


def export_item_definitions(headers: dict[str, str]) -> list[dict[str, Any]]:
    items_resp = requests.get(f"{FABRIC_API}/workspaces/{WORKSPACE_ID}/items", headers=headers, timeout=60)
    items_resp.raise_for_status()
    items = items_resp.json().get("value", [])
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    (OUT_ROOT / "workspace_items.json").write_text(json.dumps(items, indent=2), encoding="utf-8")

    for item in items:
        item_id = item["id"]
        item_type = item["type"]
        display_name = item["displayName"]
        item_dir = OUT_ROOT / f"{sanitize(display_name)}.{item_type}"
        item_dir.mkdir(parents=True, exist_ok=True)
        print(f"\n=== Exporting {display_name} ({item_type}) [{item_id}] ===")

        # Fetch full item metadata
        meta_resp = requests.get(
            f"{FABRIC_API}/workspaces/{WORKSPACE_ID}/items/{item_id}",
            headers=headers,
            timeout=60,
        )
        if meta_resp.status_code == 200:
            (item_dir / "_item_metadata.json").write_text(
                json.dumps(meta_resp.json(), indent=2), encoding="utf-8"
            )

        # Fetch item connections if available
        conn_resp = requests.get(
            f"{FABRIC_API}/workspaces/{WORKSPACE_ID}/items/{item_id}/connections",
            headers=headers,
            timeout=60,
        )
        if conn_resp.status_code == 200:
            (item_dir / "_item_connections.json").write_text(
                json.dumps(conn_resp.json(), indent=2), encoding="utf-8"
            )

        # Fetch item definition
        def_resp = requests.post(
            f"{FABRIC_API}/workspaces/{WORKSPACE_ID}/items/{item_id}/getDefinition",
            headers=headers,
            timeout=60,
        )
        def_data = poll_lro(def_resp, headers)
        if not def_data:
            continue

        parts = def_data.get("definition", {}).get("parts", [])
        if not parts:
            (item_dir / "_definition_raw.json").write_text(
                json.dumps(def_data, indent=2), encoding="utf-8"
            )
            print("  No parts array; saved _definition_raw.json")
            continue

        def_dir = item_dir / "definition"
        for part in parts:
            rel_path = part.get("path", "unknown")
            payload = part.get("payload", "")
            payload_type = part.get("payloadType", "")
            target = def_dir / Path(rel_path)
            target.parent.mkdir(parents=True, exist_ok=True)
            if payload_type == "InlineBase64":
                raw = base64.b64decode(payload)
                target.write_bytes(raw)
                print(f"  Saved {rel_path} ({len(raw)} bytes)")
            else:
                target.write_text(json.dumps(part, indent=2), encoding="utf-8")
                print(f"  Saved {rel_path} ({payload_type})")

    return items


def download_onelake_tree(storage_headers: dict[str, str], item_id: str, item_label: str, dest_dir: Path) -> None:
    print(f"\n=== Listing OneLake for {item_label} [{item_id}] ===")
    list_url = f"{ONELAKE_DFS}/{WORKSPACE_ID}?resource=filesystem&recursive=true&directory={quote(item_id)}"
    resp = requests.get(list_url, headers=storage_headers, timeout=120)
    if resp.status_code != 200:
        print(f"  [WARN] OneLake list HTTP {resp.status_code}: {resp.text[:400]}")
        return

    paths = resp.json().get("paths", [])
    files = [p for p in paths if not p.get("isDirectory")]
    print(f"  Found {len(files)} files in OneLake under {item_label}")
    (dest_dir / "_onelake_manifest.json").write_text(json.dumps(paths, indent=2), encoding="utf-8")

    for entry in files:
        rel = entry["name"]
        # Strip leading "<item_id>/"
        sub_rel = rel[len(item_id) + 1 :] if rel.startswith(f"{item_id}/") else rel
        out_path = dest_dir / Path(sub_rel)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        file_url = f"{ONELAKE_DFS}/{WORKSPACE_ID}/{quote(rel)}"
        dl = requests.get(file_url, headers=storage_headers, timeout=120)
        if dl.status_code == 200:
            out_path.write_bytes(dl.content)
        else:
            print(f"  [WARN] Failed {sub_rel}: HTTP {dl.status_code}")

    print(f"  Downloaded OneLake files into {dest_dir}")


def main() -> None:
    cred = AzureCliCredential()
    fabric_headers = get_headers(cred, "https://api.fabric.microsoft.com/.default")
    items = export_item_definitions(fabric_headers)

    storage_headers = get_headers(cred, "https://storage.azure.com/.default")
    for item in items:
        if item["type"] in ("Warehouse", "Lakehouse", "SQLDatabase"):
            item_dir = OUT_ROOT / f"{sanitize(item['displayName'])}.{item['type']}" / "onelake"
            item_dir.mkdir(parents=True, exist_ok=True)
            download_onelake_tree(storage_headers, item["id"], item["displayName"], item_dir)


if __name__ == "__main__":
    main()
