#ATTENTION !! 
[void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
#NECESSITE UN MODULE MYSQL : https://dev.mysql.com/downloads/connector/net

Try
    {
    #$ConnStr = “server=172.20.10.2;uid=root;password=;database=glpi;Port=3306;Allow User Variables=True;”
    $ConnStr = “server=172.20.10.2;uid=root;Port=3306;Allow User Variables=True;”

    ##[MySql.Data.MySqlClient.MySqlConnection]: verify that the assembly containing this type is loaded.
    ##     pour 
    $ObjMysql = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnStr)

    $ObjMysql.Open()


    $req = "SET @id = ( select max(glpi_plugin_formcreator_answers.plugin_formcreator_forms_answers_id)
    from glpi_plugin_formcreator_answers);

    SELECT answers.answer Reponse
    FROM glpi_plugin_formcreator_questions AS questions
                              LEFT JOIN glpi_plugin_formcreator_answers AS answers
                                ON answers.plugin_formcreator_questions_id = questions.id
                              INNER JOIN glpi_plugin_formcreator_sections AS sections
                                ON questions.plugin_formcreator_sections_id = sections.id
                              where plugin_formcreator_forms_id = 3 and answers.plugin_formcreator_forms_answers_id = @id
                              GROUP BY questions.id
                              ORDER BY sections.order ASC,
                                       sections.id ASC,
                                       questions.order ASC"

    $SQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand($req,$ObjMysql)

    $MySQLDataAdaptater = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($SQLCommand)

    $MySQLDataSet = New-Object System.Data.DataSet

    $RecordCount = $MySQLDataAdaptater.Fill($MySQLDataSet)
    $OldString = $MySQLDataSet.Tables 


    $MySQLdataSet.Tables | ForEach-Object {
        $OldString = $_.Reponse
        $StringReplace = $OldString.Replace('\n','~')
        $StringSplit1=$StringReplace -split("~")

        $PRENOM=$StringSplit1[0]
        $NOM=$StringSplit1[1]
        $BOITEMAIL_PARTAGE=$StringSplit1[2]
        $INFO_COMP=$StringSplit1[3]

        }

     $ObjMysql.Close()
    } 

Catch
    {
    $err_detail = $_.Exception.Message
    $err = $err+ "`t Probleme connexion SQL requete  ==> $err_detail `n"
    echo "Probleme connexion SQL"
    exit
    }