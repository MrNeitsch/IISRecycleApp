#Form created to stop, start and recycle sites and their associated application pool. - bneitsch

Import-Module WebAdministration
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form 
$form.Text = "Data Entry Form"
$form.Size = New-Object System.Drawing.Size(300,200) 
$form.StartPosition = "CenterScreen"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10) 
$label.Size = New-Object System.Drawing.Size(280,30) 
$label.Text = "Please enter Site Name then Action`r`n(i.e: ALL,STOP,START,RECYCLE)"
$form.Controls.Add($label) 

$textBox = New-Object System.Windows.Forms.TextBox 
$textBox.Location = New-Object System.Drawing.Point(10,40) 
$textBox.Size = New-Object System.Drawing.Size(260,20) 
$form.Controls.Add($textBox) 

$textBox2 = New-Object System.Windows.Forms.TextBox 
$textBox2.Location = New-Object System.Drawing.Point(10,70) 
$textBox2.Size = New-Object System.Drawing.Size(260,20) 
$form.Controls.Add($textBox2) 


$form.Topmost = $True


$form.Add_Shown({$textBox.Select()})
$form.Add_Shown({$textBox2.Select()})

$result = $form.ShowDialog()


if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    
    $site = $textBox.Text
    $status = $textBox2.Text
    
}



   
    $site = $site
    $status = $status


    $pool = (Get-Item "IIS:\Sites\$site"| Select-Object applicationPool).applicationPool
    if ($status -eq "stop") {
    Stop-WebAppPool $pool 
    Stop-WebSite $site 
    [System.Windows.Forms.MessageBox]::Show($site+" has been STOPPED","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning) 
    }
    elseif ($status -eq "start") {
    Start-WebAppPool $pool
    Start-WebSite $site
    [System.Windows.Forms.MessageBox]::Show($site+" has been RESTARTED","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning) 
    }
    elseif ($status -eq "recycle") {
    Restart-WebAppPool $pool
    [System.Windows.Forms.MessageBox]::Show($site+" has been RECYCLED","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning) 
    }
	elseif ($status -eq "all") {
    Restart-Service W3SVC -Force 
    [System.Windows.Forms.MessageBox]::Show("IIS has been RECYCLED","Title",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning) 
    }
  