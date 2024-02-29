

function Create-RandomString {
    param (
        [int]$blocks = 1,
        [string]$delimiter = "-",
        [int]$maxLen = 10,
        [ValidateSet("Numeric","Alphanumeric","Alphabetic")]
        [string]$type = "Alphanumeric"
    )

    $random = New-Object System.Random
    $result = @()

    for ($i = 0; $i -lt $blocks; $i++) {
        $block = switch ($type) {
            "Numeric" { -join (1..$maxLen | ForEach-Object { $random.Next(0,10) }) }
            "Alphabetic" { -join (1..$maxLen | ForEach-Object { [char]$random.Next(65,91) }) }
            "Alphanumeric" { -join (1..$maxLen | ForEach-Object { [char]$random.Next(48,123) }) }
        }
        $result += $block
    }

    return ($result -join $delimiter)
}

