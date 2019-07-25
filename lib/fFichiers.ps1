###############################################################################
## NOM: fFichiers.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 03/07/2018
##
## DESCRIPTION : 
##
## MODIFICATIONS :
## DATE :		PAR :					OBSERVATIONS:
## 08/11/2018	Laurent DEVOUCOUX		Ajout de la fonction Purge
## 07/12/2018	Laurent DEVOUCOUX		Ajout de global pour que les fonctions puissent être lancées
## 										au travers d'une autre fonction.
## 17/06/2019	Laurent DEVOUCOUX		Ajout de la fonction Purge
##
## VERSION 0.0.3 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	
.DESCRIPTION
	Cette fonction permet de lister les fichiers.	
.PARAMETER Liste_des_Fichiers
	
.INPUTS
.OUTPUTS
.EXAMPLE
	
#>

###############################################################################
##                                 Variables                                 ##
###############################################################################

###############################################################################
##                                                                           ##
##                                 FONCTIONS                                 ##
##                                                                           ##
###############################################################################

###############################################################################
##                                 LFichier                                  ##
###############################################################################

Function global:LFichier($Fichiers)
{
	##
	## Cette fonction liste les fichiers contenus dans la liste 
	## envoyées en paramètre.
	##
	ForEach ($Files in $Fichiers)
	{
		$Message = "--> " + $Files
		Log $Message INFO 1
	}
}

###############################################################################
##                                  Purge                                    ##
###############################################################################

#Function Purge($Repertoire,$Suffixe,$Retention,$Extension,$Unite)

#Purge -Repertoire $REP_IN -Suffixe "fichierde100Mo_" -Retention 5 -Extention dump -Unite Mn
Function global:Purge
{
	Param (
		[string]$Repertoire,
		[string]$Suffixe,
		[int]$Retention,		
		[string]$Extension,
		[string]$Unite)
	##
	## Cette fonction permet de supprimer des fichiers selon les critères suivants :
	## 		- Le répertoire 
	##		- Le Suffixe
	## 		- La rétention
	##		- L'Extention
	##

	$Message = "* Repertoire : --" + $Repertoire +"--"
	Log $Message INFO 1
	$Message = "** Repertoire length --" + $Repertoire.Length + "--"
	Log $Message INFO 1
	$Message = "* Suffixe : " + $Suffixe
	Log $Message INFO 1
	$Message = "* Retention : " + $Retention
	Log $Message INFO 1
	$Message = "* Extension : " + $Extension
	Log $Message INFO 1
	$Message = "* Unite : " + $Unite
	Log $Message INFO 1

	If ($Repertoire.Length)
	{
		$Message = "Repertoire non vide"
		Log $Message INFO 1
		## Vérification de l'unité utilisée
		If (!($Unite))
		{
			$Message = "L'unite n'a pas été fixée. Donc elle sera configurée sur J pour Jour"
			Log $Message INFO 1
			$Unite = "J"
		}

		If (!($Extension))
		{
			$Suffixe = $Suffixe + "*"
		}
		Else 
		{
			$Suffixe = $Suffixe + "*" + "." + $Extension
		}
		## Lister les fichiers à purger
		#Write-Host ("Liste des fichiers à supprimer : ") -ForegroundColor Blue

		$Message = "Type de fichier qui seront supprimés : " + $Repertoire + "\" + $Suffixe
		Log $Message INFO 1

		#$ListPurge = Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -lt (get-date).AddHours(-$Retention)}

		## Lance une commande spécifique pour chaque Unité
		Switch ($Unite)
		{
			"J" {
				$Message = "Tous les fichiers de plus de " + $Retention + " jour(s) seront supprimés."
				Log $Message INFO 1
				$ListPurge = Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -lt (get-date).AddDays(-$Retention)}
			}
			"H" {
				$Message = "Tous les fichiers de plus de " + $Retention + " heure(s) seront supprimés."
				Log $Message INFO 1
				$ListPurge = Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -lt (get-date).AddHours(-$Retention)}
			}
			"Mn" {
				$Message = "Tous les fichiers de plus de " + $Retention + " minute(s) seront supprimés."
				Log $Message INFO 1
				$ListPurge = Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -lt (get-date).AddMinutes(-$Retention)}
			}
		}
		## Y a-t-il des fichiers à supprimer ?
		$Message = "Liste des fichiers à supprimer : "
		Log $Message INFO 1
		If ($ListPurge.Count -eq 0)
		{
			$Message = "     Il n'y a pas de fichier à supprimer."
			Log $Message INFO 1
		}
		# Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -lt (get-date).AddHours(-$Retention)}
		ForEach ($List in $ListPurge)
		{
			$Fichier = $Repertoire + "\" + $List
			Write-Host ("{0}" -f $List)
			Write-Host ("Fichier : {0}" -f $Fichier) -ForegroundColor Blue
			ForEach-Object {Remove-Item $Fichier -Force}			## A decommenter si on veut vraiment faire le test de suppression
		}
		Write-Host ("*" * 80)
		## Lister les fichiers à conserver
		# Write-Host ("Liste des fichiers à conserver : ") -ForegroundColor Blue
		# (Get-ChildItem -Path $Repertoire -Filter $Suffixe).LastWriteTime
		# # $ListConse = Get-ChildItem -Path $Repertoire -Filter $Suffixe | Where-Object {$_.LastWriteTime -ge (get-date).AddHours(-$Retention)}
		# # $ListConse
		# Write-Host ("{0}" -f $ListConse)
	}
	Else 
	{
		$Message = "Il n'y a pas de répertoire de désigner."
		Log $Message INFO 1
	}
}