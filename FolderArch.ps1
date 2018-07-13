###############################################################################
## NOM: FolderArch.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 05/04/2018
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

$REP_LIB = "$REP_LOCAL\lib\"

###############################################################################
##                                     Log                                   ##
###############################################################################

. $REP_LIB\fLog.ps1

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
##                                                                           ##
##                                 Variables                                 ##
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

$NAME_SCRIPT = $MyInvocation.InvocationName.Split("\")[1].Split(".")[0]											## Récupération du nom du script
$VersionPS = $PSVersionTable.PSVersion.Major																	## Version de PowerShell utilisé
$oSeparation = "*"*80

##
## Dates
##

$Date_AAAAMMJJ_HHmm = Get-Date -format yyyyMMdd_HHmm															## Date au format AAAAMMJJ_HHmm
$Date_AAAAMMJJ = Get-Date -format yyyyMMdd																		## Date au format AAAAMMJJ

##
## Arborescence
##
																					## Répertoire des librairies
$REP_LOG = "$REP_LOCAL\log\"																					## Répertoire des fichiers de log
$REP_TMP = "$REP_LOCAL\tmp\"																					## Répertoire tmp

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
Write-Output ("Nombre de fichier(s) de log supprimé(s) : {0}" -f $Nbr_Fichiers_Log)

##
## Divers
##

$folderUP = Split-Path -Path $REP_LOCAL -Parent   ## Nom du répertoire Parent

###############################################################################
##                                                                           ##
##                                  Générale                                 ##
##                                                                           ##
###############################################################################

##
## Récapitulatif des variables
##

Start-Transcript $FIC_LOG																						## Démarrage du fichier de LOG
Write-Output (" ")																								## Insère une ligne blanche dans le fichier de log
## Début du récapitulatif des variables

Titre "Les Variables" "**"
<#
Write-Output ("Date_AAAAMMJJ                     : {0}" -f $Date_AAAAMMJJ)
Write-Output ("Date_AAAAMMJJ_HHmm                : {0}" -f $Date_AAAAMMJJ_HHmm)
Write-Output ("FIC_LOG                           : {0}" -f $FIC_LOG)
Write-Output ("NAME_SCRIPT                       : {0}" -f $NAME_SCRIPT)
Write-Output ("REP_LOCAL                         : {0}" -f $REP_LOCAL)
Write-Output ("REP_LOG                           : {0}" -f $REP_LOG)
Write-Output ("REP_TMP                           : {0}" -f $REP_TMP)
Write-Output ("VersionPS (version de Powershell) : {0}" -f $VersionPS)
Write-Output ($oSeparation)																						## Fin du récapitulatif des variables
Write-Output (" ")																								## Insère une ligne blanche dans le fichier de log
#>
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
		Write-Output ("Le répertoire {0} n'existait pas, il a été créé" -f $oLIST_REP[$i].Value)
	}
	Else
	{
		## Le répertoire est présent, il n'y a rien à faire
		Write-Output ("Le répertoire {0} est présent" -f $oLIST_REP[$i].Value)
	}
}
Write-Output ($oSeparation)																						## Fin du test sur les répertoires
Write-Output (" ")																								## Insère une ligne blanche dans le fichier de log

## Partie principale du script

## Début du script

Titre "Générale" "**"

###############################################################################
##                                                                           ##
##                              Début du script                              ##
##                                                                           ##
###############################################################################

$dir = Get-Item .
$zipfilename = $folderUP + "\" + $dir.name + "-" + $Date_AAAAMMJJ_HHmm + "-archives.zip"
$Repertoire = $folderUP + "\" + $dir.name

$Message = "Nom du répertoire Archivé : $Repertoire"
Log $Message INFO 1
$Message = "Nom du fichier ZIP : $zipfilename"
Log $Message INFO 1

set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
(Get-ChildItem $zipfilename).IsReadOnly = $false
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace($zipfilename)
$input = Get-ChildItem -Path $Repertoire
 
    foreach($file in $input )
    {
        $Message = "Fichier ou Répertoire traité: $file"
        Log $Message INFO 1

        $zipPackage.CopyHere($file.FullName)
        Start-sleep -milliseconds 500
    }

###############################################################################
##                                    FIN                                    ##
###############################################################################

## Ne rien placer en dessous

Titre "FIN" "**"

Stop-Transcript
Exit 0