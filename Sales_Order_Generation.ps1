. "$PSScriptRoot/Funtions/General.ps1"
. "$PSScriptRoot/LocalTesting/creds.ps1"
write-host 
# Define database connection parameters
#$serverName = "win-sql01"
#$databaseName = "AdventureWorks2019"
#$userName = "my user"
#$password = "my Password"
#$connectionString = "Server=$serverName; Database=$databaseName; User ID=$userName; Password=$password;"

# Specify the total number of orders to generate
$totalOrders = 5000
$orderDetailsPerOrder =  Get-Random -Minimum 1 -Maximum 20

# Specify the date range for orders
$startDate = Get-Date "2023-01-01"
$endDate = Get-Date "2024-02-28"


# Create a SQL connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
# Open the connection
$connection.Open()

# Function to execute a query and return results
function Execute-Query($query) {
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    try {
        if ($query.Trim().ToUpper().StartsWith("SELECT")) {
            $result = $command.ExecuteReader()
            $table = New-Object System.Data.DataTable
            $table.Load($result)
            $result.Close()
            return $table
        } else {
            $affectedRows = $command.ExecuteNonQuery()
            return $affectedRows
        }
    } catch {
        Write-Error "An error occurred executing SQL command: $_"
    }
}

# Fetch customer IDs
$customerQuery = "SELECT CustomerID FROM Sales.Customer"
$customers = Execute-Query -query $customerQuery

# Fetch product IDs
$productQuery = "SELECT ProductID FROM Production.Product WHERE SafetyStockLevel > 0"
$products = Execute-Query -query $productQuery


# Generate orders
for ($i = 0; $i -lt $totalOrders; $i++) {
   
    # Randomly select a customer
    $customerId = ""
    $customerIndex = Get-Random -Minimum 0 -Maximum $customers.Rows.Count
    $customerId = $customers[$customerIndex]["CustomerID"]

    
    $customerDeatilQuery = "SELECT CustomerID ,AccountNumber ,TerritoryID, PersonID FROM Sales.Customer WHERE CustomerID = '$customerId'"
    $customersDeatils = Execute-Query -query $customerDeatilQuery
    $buinessEntityID = $customersDeatils.PersonID
    
    $addressID = ""
    $buinessEntityIDAddressLookup = "SELECT TOP 1 BusinessEntityID, AddressID ,AddressTypeID FROM Person.BusinessEntityAddress WHERE BusinessEntityID = '$buinessEntityID'"
    $addressDetsils = Execute-Query -query $buinessEntityIDAddressLookup 
    $addressID = $addressDetsils.AddressID

   # $addressQuery = "SELECT AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, SpatialLocation.ToString() as SpatialLocation FROM person.address where AddressID = '$buinessEntityID'"

    if([string]::IsNullOrEmpty($addressID)){
        $i--
        
    }else {
         # Randomly select a product
    $productIndex = Get-Random -Minimum 0 -Maximum $products.Rows.Count
    $productId = $products[$productIndex]["ProductID"]

    # Generate a random order date within the specified range
    $timeSpan = New-TimeSpan -Start $startDate -End $endDate
    $randomDays = Get-Random -Minimum 0 -Maximum $timeSpan.Days
    $orderDate = $startDate.AddDays($randomDays).ToString("yyyy-MM-dd")

    $creditCardId = ""
    #get Credit card ID
    $queryCreditCardId = "SELECT TOP 1 CreditCardID FROM sales.PersonCreditCard WHERE BusinessEntityID = '$buinessEntityID'"
    $GetCreditCardId = Execute-Query -query $queryCreditCardId    
    $creditCardId = $GetCreditCardId.CreditCardID

    $creditCardAprovedCode1 = Create-RandomString -blocks 1  -maxLen 4 -type Numeric 
    $creditCardAprovedCode2 = Create-RandomString -blocks 1  -maxLen 1 -type Alphabetic
    $creditCardAprovedCode3 =Create-RandomString -blocks 1  -maxLen 4 -type Numeric 
    $creditCardAprovedCodeFull = "$creditCardAprovedCode1$creditCardAprovedCode2$creditCardAprovedCode3"
    
    
    # Insert the sales order header without BillToAddressID
    $Comment = Get-ShippingComment

    
    $insertHeaderQuery = @"
    INSERT INTO Sales.SalesOrderHeader (RevisionNumber, OrderDate, DueDate, Status, OnlineOrderFlag, CustomerID, ShipMethodID, BillToAddressID, ShipToAddressID,CreditCardID, CreditCardApprovalCode,Comment,AccountNumber,TerritoryID,ShipDate)
    VALUES (1, '$orderDate', DATEADD(day, 7, '$orderDate'), 1, 1, '$customerId', 1,'$addressID' , '$addressID','$creditCardId','$creditCardAprovedCodeFull','$Comment','$($customersDeatils.AccountNumber)','$($customersDeatils.TerritoryID)',DATEADD(day, 4, '$orderDate'))
"@

    #Write-Host "Executing SQL Command: $insertHeaderQuery"
    $affectedRows = Execute-Query -query $insertHeaderQuery

    # Check if the insert was successful based on affected rows
    if ($affectedRows -le 0) {
        Write-Error "Failed to insert sales order header."
    }

    # Retrieve the SalesOrderID of the newly inserted header
    $salesOrderIdQuery = "SELECT MAX(SalesOrderID) AS SalesOrderID FROM Sales.SalesOrderHeader"
    $salesOrder = Execute-Query -query $salesOrderIdQuery
    $salesOrderId = $salesOrder.SalesOrderID
    #write-host "###########################################"
    #write-host "Sales Order ID: $salesOrderId" "Customer ID: $customerId" 
    #write-host "###########################################"
     #TrackingNumber
     $trackingNumber = Create-RandomString -blocks 3  -maxLen 4 -delimiter '-' -type Alphanumeric 
     $tarckingNumberFull = "$trackingNumber#$SalesOrderId" 

    # Generate order detail records
    for ($j = 0; $j -lt $orderDetailsPerOrder; $j++) {
        $specialOfferIDResult = ""
        # Randomly select a product for each order detail
        $productIndex = Get-Random -Minimum 0 -Maximum $products.Rows.Count
        $productId = $products[$productIndex]["ProductID"]

       
        #check for specil offier ID
        $specialOfferID = "" 
        $specialOfferIDQuery = "SELECT SpecialOfferID FROM Sales.SpecialOfferProduct WHERE ProductID = '$productId'"
        $specialOfferIDResult = Execute-Query -query $specialOfferIDQuery

        


      
        #check if the product has a special offer if not certe one with id 1 if it has multiple take highest for teh moment 
        if ([string]::IsNullOrEmpty($specialOfferIDResult)) {
            
            $CreteSpecialOfferID = "INSERT INTO Sales.SpecialOfferProduct (SpecialOfferID, ProductID, rowguid, ModifiedDate) VALUES ('1', '$productId', NEWID(), GETDATE())"
            $specialOfferIDInsert = Execute-Query -query $CreteSpecialOfferID           
            $specialOfferID = "1"

        } else {
            if ($specialOfferIDResult.ItemArray.Count -gt 1) {
                
            
                $specialOfferID = $specialOfferIDResult[$specialOfferIDResult.ItemArray.Count - 1]["SpecialOfferID"]
            } elseif ($specialOfferIDResult.ItemArray.Count -eq 1) {
                
                $specialOfferID = $specialOfferIDResult[0]
            }
            
        }
        


      
        # Insert the sales order detail
        $insertDetailQuery = @"
        INSERT INTO Sales.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount,SpecialOfferID,CarrierTrackingNumber)
        VALUES ($salesOrderId, 1, $productId, (SELECT ListPrice FROM Production.Product WHERE ProductID = $productId), 0,'$specialOfferID','$tarckingNumberFull')
"@
        
            $OrderDetailInsert = Execute-Query -query $insertDetailQuery
        
    
        
}
    }

   

  Write-Host "######Job Compleete ###############"
}

# Close the connection
$connection.Close()
