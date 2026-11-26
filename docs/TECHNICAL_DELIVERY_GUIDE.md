# Technical Delivery & Knowledge Base — `App Fabric` (`Fabric Apps`)

Complete engineering reference, schema documentation, and troubleshooting playbook for **`App Fabric`** in the **`Fabric Apps`** workspace.

---

## 1. Workspace Inventory & Identifiers

| Layer | Item Name | Type | Item ID |
| :--- | :--- | :--- | :--- |
| **Workspace** | `Fabric Apps` | Workspace | `42aeae0f-446d-4ed0-881d-e27299f64ccb` |
| **Database** | `Gold_FabricApp` | Warehouse | `3930c164-7013-4072-9a6d-d02d28460e88` |
| **Semantic Model** | `Fabric App SM` | SemanticModel | `ebad6356-c9d9-4421-862a-55b85670d78a` |
| **Application** | `App Fabric` | AppBackend | `b23b7c41-20d7-4aaf-a9b8-40e26d979c58` |
| **Sibling App 1** | `fabric-app` | AppBackend | `2ce4fa8f-0002-41a4-b2b7-aef3842ee0dc` |
| **Sibling App 2** | `Try app` | AppBackend | `8d42a24d-1a87-4913-b16d-bde351e7bcde` |

---

## 2. Database Layer (`Gold_FabricApp.Warehouse`)

* **SQL Endpoint:** `celilsbnbrpelgvyihnaz6kou4-b6xk4qtnitie5ca54jzjt5smzm.datawarehouse.fabric.microsoft.com`
* **Collation:** `Latin1_General_100_BIN2_UTF8` (`Gold_FabricApp.sqlproj`)
* **Tables:**
  * `dbo.DimCompany` (3 rows: `US01`, `UK01`, `IN01`)
  * `dbo.DimAccount` (16 rows)
  * `dbo.DimDepartment` (6 rows)
  * `dbo.DimCostCenter` (5 rows)
  * `dbo.DimCustomer` (5 rows)
  * `dbo.DimVendor` (5 rows)
  * `dbo.DimDate` (365 rows; includes `Year`, `MonthNumberOfYear`)
  * `dbo.FactGeneralLedger` (545 rows)
  * `dbo.FactAccountsReceivable` (24 rows; includes `InvoiceID`, `Amount`)
  * `dbo.FactAccountsPayable` (19 rows; includes `BillID`, `BillDate`, `Amount`)
  * `dbo.SecurityUserCompany` (5 rows)

---

## 3. Semantic Model (`Fabric App SM.SemanticModel`)

* **Mode:** DirectLake (`AzureStorage.DataLake` over `Gold_FabricApp.Warehouse`)
* **Security (`Finance_RLS.tmdl`):** Filters `DimCompany`, `FactAccountsReceivable`, and `FactAccountsPayable` using `SecurityUserCompany[UserEmail] = USERPRINCIPALNAME() && SecurityUserCompany[IsActive] = TRUE()`.
* **Measures (`Measure.tmdl`):** `Revenue`, `Total Expense`, `Net Profit`, `Profit Margin %`, `Total Invoiced`, `AR Invoiced`, `AR Paid`, `AR Outstanding`, `AR Invoice Count`, `Total Bills`, `AP Bills`, `AP Paid`, `AP Outstanding`, `AP Bill Count`, `Total Debit`, `Total Credit`, `Net Amount`.

---

## 4. Engineering Root-Cause Playbook

1. **CLI Export Limitation (`fab export`):** Used Fabric REST API `getDefinition` LRO + OneLake DFS + T-SQL `SqlConnection` in `export_fabric_app.py` and `export_warehouse_data.ps1`.
2. **DirectLake Column/Measure Gaps:** Added physical alias columns directly in `Gold_FabricApp.Warehouse` (since DirectLake does not support DAX calculated columns), added measures in `Measure.tmdl`, and deployed via `updateDefinition`.
3. **Reversed Relationships (`relationships.tmdl`):** Fixed 7 relationships from `Dim -> Fact` to `Fact -> Dim` (`Many-to-One`) so `DimDate`, `DimAccount`, `DimCustomer`, and `DimVendor` filter facts properly and `RELATED()` works.
4. **Blank Vega-Lite Folded Charts:** Changed `format: "$#,0"` on folded `Amount` encodings in `index-WB7l78xV.js` to valid d3-format `$,.2s`.
5. **AR/AP Ledger `HTTP 400` in `TOPN`:** Changed `TOPN` sort expressions from `'Fact...'[DueDate]` to the `SELECTCOLUMNS` output column `[DueDate]`, and updated single-company `TREATAS` filtering via `CompanyKey`.
