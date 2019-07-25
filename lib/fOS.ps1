function Get-OSName
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('hostname')]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
     
    BEGIN
    {
    }
     
    PROCESS
    {
        foreach ($computer in $ComputerName)
        {
            try
            {
 
                $TimeToLive = Test-Connection $ComputerName -Count 1 -ErrorAction Stop | Select-Object -ExpandProperty ResponseTimeToLive
 
                $OS = Switch($TimeToLive)
                        {
                         {$_ -le 64} {"Linux"; break}
                         {$_ -le 128} {"Windows"; break}
                         {$_ -le 255} {"UNIX"; break}
                        }
                 
                $output = New-Object System.Object 
                $output | Add-Member -type NoteProperty -Name 'ComputerName'     -value $computer
                $output | Add-Member -type NoteProperty -Name 'OS'               -value $OS
                $output | Add-Member -type NoteProperty -Name 'IsError'          -value 'N'
                $output | Add-Member -type NoteProperty -Name 'Error'            -value $null
 
                Write-Output $output
 
 
            }
            catch 
            {
                $err = $_.Exception
 
                $output = New-Object System.Object 
                $output | Add-Member -type NoteProperty -Name 'ComputerName'     -value $computer
                $output | Add-Member -type NoteProperty -Name 'OS'               -value $null
                $output | Add-Member -type NoteProperty -Name 'IsError'          -value 'Y'
                $output | Add-Member -type NoteProperty -Name 'Error'            -value $err
                 
                Write-Output $output
 
                Write-Warning "$computer - $err"
            } 
        }
    }
     
    END {}
}