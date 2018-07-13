###############################################################################
## NOM: fLog.ps1
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
	Ce script est un template pour la création de mes futurs scripts.
.DESCRIPTION
	Nous avons la fonction Log qui s'utilise comme ceci :
		Log Message Type Fichier
		
		Message : est le texte que l'on veut faire apparaître dans le fichier de log.
		Type : est le type de message (INFO,WARN,ERR)
		Fichier : 
.PARAMETRE
	Pas besoin de paramètre.
.EXEMPLE
	
	Pour afficher une information :
	
		fLog.ps1 "Message" INFO 1
	
	Pour afficher une alerte :
	
		fLog.ps1 "Message" WARN 1
	
	Pour afficher une erreur :
	
		fLog.ps1 "Message" ERR 1
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

Function Log($Message,$Type,$File)
{
	$Type = $Type.ToUpper()
	$File = [int]$File
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
			$tMessage = "INFO:          " + $Message
		}
		"WARN" {
			## Le message est une alerte
			$tMessage = "WARNING:       " + $Message
		}
		"ERR" {
			## Le message est une erreur
			$tMessage = "ERROR:         " + $Message
		}
	}
	If ($VersionPS -lt 5)
	{
		## Si on utilise le script sur une version inférieure à la 5
		## il faudra ajouter à la main les lignes de log dans le fichier")
	}
	Else
	{
		## En cas de débuggage on peut décommenter la ligne suivante pour 
		## connaître la version du PowerShell remontée
		#Write-Output ("Version de PowerShell >5 : {0}" -f $VersionPS)
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