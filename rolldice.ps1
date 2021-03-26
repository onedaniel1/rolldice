Add-Type -AssemblyName PresentationFramework

$global:rollLog = "-----`n"

function Roll () {
<#
.SYNOPSIS
	Roll by default will roll dice and output the result. 
.DESCRIPTION
	A dice rolling function optimized for Fear In The Foundation gameplay.
This function accepts a wide variety of input with the goal of making complex rolls easy.
No input = Roll 1d100
Just a number (e.g. 20) = Roll a die with that many sides
Just a number with the advantage flag (e.g. 20 -advantage) = Roll a die with that many sides twice and show both results
A number followed by a d and then another number (e.g. 5d10) = roll first number of dice of second number of sides
A number followed by a d and then another number + a number followed by a d and then another number (e.g. 1d8+2d6) = roll two types of dice and add the numbers together
A number followed by a d and then another number + a number (e.g. 1d8+20) = roll first number of dice of second number of sides and add the number
All parameters that can be added with + can also be subtracted with -.
.PARAMETER Dice
    The number of dice followed by the type of dice being thrown
.PARAMETER Advantage, A, Disadvantage, D
    When used with a single dice type will show the results of two rolls
.EXAMPLE 
Roll 
    This will simulate one roll of a D100 dice
.EXAMPLE
Roll 10
    This will simulate one roll of a 10 sided dice
.EXAMPLE 
Roll 2d20
	This will simulate two rolls using a D20
.EXAMPLE 
Roll 4d8+2d6
    This will roll four D8 dice and two D6 dice and add the results together
.EXAMPLE 
Roll 3d20+40
    This will roll three D20 dice with a bonus of 40
.EXAMPLE
Roll 20 -advantage
    This will simulate two separate D20 rolls and show both results
.INPUTS
	You can pipe any input into roll that you can use as a parameter
.NOTES
	Author: Daniel Tedder
#>
    param(
        [Parameter(ValueFromPipeline=$true,Position=0)]
        [String[]]
        $dice="1d100",
        [Alias("A","disadvantage","d")]
        [switch]$advantage
    )
    $dice = $dice.ToLower() -replace(' ')
    #see if its simple or complex with multiple die types
    if ($dice -match '^([0-9]+d[0-9]+)[+]([0-9]+d[0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("+")
        $d1 = 0
        $d2 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $global:rollLog += "$t`n"
            $d1 += $t
        }
        $global:rollLog += "---`n"
        $splitDice = $die[1].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $d2 += $t
            $global:rollLog += "$t`n"
        }
        $result = $d1 + $d2
        $global:rollLog += "---`n$d1 + $d2 = $result`n---------`n"
        $result
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[-]([0-9]+d[0-9]+)$') {
        #die are complex and being subtracted, handle it
        $die = $dice.Split("-")
        $d1 = 0
        $d2 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $global:rollLog += "$t`n"
            $d1 += $t
        }
        $global:rollLog += "---`n"
        $splitDice = $die[1].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $d2 += $t
            $global:rollLog += "$t`n"
        }
        $result = $d1 - $d2
        $global:rollLog += "---`n$d1 - $d2 = $result`n---------`n"
        $result
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[+]([0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("+")
        $d1 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $global:rollLog += "$t`n"
            $d1 += $t
        }
        $result = $d1 + $die[1]
        $global:rollLog += "---`n$d1 + $($die[1]) = $result`n---------`n"
        $result
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[-]([0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("-")
        $d1 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $t = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
            $global:rollLog += "$t`n"
            $d1 += $t
        }
        $result = $d1 - $die[1]
        $global:rollLog += "---`n$d1 - $($die[1]) = $result`n---------`n"
        $result
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)$') {
        #roll a single type of dice
        $splitDice = $dice.Split("d")
        $result = 0
        if($advantage) {
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $global:rollLog += "$thisRoll`n"
                $result += $thisRoll
            }
            $result
            $result = 0
            $global:rollLog += "---`n"
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $global:rollLog += "$thisRoll`n"
                $result += $thisRoll
            }
            $result
            $global:rollLog += "`n---------`n"        
        }
        else{
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $global:rollLog += "$thisRoll`n"
                $result += $thisRoll
            }
            $result
            $global:rollLog += "`n---------`n"
        }
        
    }
    elseif ($dice -match '^([0-9]+)$') {
        #roll a single die of the size provided
        [int]$die = [string]($dice -replace '\D')
        $thisRoll = get-random -minimum 1 -maximum ($die+1)
        $global:rollLog += "$thisRoll`n"
        $thisRoll
        if($advantage) {
            $global:rollLog += "---`n"
            $thisRoll = get-random -minimum 1 -maximum ($die+1)
            $global:rollLog += "$thisRoll`n"
            $thisRoll
        }
        $global:rollLog += "`n---------`n"
    }
    else {
        $global:rollLog += "ERROR: Dice must be in a standard format `"2d20`" , `"4d8+2d6`" , `"4d8+20`", `"4d8-100`"`n---------`n"
    }
}

#where is the XAML file?
$xamlFile = "F:\Downloads7\dice1\dice1\MainWindow.xaml"

#create window
$inputXML = Get-Content $xamlFile -Raw
$inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
[xml]$XAML = $inputXML
#Read XAML

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $window = [Windows.Markup.XamlReader]::Load( $reader )
}
catch {
    Write-Warning $_.Exception
    throw
}

#Create variables based on form control names.
#Variable will be named as 'var_<control name>'

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    #"trying item $($_.Name)";
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
    } catch {
        throw
   }
}

Get-Variable var_*

$var_RollButton.Add_Click( {
   #clear the result box
   $var_Results.Text = ""
       if ($result = roll $var_Input.Text) {
           $var_Results.Text = "$result"
       }       
   })

#$var_txtComputer.Text = $env:COMPUTERNAME
$Null = $window.ShowDialog()