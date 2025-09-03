param(
    [string]$OutFile = "extracted-schema-table.txt"
)

$ErrorActionPreference = 'Stop'
$set = New-Object 'System.Collections.Generic.HashSet[string]'

$patterns = @(
    '(?is)\b(?:from|join|update|insert\s+into|delete\s+from|merge\s+into)\s+\[(?<db>[^\[\]]+)\]\.\[(?<schema>[^\[\]]+)\]\.\[(?<table>[^\[\]]+)\]',
    '(?is)\b(?:from|join|update|insert\s+into|delete\s+from|merge\s+into)\s+\[(?<schema>[^\[\]]+)\]\.\[(?<table>[^\[\]]+)\]',
    '(?is)\b(?:from|join|update|insert\s+into|delete\s+from|merge\s+into)\s+"(?<db>[^"]+)"\."(?<schema>[^"]+)"\."(?<table>[^"]+)"',
    '(?is)\b(?:from|join|update|insert\s+into|delete\s+from|merge\s+into)\s+"(?<schema>[^"]+)"\."(?<table>[^"]+)"',
    '(?is)\b(?:from|join|update|insert\s+into|delete\s+from|merge\s+into)\s+(?:(?<db>[A-Za-z_][\w$#]*)\.)?(?<schema>[A-Za-z_][\w$#]*)\.(?<table>[A-Za-z_][\w$#]*)'
)

Get-ChildItem -Path . -Filter *.sql | ForEach-Object {
    $text = Get-Content -LiteralPath $_.FullName -Raw
    foreach ($rx in $patterns) {
        foreach ($m in [regex]::Matches($text, $rx)) {
            $schema = $m.Groups['schema'].Value.Trim()
            $table  = $m.Groups['table' ].Value.Trim()
            if ($schema -and $table) {
                [void]$set.Add("$schema.$table")
            }
        }
    }
}

$OutPath = Join-Path -Path (Get-Location) -ChildPath $OutFile
$set.ToArray() | Sort-Object -Unique | Set-Content -Encoding UTF8 $OutPath
Write-Host "Done. Wrote unique schema.table list to $OutPath"