#####################################################################################################################################################
#####################################################################################################################################################
write-host "starting"
# Force a garbae collection (to manage RAM usage):
[System.GC]::Collect()

#Add required assemblies for Native Systray Menu
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Add required assemblies For Big Menu
Add-Type -AssemblyName presentationframework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsFormsIntegration

#Add required assemblies For Sound
Add-Type -AssemblyName Microsoft.VisualBasic

#Add-Type -AssemblyName System.Windows.Input

# Create object for the systray 
$Systray_Tool_Icon          = New-Object System.Windows.Forms.NotifyIcon
$Systray_Tool_Icon.Text     = "MyBlobBox"
$Systray_Tool_Icon.Icon     = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\CompMgmtLauncher.exe") 
#$Systray_Tool_Icon.Icon     = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\First Aid box PNG Blue.png")
$Systray_Tool_Icon.Visible  = $true

$Systray_Tool_Icon.Add_Click({
    If ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
        [System.Windows.Forms.MessageBox]::Show("You clicked on the MyBlobBox Systray tool")  
    }

    If ($_.Button -eq [Windows.Forms.MouseButtons]::Middle) {
        [System.Windows.Forms.MessageBox]::Show("You unlocked Good Advice : Think In Systems — Not In Goals.`n`nInstead of focusing on the destination, focus on the process of getting to the destination. Work Smarter, not Harder. You will need systems for doing the work : routines, systems, and frameworks. This is especial True and transferable to Real life. Think about your own habits, they are one of your Inner Systems.`n`nLastly, keep Reviewing your Systems Quartyerly and improve beyond your wildest imagined poitential.`n`nLet that Sink in for a Sececond .... `n`nNow, get back to Work with that Wisdom you gained!!","You found a secret Menu!")     
    
    }
})

#Hide the PowerShell window in the systray tool
$windowcode                 = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow                = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null                       = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

###############################################################################################################################

# Create object for the Systray ContextMenuStrip
$contextmenu                = New-Object System.Windows.Forms.ContextMenuStrip

#1. Main Menu Entry   
$Menu_1_Creds               = $contextmenu.Items.Add("Credentials")
$Menu_1_Creds_Icon          = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Shield PNG Blue.png")
$Menu_1_Creds.Image         = $Menu_1_Creds_Icon

#1.1 Sub menu Entry
$Menu1_Creds_SubMenu1       = New-Object System.Windows.Forms.ToolStripMenuItem
$Menu1_Creds_SubMenu1.Text  = "Set Credentials"
$Menu1_Creds_SubMenu1.add_Click({ 

    [Microsoft.VisualBasic.Interaction]::Beep()

})

$Menu_1_Creds.DropDownItems.Add($Menu1_Creds_SubMenu1)

#1.2 Sub menu Entry
$Menu1_Creds_SubMenu2       = New-Object System.Windows.Forms.ToolStripMenuItem
$Menu1_Creds_SubMenu2.Text  = "Clear Credentials"
$Menu_1_Creds.DropDownItems.Add($Menu1_Creds_SubMenu2)

$Menu1_Creds_SubMenu2.add_Click({
    $ButtonType             = [System.Windows.MessageBoxButton]::YesNoCancel
    $MessageIcon            = [System.Windows.MessageBoxImage]::Warning
    $MessageBody            = "Are you sure you want to clear the saved Credentials?"
    $MessageTitle           = "Confirm Clearing Credntials"
 
    $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
    switch ($Result) {
        Yes     { Write-host "cleared" }
        No      { Break }
        Cancel  { Break }
    }
}) 


#2. Main Menu Entry 
$Menu_2_Add                 = $contextmenu.Items.Add("Add Data to Blob")
$Menu_2_Add_Icon            = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Arrow up PNG Blue.png")
$Menu_2_Add.Image           = $Menu_2_Add_Icon
$Menu_2_Add.add_Click({
    UserName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a Username", "New User", "$env:computername") 

}) 

#3. Main Menu Entry
$Menu_3_Delete              = $contextmenu.Items.Add("Delete Data From Blob")
$Menu_3_Delete_Icon         = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Stop PNG Blue.png")
$Menu_3_Delete.Image        = $Menu_3_Delete_Icon

#4. Main Menu Entry 
$Menu_4_Download            = $contextmenu.Items.Add("Download Blob to Local")
$Menu_4_Download_Icon       = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Download from cloud PNG Blue.png")
$Menu_4_Download.Image      = $Menu_4_Download_Icon

#5. Main Menu Entry 
$Menu_5_Sync                = $contextmenu.Items.Add("Sync Local and Blob")
$Menu_5_Sync_Icon           = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Up down arrows PNG Blue.png")
$Menu_5_Sync.Image          = $Menu_5_Sync_Icon

#6. Main Menu Entry 
$Menu_6_Restart             = $contextmenu.Items.Add("Restart the Tool")
$Menu_6_Restart_Icon        = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Repeat double arrow PNG Blue.png")
$Menu_6_Restart.Image       = $Menu_6_Restart_Icon


#7. Main Menu Entry 
$Menu_7_Exit                = $contextmenu.Items.Add("Exit")
#$Menu_7_Exit_Icon           = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\Shell32.exe")
$Menu_7_Exit_Icon           = [System.Drawing.Bitmap]::FromFile("F:\Dropbox\PowerShell\Azure\Storage - Blob\PNG\Power small PNG Blue.png")
$Menu_7_Exit.Image          = $Menu_7_Exit_Icon

#Make the mouse act like something is happening
#$Menu_7_Exit.Add_MouseEnter({ $Window.Cursor = [System.Windows.Input.Cursors]::Hand })
#Switch back to regular mouse
#$Menu_7_Exit.Add_MouseLeave({ $Window.Cursor = [System.Windows.Input.Cursors]::Arrow })

$Menu_7_Exit.add_Click({ 
    [System.Windows.Forms.Application]::Exit()
    Stop-Process $pid
    $lastExitCode = 0
})


$Systray_Tool_Icon.Visible  = $true

#Add the context menu object to our main systray tool object
$Systray_Tool_Icon.ContextMenuStrip = $contextmenu


#Create an application context for it to all run within.
$appContext                 = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)



###############################################################################################################################
###############################################################################################################################



# References : 
# http://www.systanddeploy.com/2020/09/build-powershell-systray-tool-with.html




# Acceditation:
# <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com></a></div>#
# https://www.flaticon.com/authors/dinosoftlabs 






<#
 
# Use a Garbage colection to reduce Memory RAM
# https://dmitrysotnikov.wordpress.com/2012/02/24/freeing-up-memory-in-powershell-using-garbage-collector/
# https://docs.microsoft.com/fr-fr/dotnet/api/system.gc.collect?view=netframework-4.7.2
[System.GC]::Collect()
 
# Create an application context for it to all run within - Thanks Chrissy
# This helps with responsiveness, especially when clicking Exit - Thanks Chrissy
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)


#####################################################################################################################################################

# Add icon the systray 
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "WPF Systray tool"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true
 
# Add menu users
$Menu_Users = New-Object System.Windows.Forms.MenuItem
$Menu_Users.Text = "User analysis"
 
# Add menu computers
$Menu_Computers = New-Object System.Windows.Forms.MenuItem
$Menu_Computers.Text = "Computer analysis"
 
# Add Restart the tool
$Menu_Restart_Tool = New-Object System.Windows.Forms.MenuItem
$Menu_Restart_Tool.Text = "Restart the tool (in 10secs)"
 
# Add menu exit
$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Exit"
 
# Add all menus as context menus
$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.ContextMenu = $contextmenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Users)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Computers)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Restart_Tool)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

#####################################################################################################################################################

# GUI to display for Users part
[xml]$XAML_Users =  
@"
<Controls:MetroWindow 
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"  
 xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
 Title="User part" Width="470" ResizeMode="NoResize" Height="300" 
 BorderBrush="DodgerBlue" BorderThickness="0.5" WindowStartupLocation ="CenterScreen">
 
    <Window.Resources>
        <resourcedictionary>
            <ResourceDictionary.MergedDictionaries>
                <resourcedictionary Source="$Current_Folder\resources\Icons.xaml" ></resourcedictionary>
                <resourcedictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" ></resourcedictionary>
                <resourcedictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" ></resourcedictionary>
                <resourcedictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" ></resourcedictionary>
                <resourcedictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Cobalt.xaml" ></resourcedictionary>
                <resourcedictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseLight.xaml" ></resourcedictionary>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
 
   <Controls:MetroWindow.LeftWindowCommands>
        <Controls:WindowCommands>
            <button>
                <stackpanel Orientation="Horizontal">
                    <rectangle Width="15" Height="15" Fill="{Binding RelativeSource={RelativeSource AncestorType=Button}, Path=Foreground}">
                        <Rectangle.OpacityMask>
                            <visualbrush Stretch="Fill" Visual="{StaticResource appbar_user}" ></visualbrush>       
                        </Rectangle.OpacityMask>
                    </Rectangle>     
                </StackPanel>
            </Button>    
        </Controls:WindowCommands> 
    </Controls:MetroWindow.LeftWindowCommands>  
 
    <grid> 
    </Grid>
</Controls:MetroWindow>        
"@
$Users_Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML_Users))
# Part to decvlare your controls from the User GUI 
$MyControl = $Users_Window.findname("MyControl") 

#####################################################################################################################################################

# Action when after a click on the main systray icon
$Main_Tool_Icon.Add_Click({     
    [System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Users_Window)
    If ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
     $Users_Window.WindowStartupLocation = "CenterScreen"
     $Users_Window.Show()
     $Users_Window.Activate() 
    }    
   })
    
   # Action after clicking on the Users context menu
   $Menu_Users.Add_Click({ 
    $Users_Window.WindowStartupLocation = "CenterScreen"
    [System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Users_Window)
    $Users_Window.ShowDialog()
    $Users_Window.Activate() 
   })
    
   # Action after clicking on the Computers context menu
   $Menu_Computers.Add_Click({
    [System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Computers_Window)
    $Computers_Window.Show()
    $Computers_Window.Activate() 
   })
    
   # Action after clicking on the Exit context menu
   $Menu_Exit.add_Click({
    $Main_Tool_Icon.Visible = $false
    $window.Close()
    Stop-Process $pid
   })

#####################################################################################################################################################

   # Close the Users GUI if it loses focus
$Users_Window.Add_Deactivated({
    $Users_Window.Hide() 
    $CustomDialog.RequestCloseAsync()
    # Close_modal_progress 
   })
    
   # Close the Computers GUI if it loses focus
   $Computers_Window.Add_Deactivated({
    $Computers_Window.Hide()
   })


   #####################################################################################################################################################

    # Action on the close button from the Users GUI
    $Users_Window.Add_Closing({
    $_.Cancel = $true
    [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Users_Window, "Oops :-(", "To close the window click out of the window !!!")     
    })
    
   # Action on the close button from the Computers GUI
   $Computers_Window.Add_Closing({
    $_.Cancel = $true
    [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Computers_Window, "Oops :-(", "To close the window click out of the window !!!")     
   })


   #####################################################################################################################################################


   # Action after clicking on the Restart context menu
$Menu_Restart_Tool.add_Click({
    $Restart = "Yes"
    start-process -WindowStyle hidden powershell.exe "C:\ProgramData\MyTool\MyPS1.ps1 '$Restart'" 
    
    $Main_Tool_Icon.Visible = $false
    $window.Close()
    Stop-Process $pid
    })



#>



