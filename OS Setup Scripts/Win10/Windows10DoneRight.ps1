####################################################################################################
##                                                                                                ##
##		PowerShell Scripts for  Windows 10                                                        ##
##                                                                                                ##
##		Thought Process :                                                                         ##
##                                                                                                ##
##		1. Set logs so anything further on the system can be traced in the Logs                   ##
##		2. Secure System immediately by OS Hardening                                              ##
##		3. Backup System / Data                                                                   ##
##		4. Configure System preferences.                                                          ##
##		5. Setup Applications & App configurations                                                ##
##                                                                                                ##
####################################################################################################


function FuncOne {

    #Set Security Log size to 200Mb
    Limit-EventLog -LogName Security -MaximumSize 200Mb

}

FuncOne



$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write("secret message")
$writer.Flush()
$stringAsStream.Position = 0

Get-FileHash -InputStream $stringAsStream -Algorithm MD5| Select-Object Hash


