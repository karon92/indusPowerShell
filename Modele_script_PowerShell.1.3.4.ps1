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
.PARAMETER Aucun
    Pas besoin de paramètre.
.INPUTS
    Ce script utilise des fonctions qui se trouvent sous ./lib/ et dont voici la liste :
        - fFichiers.ps1
        - fListeVar.ps1
        - fLog.ps1
        - fTitre.ps1
.OUTPUTS
    Un fichier de log est généré sous le répertoire ./log/ et il porte le même nom que 
    le script avec l'extention .log
.EXAMPLE
	BackupIT.ps1
#>

###############################################################################
##                                                                           ##
##                                  FONCTIONS                                ##
##                                                                           ##
###############################################################################

## Les variables que l'on trouve dans cette partie sont insdipensables
## au bon fonctionnement des fonctions chargées juste en dessous.
## Certaines lignes définissant des variables sont commentées. C'est que la varible n'est pas 
## Obligatoire pour faire fonctionner le script dans son fonctionnement standard.
## Mais on peut décommenter ces lignes en cas de besoin.

##
## Arborescence
##

$REP_LOCAL = Get-Location																						## Répertoire courrant

$REP_LIB = "$REP_LOCAL\lib\"																					## Répertoire des librairies
$REP_LOG = "$REP_LOCAL\log\"																					## Répertoire des fichiers de log

##
## Nom du script
##

## Il y a un problème avec la ligne suivante qui ne retourne pas le nom du script 
## lorsqu'on l'utilise sous le plannificateur de tâches :
#$NAME_SCRIPT = $MyInvocation.InvocationName.Split("\")[1]														## Récupération du nom du script
## Au contraire la ligne suivante retourne le nom du script quelque soit l'utilisation :
$NAME_SCRIPT = $MyInvocation.MyCommand.Name																		## Récupération du nom du script
Write-Host "Nom du script avec extension : $NAME_SCRIPT" -ForeGroundColor Blue
If ($NAME_SCRIPT.length -gt 0)
{
	$Position = $NAME_SCRIPT.lastindexofany(".")
	If ($Position -gt 0) {$NAME_SCRIPT = $NAME_SCRIPT.substring(0,$Position)}
	Write-Host "Nom du script sans extension : $NAME_SCRIPT" -ForeGroundColor Blue
}

##
## Dates
##

$Date_AAAAMMJJ_HHmm = Get-Date -format yyyyMMdd_HHmm					## Date au format yyyyMMdd_HHmm
#$Date_AAAAMMJJ = Get-Date -format yyyyMMdd								## Date au format yyyyMMdd										## Date au format AAAAMMJJ

##
## Fichier de log
##

$FIC_LOG = $REP_LOG + $NAME_SCRIPT + "_" + $Date_AAAAMMJJ_HHmm + ".log"

###############################################################################
##                                Principale                                 ##
###############################################################################

##
## Cette partie du script est lancée une fois pour toute.
## Après pour lancer une fonction qui se trouve sous $REP_LIB, il faut taper la ligne suivante
##
## LPrincipale Nom_du_Script $REP_LIB $NAME_SCRIPT
##
## Nom_du_Script : correspond au nom du script ps1 sans l'extension
##
## Pour que la fonction ainsi lancée fonctionne il faut créer la fonction comme suit
## Function global:Nom_de_Fonction
## {
## 		...	
## }
## 
## Il ne faut pas oublier global
##

$ScriptFonction = "fPrincipale.ps1"
Try {
	. $REP_LIB\$ScriptFonction
}
Catch {
	$oFichier = New-Object system.IO.FileInfo "$REP_LIB\$ScriptFonction"
	If ($oFichier.Get_Exists())
	{
		$Message = "Il y a une erreur dans le script " + $ScriptFonction + ".`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	}
	Else {
		$Message = "Le script " + $ScriptFonction + " n'a pas pu être lancé car il n'existe pas.`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	}
	
    Write-Host ($Message) -ForeGroundColor Red
	
	Exit 6000
}

###############################################################################
##                                     Log                                   ##
###############################################################################

LPrincipale fLog $REP_LIB $NAME_SCRIPT

###############################################################################
##                                    Titre                                  ##
###############################################################################

LPrincipale fTitre $REP_LIB $NAME_SCRIPT

###############################################################################
##                     Liste les variables du script                         ##
###############################################################################

LPrincipale fListeVAR $REP_LIB $NAME_SCRIPT

ListeVAR Before																									## Liste les variables externes au script

###############################################################################
##                          Fonctions sur les fichiers                       ##
###############################################################################

## La fonction fichier a besoin de la fonction log pour fonctionner
## donc nous sommes obligé de la mettre après celle-ci

LPrincipale fFichiers $REP_LIB $NAME_SCRIPT 4000

###############################################################################
##                          Fonction sur les Disques                         ##
###############################################################################

##
## Cette fonction permet d'afficher les informations sur les disques.
##
## Ce script est utilisé en tapant la ligne suivante :
##
## LDTaille E
##
## ## Espace libre
## $Free = (LDTaille E).free
## $Free ## Espace libre en octet
##
## Pour l'utiliser, il faut décommenter les lignes suivantes : 
##
## Fonction créée le : 12/11/2018
## Par : Laurent DEVOUCOUX
##

<#
$ScriptFonction = "fDisque.ps1"
Try {
	. $REP_LIB\$ScriptFonction
}
Catch {
	$oFichier = New-Object system.IO.FileInfo "$REP_LIB\$ScriptFonction"
	If ($oFichier.Get_Exists())
	{
		$Message = "Il y a une erreur dans le script " + $ScriptFonction + ".`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	}
	Else {
		$Message = "Le script " + $ScriptFonction + " n'a pas pu être lancé car il n'existe pas.`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	}
	
	Write-Host ($Message) -ForeGroundColor Red
	
	#Out-File -FilePath $FIC_LOG -InputObject $Message -Append
	Exit 5000
}
#>

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

$MyVERSION = '0.0.1'
#$VERSION_Mod = '1.2'																							## Version du modèle

If ($VERSION.IsPresent)
{
	$MyVERSION
	Exit 0
}

## Cette partie rassemble toutes les variables utilisées dans la suite du script

##
## Divers
##

#$VersionPS = $PSVersionTable.PSVersion.Major																	## Version de PowerShell utilisée
$oSeparation = "*"*80

##
## La variable $MACHINE a été créée le 07/11/2018
## La ligne est à décommenter si vous voulez l'utiliser
## 

#$MACHINE = $env:COMPUTERNAME												   									## Récupère le nom de la machine

##
## Arborescence
##

#$REP_TMP = "$REP_LOCAL\tmp\"																					## Répertoire tmp

##
## Les variables $REP_IN et $REP_OUT ont été ajoutées le 23/04/2018
## Tous les fichiers qui sont utilisés en entrée devront être placés de préférence dans le répertoire $REP_IN
## Tandis que tous les fichiers qui sont utilisés en sortie devront être placés dans le répertoire $REP_OUT 
##

#$REP_IN  = "$REP_LOCAL\in"																						## Répertoire des fichiers en entrée
#$REP_OUT = "$REP_LOCAL\out"																				    ## Répertoire des fichiers en sortie

##
## La variable $REP_CONF a été créée le 07/11/2018
##

#$REP_CONF = "$REP_LOCAL\conf"

$oLIST_REP = Get-Variable REP* -Scope Script
$NBR_REP = $oLIST_REP.Count -1																					## Compte le nombre de variable REP*

##
## Fichiers
##

$oFichiers_log = Get-ChildItem $REP_LOG
$Nbr_Fichiers_Log_Avant = $oFichiers_log.Count
Get-ChildItem -Path $REP_LOG | Where-Object {($_.LastWriteTime -lt (get-date).AddMinutes(-10)) -and ($_.BaseName -match $NAME_SCRIPT)} | ForEach-Object {Remove-Item $REP_LOG/$_ -Force}
$oFichiers_log = Get-ChildItem $REP_LOG
$Nbr_Fichiers_Log_Apres = $oFichiers_log.Count
$Nbr_Fichiers_Log = $Nbr_Fichiers_Log_Avant - $Nbr_Fichiers_Log_Apres

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

##############################################################################
##                                    FIN                                    ##
###############################################################################

## Ne rien placer en dessous

Titre "FIN" "**"

Stop-Transcript
Exit 0