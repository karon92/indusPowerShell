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
## 25/07/2019	Laurent DEVOUCOUX		Remplacement de la commande Write-Output par la commande
##										Write-Host
##
## VERSION 0.0.2 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	Ce script est utilisé pour afficher les titres à l'écran et/ou dans le fichier de log
.DESCRIPTION
	Titre "TITRE" "Char" [["Cadre"] [largeur]]
	
.PARAMETER
	Les paramètres que l'on doit fournir à cette fonction :
		- Texte : Correspond au titre que l'on doit centrer
		- Char : Les caractères qui entourent le titre
.EXAMPLE
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

Function global:Titre($Texte,$Char)
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
	## 
	## Un problème d'ordre d'affichage des lignes
	## m'oblige a utiliser la commande Write-Host a la place de
	## la commande Write-Output
	## Modification effectuée le 25/07/2019 par LDX
	##

	#Write-Output ($oSeparation)																					## Début Titre
	#Write-Output ($Titre)																						## Affiche le titre centré
	#Write-Output ($oSeparation)
	Write-Host ($oSeparation)																					## Début Titre
	Write-Host ($Titre)																						## Affiche le titre centré
	Write-Host ($oSeparation)																					## Fin Titre
}