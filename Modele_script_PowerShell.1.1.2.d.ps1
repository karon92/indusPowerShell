###############################################################################
## NOM: xxxxxxxxxxxxxxxxxxxx.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : JJ/MM/AAAA
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
	Nous avons la fonction Titre qui permet de découper le fichier de log en chapitre.
.PARAMETRE
	Pas besoin de paramètre.
.EXEMPLE
	BackupIT.ps1
#>

###############################################################################
##                                                                           ##
##                                  FONCTIONS                                ##
##                                                                           ##
###############################################################################

##
## Arborescence
##

$REP_LOCAL = Get-Location																						## Répertoire courrant

$REP_LIB = "$REP_LOCAL\lib\"																					## Répertoire des librairies

###############################################################################
##                                     Log                                   ##
###############################################################################

Try {
	. $REP_LIB\fLog.ps1
}
Catch {
	Write-Host ("Le script fLog.ps1 n'a pas pu être lancé.") -ForeGroundColor Red 
	Exit 1000
}

###############################################################################
##                                    Titre                                  ##
###############################################################################

. $REP_LIB\fTitre.ps1

###############################################################################
##                     Liste les variables du script                         ##
###############################################################################

. $REP_LIB\fListeVAR.ps1
ListeVAR Before																									## Liste les variables externes au script

###############################################################################
##                          Fonctions sur les fichiers                       ##
###############################################################################

## La fonction fichier a besoin de la fonction log pour fonctionner
## donc nous sommes obliger de la mettre après celle-ci
. $REP_LIB\fFichiers.ps1

###############################################################################
##                                                                           ##
##                                 VARIABLES                                 ##
##                                                                           ##
###############################################################################

##
## NE PAS CREER DE VARIABLE COMMENCANT PAR o 
##
## car elle serait filtrée par la fonction fListeVAR
## 

## Paramètres

#[CmdletBinding()]
#Param (
#	[switch]$VERSION
#)

$MyVERSION = '0.0.1'

If ($VERSION.IsPresent)
{
	$MyVERSION
	Exit 0
}

## Cette partie rassemble toutes les variables utilisées dans la suite du script

##
## Divers
##

$NAME_SCRIPT = $MyInvocation.InvocationName.Split("\")[1]														## Récupération du nom du script
#$NAME_SCRIPT = $MyInvocation.InvocationName.Split("\")[1].Split(".")[0]
Write-Host "Nom du script avec extension : $NAME_SCRIPT" -ForeGroundColor Blue
If ($NAME_SCRIPT.length -gt 0)
{
	$Position = $NAME_SCRIPT.lastindexofany(".")
	If ($Position -gt 0) {$NAME_SCRIPT = $NAME_SCRIPT.substring(0,$Position)}
	Write-Host "Nom du script sans extension : $NAME_SCRIPT" -ForeGroundColor Blue
}

$VersionPS = $PSVersionTable.PSVersion.Major																	## Version de PowerShell utilisée
$oSeparation = "*"*80

##
## Dates
##

$Date_AAAAMMJJ_HHmm = Get-Date -format yyyyMMdd_HHmm															## Date au format AAAAMMJJ_HHmm
$Date_AAAAMMJJ = Get-Date -format yyyyMMdd																		## Date au format AAAAMMJJ

##
## Arborescence
##

$REP_LOG = "$REP_LOCAL\log\"																					## Répertoire des fichiers de log
$REP_TMP = "$REP_LOCAL\tmp\"																					## Répertoire tmp
##
## Les variables $REP_IN et $REP_OUT ont été ajoutées le 23/04/2018
## Tous les fichiers qui sont utilisés en entrée devront être placés de préférence dans le répertoire $REP_IN
## Tandis que tous les fichiers qui sont utilisés en sortie devront être placés dans le répertoire $REP_OUT 
##
$REP_IN	= "$REP_LOCAL\in"																						## Répertoire des fichiers en entrée
$REP_OUT = "$REP_LOCAL\out"																						## Répertoire des fichiers en sortie

$oLIST_REP = Get-Variable REP* -Scope Script
$NBR_REP = $oLIST_REP.Count -1																					## Compte le nombre de variable REP*

##
## Fichiers
##

$FIC_LOG = $REP_LOG + $NAME_SCRIPT + "_" + $Date_AAAAMMJJ_HHmm + ".log"

$oFichiers_log = Get-ChildItem $REP_LOG
$Nbr_Fichiers_Log_Avant = $oFichiers_log.Count
Get-ChildItem -Path $REP_LOG | ?{$_.LastWriteTime -lt (get-date).AddMinutes(-10)} | %{Remove-Item $REP_LOG/$_ -Force}
$oFichiers_log = Get-ChildItem $REP_LOG
$Nbr_Fichiers_Log_Apres = $oFichiers_log.Count
$Nbr_Fichiers_Log = $Nbr_Fichiers_Log_Avant - $Nbr_Fichiers_Log_Apres
#Write-Output ("Nombre de fichier(s) de log supprimé(s) : {0}" -f $Nbr_Fichiers_Log)
$Message = "Nombre de fichier(s) de log supprimé(s) : $Nbr_Fichiers_Log"
Log $Message INFO 1

###############################################################################
##                                                                           ##
##                                  GENERALE                                 ##
##                                                                           ##
###############################################################################

##
## Récapitulatif des variables
##

Start-Transcript $FIC_LOG																						## Démarrage du fichier de LOG
Write-Output (" ")																								## Insère une ligne blanche dans le fichier de log
## Début du récapitulatif des variables

Titre "Les Variables" "**"

ListeVAR After

$tVar | Format-Table

##
## Test la présence de tous les répertoires
##

## Début du test sur les répertoires

Titre "Les Répertoires" "**"

For($i=0;$i -le $NBR_REP;$i++)
{
	If (-not (Test-Path $oLIST_REP[$i].Value))
	{
		## Le répertoire n'est pas présent, nous allons le créé
		New-Item -ItemType Directory -Name $oLIST_REP[$i].Value.Split("\")[-2]
		#Write-Output ("Le répertoire {0} n'existait pas, il a été créé" -f $oLIST_REP[$i].Value)
		$Message = "Le répertoire $($oLIST_REP[$i].Value) n'existait pas, il a été créé"
		Log $Message INFO 1
	}
	Else
	{
		## Le répertoire est présent, il n'y a rien à faire
		#Write-Output ("Le répertoire {0} est présent" -f $oLIST_REP[$i].Value)
		$Message = "Le répertoire $($oLIST_REP[$i].Value) est présent"
		Log $Message INFO 1
	}
}
Write-Output ($oSeparation)																						## Fin du test sur les répertoires
Write-Output (" ")																								## Insère une ligne blanche dans le fichier de log

## Partie principale du script

## Début du script

Titre "Générale" "**"

###############################################################################
##                                                                           ##
##                              DEBUT DU SCRIPT                              ##
##                                                                           ##
###############################################################################

Log "Message test INFO" INFO 1
Log "Message test WARN" WARN 1
Log "Message test ERR" ERR 1

###############################################################################
##                                    FIN                                    ##
###############################################################################

## Ne rien placer en dessous

Titre "FIN" "**"

Stop-Transcript
Exit 0