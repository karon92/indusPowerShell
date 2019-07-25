###############################################################################
## NOM: fPrincipale.ps1
## AUTEUR: DEVOUCOUX Laurent, Econocom
## DATE DE CREATION : 07/12/2018
##
## DESCRIPTION : 
##
## MODIFICATIONS :
## DATE :		PAR :					OBSERVATIONS:
## 04/03/2019   Laurent DEVOUCOUX       Création de la fonction getFreeDrive
##
## VERSION 0.0.2 
##
##Requires -Version 2.0
###############################################################################

<#
.SYNOPSIS
	
.DESCRIPTION
	Cette fonction permet de lancer les autres fonctions.	
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
##                               Principale                                  ##
###############################################################################

Function LPrincipale($ScriptFonction,$REP_LIB,$NAME_SCRIPT,$EXIT)
{
    $ScriptFonction = $ScriptFonction + ".ps1"
    ## La ligne suivante permet de debugger les problèmes que l'on pourrait
    ## avoir sur le lancement des librarys
    #Write-Host ("Lancement du script : {0}" -f $ScriptFonction) -ForegroundColor Blue
    Try {
        . $REP_LIB\$ScriptFonction
        ## La ligne suivante permet de debugger les problèmes que l'on pourrait
        ## avoir sur le lancement des librarys        
        #Write-Host ("Lancement du script : {0} : OK" -f $ScriptFonction) -ForegroundColor Green
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
	
	    Exit $EXIT
    }

    $Message = "Lancement du script " + $ScriptFonction + " : OK"
    Log $Message INFO 1
}

###############################################################################
##                               Principale                                  ##
###############################################################################

Function getFreeDrive
{
    [char[]]$driveLetters = @([char]'E'..[char]'Z')
    foreach ($d in $driveLetters) {
        if(!(Test-Path -Path "$d`:" -IsValid)) {
            return $d
        }
    }
}