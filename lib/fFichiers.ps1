###############################################################################
## NOM: fFichiers.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 03/07/2018
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
	
.DESCRIPTION
	
.PARAMETRE
	
.EXEMPLE
	
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

Function LFichier($Fichiers)
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