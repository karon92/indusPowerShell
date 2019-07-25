###############################################################################
## NOM: fLog.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 09/03/2018
##
## DESCRIPTION : 
##
## MODIFICATIONS :
## DATE :		PAR :					OBSERVATIONS:
## 21/03/2018	Laurent DEVOUCOUX		Mise en place d'un horodatage pour les logs
## 07/12/2018	Laurent DEVOUCOUX		Ajout de global pour la fonction puisse être lancée
## 										au travers d'une autre fonction.
##
## VERSION 0.0.3 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	Ce script est un template pour la création de mes futurs scripts.
.DESCRIPTION
	Nous avons la fonction Log qui s'utilise comme ceci :
		Log Message Type Fichier
		
		Message : est le texte que l'on veut faire apparaître dans le fichier de log.
		Type : est le type de message (INFO,WARN,ERR)
		Fichier : 
.PARAMETER Message
	C'est le texte qui sera intégré au fichier de log.
.PARAMETER Type
	Détermine si on a à faire :
		- A une information : INFO
		- A une alerte : WARN
		- A une erreur : ERR
.INPUTS
.OUTPUTS
.EXAMPLE
	
	Pour afficher une information :
	
		Log "Message" INFO 1
	
	Pour afficher une alerte :
	
		Log "Message" WARN 1
	
	Pour afficher une erreur :
	
		Log "Message" ERR 1
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
##                                     Log                                   ##
###############################################################################

## La ligne suivante permet de tester le bon lancement de 
## la fonction
#Write-Host ("Ce script est lancé...") -ForegroundColor Green
Function global:Log($Message,$Type,$File)
{
	$Type = $Type.ToUpper()
	$File = [int]$File
	$VersionPS = $PSVersionTable.PSVersion.Major
	
	##
	## DATE
	##
	$Date_AAAAMMJJ_HHmmss = Get-Date -format "yyyy-MM-dd HH:mm:ss"													## Date au format AAAA-MM-JJ HH:mm:ss
	
	##
	## Valeur des variables envoyées à la fonction Log
	##
	## Pour Debugguer on peut décommenter les lignes suivantes :
	##
	#Write-Output ("Valeur de Message : {0} " -f $Message)
	#Write-Output ("Valeur de Type : {0} " -f $Type)
	#Write-Output ("Valeur de File : {0} " -f $File)
	Switch ($Type)
	{
		"INFO" {
			## Le message est une information
			$tMessage = $Date_AAAAMMJJ_HHmmss + " INFO:          " + $Message
		}
		"WARN" {
			## Le message est une alerte
			$tMessage = $Date_AAAAMMJJ_HHmmss + " WARNING:       " + $Message
		}
		"ERR" {
			## Le message est une erreur
			$tMessage = $Date_AAAAMMJJ_HHmmss + " ERROR:         " + $Message
		}
	}
	If ($VersionPS -lt 5)
	{
		## Si on utilise le script sur une version inférieure à la 5
		## il faudra ajouter à la main les lignes de log dans le fichier")
		If ($File -eq 1)
		{
			Switch ($Type)
			{
				#$tMessage = $tMessage + "`n"
				INFO {Write-Output ($tMessage)}
				WARN {Write-Output ($tMessage)}
				ERR {Write-Output ($tMessage)}
				default {Write-Host ("Pas d'information")}
			}
		}
		##
		## Ecriture dans le fichier de log
		##
		
	}
	Else
	{
		## En cas de débuggage on peut décommenter la ligne suivante pour 
		## connaître la version du PowerShell remontée
		#Write-Output ("Version de PowerShell >= 5 : {0}" -f $VersionPS)
		If ($File -eq 1)
		{
			Switch ($Type)
			{
				INFO {Write-Host ($tMessage) -ForeGroundColor Blue}
				WARN {Write-Host ($tMessage) -ForeGroundColor Yellow}
				ERR {Write-Host ($tMessage) -ForeGroundColor Red}
				default {Write-Host ("Pas d'information")}
			}
		}
	}
}