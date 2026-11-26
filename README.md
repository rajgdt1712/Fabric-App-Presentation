# Fabric Apps Export (`App Fabric`)

Exported database, backend, semantic model, and frontend assets from the Microsoft Fabric workspace **`Fabric Apps`**.

## Contents

- `Fabric_Apps_Full/App Fabric.AppBackend/` — Backend configuration (`definition/rayfin.yml`) and frontend static app (`definition/frontend/static-app.zip` + `unzipped/`).
- `Fabric_Apps_Full/fabric-app.AppBackend/` & `Try app.AppBackend/` — Sibling AppBackend definitions and frontend bundles from `Fabric Apps`.
- `Fabric_Apps_Full/Fabric App SM.SemanticModel/` — DirectLake semantic model TMDL definitions, relationships, measures, and RLS roles.
- `Fabric_Apps_Full/Gold_FabricApp.Warehouse/` — SQL project & table DDLs (`definition/`), CSV table exports (`csv/`), and raw OneLake Delta logs & Parquet files (`onelake/`).
- `export_fabric_app.py` — Script to export Fabric item definitions, metadata, and OneLake files via REST APIs.
- `export_warehouse_data.ps1` — Script to export Warehouse tables to CSV via the Fabric Warehouse SQL endpoint.
