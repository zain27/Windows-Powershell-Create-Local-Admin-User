param([string]$Username="LocalAdmin",[string]$GroupName="Administrators")
foreach($Computer in (Get-Content "file.txt"))
{
    
    # echo $Username
    $ADSI = [ADSI]("WinNT://$Computer")

    #username
    $NewUser = $ADSI.Create('User',$Username) 

    #input password
    $Password = Read-Host -Prompt "Enter password for $Username" -AsSecureString
    $BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Password)
    $_password = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)
    $NewUser.SetPassword(($_password))
    $NewUser.SetInfo()

    #set group
    $Group = $ADSI.Children.Find($GroupName, 'group')
    $Group.Add(("WinNT://$Computer/$Username"))
    $NewUser.SetInfo()

}