###############################################################################
## NOM: fDisque.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 08/11/2018
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
	Cette fonction permet de récupérer les informations sur les disques.	
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
##                                 LDTaille                                  ##
###############################################################################

# Function LDTaille($Disque)
# {
# 	##
# 	## Cette fonction permet de retrouver les informations sur les disques
# 	##
# 	If ($Disque)
# 	{
# 		Write-Host ("Voici les informations pour le disque {0}:." -f $Disque) -ForegroundColor Blue
# 		$Lecteurs = Get-PSDrive | Where-Object {($_.Name -match "$Disque") -and ($_.Provider -match "FileSystem")}
# 		$Lecteurs
# 	}
# 	Else 
# 	{
# 		Titre "-- Utilisation de Get-PSDrive --" "**"
# 		Write-Host ("Voici les informations pour tous les disques système.") -ForegroundColor Blue
# 		$Lecteurs = Get-PSDrive | Where-Object {$_.Provider -match "FileSystem"}
# 		$Lecteurs
# 		#Titre "-- Utilisation de Win32_logicaldisk -- " "**"
# 		#Get-WmiObject Win32_logicaldisk -ComputerName "localhost"
# 	}
# }

Function LDTaille($Disque)
{
	# ###############################################################################
	# ##                                    Titre                                  ##
	# ###############################################################################

	# $ScriptFonction = "fTitre.ps1"
	# Try {
	# 	. $REP_LIB\$ScriptFonction
	# }
	# Catch {
	# 	$oFichier = New-Object system.IO.FileInfo "$REP_LIB\$ScriptFonction"
	# 	If ($oFichier.Get_Exists())
	# 	{
	# 		$Message = "Il y a une erreur dans le script " + $ScriptFonction + ".`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	# 	}
	# 	Else {
	# 		$Message = "Le script " + $ScriptFonction + " n'a pas pu être lancé car il n'existe pas.`nLe script " + $NAME_SCRIPT + ".ps1 est arrêté."
	# 	}
		
	# 	Write-Host ($Message) -ForeGroundColor Red
		
	# 	Exit 2000
	# }

	# Titre "TEST" "**"

	Write-Host ("==> {0} ---" -f $Disque) -ForegroundColor Blue
	If ($Disque -like "*:*")
	{
		## Le paramètre donné est une arborescence
		## Nous allons donc récupéré le lecteur logique.
		Titre "Récupération du lecteur logique" "**"
		Write-Host ("{0} : est une arborescence." -f $Disque) -ForegroundColor Blue
		Write-Host ("Nous allons donc récupérer le lecteur.") -ForegroundColor Blue
		$Disque = $Disque.Split(":")[0]
		Write-Host ("Le lecteur est : {0}" -f $Disque) -ForegroundColor Blue
	}
	##
	## Cette fonction permet de retrouver les informations sur les disques
	##
	If ($Disque)
	{
		Titre "Récupération de la taille du volume : $Disque" "**"
		Write-Host ("Voici les informations pour le disque {0}:." -f $Disque) -ForegroundColor Blue
		$Lecteurs = Get-PSDrive | Where-Object {($_.Name -match "$Disque") -and ($_.Provider -match "FileSystem")}
		$Lecteurs
	}
	Else 
	{
		Titre "-- Utilisation de Get-PSDrive --" "**"
		Write-Host ("Voici les informations pour tous les disques système.") -ForegroundColor Blue
		$Lecteurs = Get-PSDrive | Where-Object {$_.Provider -match "FileSystem"}
		$Lecteurs
		#Titre "-- Utilisation de Win32_logicaldisk -- " "**"
		#Get-WmiObject Win32_logicaldisk -ComputerName "localhost"
	}
}