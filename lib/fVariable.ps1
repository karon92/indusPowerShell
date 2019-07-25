###############################################################################
## NOM: fVariable.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 12/03/2018
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
	Ce script centralise toutes les variables.
.DESCRIPTION
	Nous avons la fonction Log qui s'utilise comme ceci :
		Log Message Type Fichier
		
		Message : est le texte que l'on veut faire apparaître dans le fichier de log.
		Type : est le type de message (INFO,WARN,ERR)
		Fichier : 
.PARAMETER
	Pas besoin de paramètre.
.EXAMPLE
	BackupIT.ps1
#>

###############################################################################
##                                 Variables                                 ##
###############################################################################

## Cette partie rassemble toutes les variables utilisées dans la suite du script

##
## Divers
##

#$NAME_SCRIPT = $MyInvocation.InvocationName.Split("\")[1].Split(".")[0]											## Récupération du nom du script
#$VersionPS = $PSVersionTable.PSVersion.Major																	## Version de PowerShell utilisé
#$Separation = "*"*80

##
## Dates
##

#$Date_AAAAMMJJ_HHmm = Get-Date -format yyyyMMdd_HHmm															## Date au format AAAAMMJJ_HHmm
#$Date_AAAAMMJJ = Get-Date -format yyyyMMdd																		## Date au format AAAAMMJJ

##
## Arborescence
##

#$REP_LOCAL = Get-Location																						## Répertoire courrant

#$REP_LIB = "$REP_LOCAL\lib\"																					## Répertoire des librairies
#$REP_LOG = "$REP_LOCAL\log\"																					## Répertoire des fichiers de log
#$REP_TMP = "$REP_LOCAL\tmp\"																					## Répertoire tmp

#$LIST_REP = Get-Variable REP* -Scope Script
#$NBR_REP = $LIST_REP.Count -1																					## Compte le nombre de variable REP*

##
## Fichiers
##

#$FIC_LOG = $REP_LOG + $NAME_SCRIPT + "_" + $Date_AAAAMMJJ_HHmm + ".log"

Exit 0