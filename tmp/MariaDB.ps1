#connection
 $driver = "MySQL ODBC 5.3 ANSI Driver"
 
 #$Server = "ip.add.re.ss"
 $Server = "172.20.10.2"
 #$DBName = "database"
 $User = "root"
 #$PW = "HaRdPaSsWoRd"
 $PW = ""

 # Connect to the database
 $Connection = New-Object System.Data.ODBC.ODBCConnection
 #$Connection.connectionstring = "DRIVER={MySQL ODBC 5.3 ANSI Driver};" +
 #   "Server = $Server;" +
 #   "Database = $DBName;" +
 #   "UID = $User;" +
 #   "PWD= $PW;" +
 #   "Option = 3"
 $Connection.connectionstring = "DRIVER={MySQL ODBC 5.3 ANSI Driver};" +
    "Server = $Server;" +
    "UID = $User;" +
    "PWD= $PW;" +
    "Option = 3"
 $Connection.Open()

 ##Exception calling "Open" with "0" argument(s): "ERROR [IM002] [Microsoft][Gestionnaire de pilotes ODBC] Source de données introuvable et nom de pilote non spécifié"
 

 $Query = "select * from call_log limit 2"
 $Command = New-Object System.Data.ODBC.ODBCCommand($Query, $Connection)
 $Reply = $Command.executescalar()