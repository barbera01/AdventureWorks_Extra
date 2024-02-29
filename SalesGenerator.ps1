. "$PSScriptRoot/Funtions/sql.ps1"
. "$PSScriptRoot/Funtions/General.ps1"


#get a random ID based on max and min of ID Column
function get-RadomRecordID {
    
    param (
        $connectionString,$SQLStatement
    )
    $_connectionString = $connectionString
    $_SQLStatement = $SQLStatement
    $dataTable = get-Dataset -connectionString $_connectionString -SQLstatement $_SQLStatement

    [string[]]$Properties = @()
    Foreach($col in $dataTable.Tables[0].Columns) {
        $Properties += $col;
    }

    $arrayList = New-Object System.Collections.ArrayList
    Foreach($row in $dataTable.Tables[0]) {
        $arrayList.Add(($row  | Select-Object $Properties )) > $null; 
    }
    $data = @()
    foreach ($item in $arrayList) {

        $newobj = $item
        $data = $data + $newobj
    }
 

[int] $randomItemId = Get-Random($data[0].Lowest..$data[0].Highest) 

return $randomItemId
}


function get-RandomProductID {
    param (
        $connectionString,$SQLStatement
    )
    $_connectionString = $connectionString
    $_SQLStatement = $SQLStatement
    $dataTable = get-Dataset -connectionString $_connectionString -SQLstatement $_SQLStatement
    $ProductIDs = @()
    foreach ($row in $dataTable.Tables[0]) {
        $ProductIDs += $row.ProductID
    }

    $randomProductID = Get-Random -InputObject $ProductIDs
    return $randomProductID  
}


$customerID = get-RadomRecordID -connectionString $connectionString -SQLStatement $CustomerMinMax

$productID = get-RandomProductID -connectionString $connectionString -SQLStatement $ProductIDs

$trackingID1 = Create-RandomString -blocks 3 -maxLen 4 -type Numeric  
$trackingID2 = Create-RandomString -blocks 1 -maxLen 3 -type Alphabetic
$OrderQty = Get-Random -Minimum 1 -Maximum 10

$NumberOfProducts = Get-Random -Minimum 1 -Maximum 10
$ProductIDs = @()

for ($i = 0; $i -lt $NumberOfProducts; $i++) {
    $ProductIDs += get-RandomProductID -connectionString $connectionString -SQLStatement $QueryProductIDs
}



Write-Host "Customer ID: $customerID"
Write-Host "Product ID: $productID" 
write-Host "Tracking ID: $trackingID1#$trackingID2"
Write-Host "Order Quantity: $OrderQty"
Write-Host "Prodcut IDs: $ProductIDs." 


 

