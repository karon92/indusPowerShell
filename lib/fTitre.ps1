###############################################################################
## NOM: fTitre.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 09/03/2018
##
## DESCRIPTION : 
##
## MODIFICATIONS :
## DATE :		PAR :					OBSERVATIONS:
## JJ/MM/AAAA
##
## VERSION 0.0.1 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	Ce script est utilisé pour afficher les titres à l'écran et/ou dans le fichier de log
.DESCRIPTION
	Titre "TITRE" "Char" [["Cadre"] [largeur]]
	
.PARAMETRE
	Les paramètres que l'on doit fournir à cette fonction :
		- Texte : Correspond au titre que l'on doit centrer
		- Char : Les caractères qui entourent le titre
.EXEMPLE
	Titre "TITRE" "**"
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
##                                    Titre                                  ##
###############################################################################

Function Titre($Texte,$Char)
{
	$lTexte = $Texte.Length / 2																					## Calcul la taille du titre
	$lChar = $Char.Length																						## Nombre de caractère autour du titre
	$lSeparation = $oSeparation.Length
	$Espace = ($oSeparation.Length / 2 - $lTexte) - $lChar														## Calcul les espaces nécessaires pour centrer
																												## le titre
	#DEBUG#Write-Host ("{0}" -f $lChar) -Fore Green
	$Espace = " " * $Espace
	$Titre = $Char + $Espace + $Texte + $Espace + $Char
	$lTitre = $Titre.Length
	
	If ($lTitre -lt $lSeparation)
	{
		$Reg = $lSeparation - $lTitre
		$Reg = " " * $Reg
		$Titre = $Char + $Espace + $Texte + $Espace + $Reg + $Char
	}
	Else
	{
		$Reg = $lTitre - $lSeparation
		$Reg = $Espace.Length - $Reg
		$Reg = " " * $Reg
		$Titre = $Char + $Espace + $Texte +  $Reg + $Char
	}
	Write-Output ($oSeparation)																					## Début Titre
	Write-Output ($Titre)																						## Affiche le titre centré
	Write-Output ($oSeparation)																					## Fin Titre
}