$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Data

$server = "celilsbnbrpelgvyihnaz6kou4-b6xk4qtnitie5ca54jzjt5smzm.datawarehouse.fabric.microsoft.com"
$database = "Gold_FabricApp"
$outDir = "C:\Users\Ghanshyam DataTech\.gemini\antigravity\scratch\fabric-export\Fabric_Apps_Full\Gold_FabricApp.Warehouse\csv"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$tokenJson = az account get-access-token --resource https://database.windows.net/ -o json
$token = ($tokenJson | ConvertFrom-Json).accessToken

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=$server,1433;Database=$database;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$conn.AccessToken = $token
$conn.Open()

try {
    # Export SQL modules (views, procedures, functions) if any
    $modCmd = $conn.CreateCommand()
    $modCmd.CommandText = @"
SELECT s.name AS schema_name, o.name AS object_name, o.type_desc, m.definition
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.is_ms_shipped = 0
ORDER BY o.type_desc, s.name, o.name
"@
    $modAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($modCmd)
    $modTable = New-Object System.Data.DataTable
    [void]$modAdapter.Fill($modTable)
    if ($modTable.Rows.Count -gt 0) {
        $sqlModDir = "C:\Users\Ghanshyam DataTech\.gemini\antigravity\scratch\fabric-export\Fabric_Apps_Full\Gold_FabricApp.Warehouse\sql_modules"
        New-Item -ItemType Directory -Force -Path $sqlModDir | Out-Null
        foreach ($row in $modTable.Rows) {
            $fname = "$($row.schema_name).$($row.object_name).sql"
            $row.definition | Out-File -FilePath (Join-Path $sqlModDir $fname) -Encoding utf8
            Write-Output "Saved SQL module: $fname ($($row.type_desc))"
        }
    } else {
        Write-Output "No custom views/procedures/functions found in sys.sql_modules."
    }

    # Export all user tables
    $tblCmd = $conn.CreateCommand()
    $tblCmd.CommandText = @"
SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME
"@
    $tblAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($tblCmd)
    $tblList = New-Object System.Data.DataTable
    [void]$tblAdapter.Fill($tblList)

    foreach ($t in $tblList.Rows) {
        $schema = $t.TABLE_SCHEMA
        $name = $t.TABLE_NAME
        $qCmd = $conn.CreateCommand()
        $qCmd.CommandTimeout = 120
        $qCmd.CommandText = "SELECT * FROM [$schema].[$name]"
        $qAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($qCmd)
        $dt = New-Object System.Data.DataTable
        $rowCount = $qAdapter.Fill($dt)
        $csvPath = Join-Path $outDir "$schema.$name.csv"
        $dt | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
        Write-Output "Exported $schema.$name -> $rowCount rows ($csvPath)"
    }
}
finally {
    $conn.Close()
}
