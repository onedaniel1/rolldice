function Roll () {
<#
.SYNOPSIS
	Roll by default will roll dice and output the result. 
.DESCRIPTION
	A dice rolling function optimized for Fear In The Foundation gameplay.
This function accepts a wide variety of input with the goal of making complex rolls easy.
No input = Roll 1d100
Just a number (e.g. 20) = Roll a die with that many sides
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
    $dice = $dice.ToLower()
    #see if its simple or complex with multiple die types
    if ($dice -match '^([0-9]+d[0-9]+)[+]([0-9]+d[0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("+")
        $d1 = 0
        $d2 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d1 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $splitDice = $die[1].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d2 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $d1 + $d2
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[-]([0-9]+d[0-9]+)$') {
        #die are complex and being subtracted, handle it
        $die = $dice.Split("-")
        $d1 = 0
        $d2 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d1 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $splitDice = $die[1].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d2 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $d1 - $d2
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[+]([0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("+")
        $d1 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d1 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $d1 + $die[1]
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)[-]([0-9]+)$') {
        #die are complex and being added, handle it
        $die = $dice.Split("-")
        $d1 = 0
        $splitDice = $die[0].Split("d")
        for ($i=0;$i -lt [int]$splitDice[0];$i++) {
            $d1 += get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
        }
        $d1 - $die[1]
    }
    elseif ($dice -match '^([0-9]+d[0-9]+)$') {
        #roll a single type of dice
        $splitDice = $dice.Split("d")
        $result = 0
        if($advantage) {
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $result += $thisRoll
            }
            $result
            $result = 0
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $result += $thisRoll
            }
            $result        
        }
        else{
            for ($i=0;$i -lt [int]$splitDice[0];$i++) {
                $thisRoll = get-random -minimum 1 -maximum ([int]$splitDice[1] + 1)
                $result += $thisRoll
            }
            $result
        }
        
    }
    elseif ($dice -match '^([0-9]+)$') {
        #roll a single die of the size provided
        [int]$die = [string]($dice -replace '\D')
        get-random -minimum 1 -maximum ($die+1)
        if($advantage) {
            get-random -minimum 1 -maximum ($die+1)
        }
    }
    else {
        "Dice must be in a standard format `"2d20`" , `"4d8+2d6`" , `"4d8+20`", `"4d8-100`""
    }
}
Export-ModuleMember -Function Roll