###############################################################################
## NOM: fTitre.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 09/03/2018
##
## DESCRIPTION : 
##
## MODIFICATIONS :
## DATE :		PAR :					OBSERVATIONS:
## 07/12/2018	Laurent DEVOUCOUX		Ajout de global pour la fonction puisse être lancée
## 										au travers d'une autre fonction.
##
## VERSION 0.0.3 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	
.DESCRIPTION
	
.PARAMETER
	
.EXAMPLE
	
#>

###############################################################################
##                                 Variables                                 ##
###############################################################################

###############################################################################
##                                                                           ##
##                                  FONCTIONS                                ##
##                                                                           ##
###############################################################################

###############################################################################
##                                  ListeVAR                                 ##
###############################################################################

Function global:ListeVAR ($Instant)
{
	$Global:tVar = @()
    ## Remise à 0 des variables utilisées dans le script
    If ($Instant -eq "Before")
    {
        Remove-Variable Variable_Before -ErrorAction SilentlyContinue
        Remove-Variable Variable_After -ErrorAction SilentlyContinue
        #Remove-Variable Toto -ErrorAction SilentlyContinue
        #Remove-Variable Titi -ErrorAction SilentlyContinue
        
        $Global:Variable_Before = Get-Variable -Scope Script
    } 
       
    If ($Instant -eq "After")
    {
        $Variable_After = Get-Variable -Scope Script

        #$DiffA = Compare-Object -ReferenceObject $Variable_Before -DifferenceObject $Variable_After
        
        $DiffB = Compare-Object -ReferenceObject $Variable_After -DifferenceObject $Variable_Before -Property Name,Value | ?{$_.SideIndicator -eq '<=' -and $_.Name -notmatch 'Variable_Before' -and $_.Name -notmatch 'Variable_After' -and $_.Name -notlike "o*"}

        Write-Host ("Liste des variables utilisées par le script :" ) -ForegroundColor Blue
 
        ForEach ($Line in $DiffB)
        {
			$Var = new-object Psobject
            #$Espace = 2
            $Name = $Line.Name
            $Value = $Line.Value

            #DEBUG#Write-Host ($Name) -ForegroundColor Green
            #$Type = Get-Content variable:\$Name | % { $_.gettype()}
            #DEBUG#$Type

            #$Texte = $Name + " " + $Espace + " " + $Value 
            #$Length = 80 - $Texte.Length
            #DEBUG#Write-Host ("Length = {0}" -f $Length) -ForegroundColor Green
            #If ($Length -lt 0) 
            #{
            #    $Length = 0
            #}
            #$Espace = "." * $Length
            #$Texte = $Name + " " + $Espace + " " + $Value 
			
			$Var | add-member -name "NAME" -membertype Noteproperty -value $Name
			$Var | add-member -name "VALUE" -membertype Noteproperty -value $Value
			
			$Global:tVar += $Var

            #Write-Host ($Texte) -ForegroundColor Blue
        }

    }
}

<# Exemple d'utilisation :
    ListeVAR Before

    #$Variable
    $Toto = "TEST"
    $Titi = "TEST2"
    $LDX = "TUTU"
    
    ListeVAR After
#>
