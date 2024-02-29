. "$PSScriptRoot/../LocalTesting/LocalConfig.ps1"
         
$CustomerMinMax = @'
SELECT MIN(CustomerID) AS Lowest, MAX(CustomerID) AS Highest
FROM  [AdventureWorks2019].[Sales].[Customer] ;
'@

$ProductMinMax = @'
SELECT MIN(ProductID) AS Lowest, MAX(ProductID) AS Highest
FROM  [AdventureWorks2019].[Production].[Product];
'@

 $QueryProductIDs = @'
 SELECT  [ProductID]
 FROM [AdventureWorks2019].[Production].[Product]
'@    


function get-Dataset {
    param (
        $connectionString,$SQLStatement
    )
    $_connectionString = $connectionString
    $_SQLStatement = $SQLStatement

    try {
        $Data = $dataset = Invoke-Sqlcmd -ConnectionString $_connectionString -Query $_SQLStatement -As DataSet
    }
    catch {
        $Data =  $_.Exception.Message
    }

    return   $Data
}
function convert-TableToJson {
    param ($Dataset)

        [string[]]$Properties = @()
        Foreach($col in $Dataset.Tables[0].Columns) {
            $Properties += $col;
        }
        
        $arrayList = New-Object System.Collections.ArrayList
        Foreach($row in $Dataset.Tables[0]) {
            $arrayList.Add(($row  | Select-Object $Properties )) > $null; 
        }
        $data = @()
        foreach ($item in $arrayList) {

            $newobj = $item
            $data = $data + $newobj
        }

        return $data | ConvertTo-Json 
}






