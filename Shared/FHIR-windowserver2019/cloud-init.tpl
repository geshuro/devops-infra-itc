<powershell>
# Rename Machine
Rename-Computer -NewName "${windows_instance_name}" -Force;

# Install IIS
# Install-WindowsFeature -name Web-Server -IncludeManagementTools;

# Install Microsoft Edge Enterprise X64
md -Path $env:temp\edgeinstall -erroraction SilentlyContinue | Out-Null
$Download = join-path $env:temp\edgeinstall MicrosoftEdgeEnterpriseX64.msi
Invoke-WebRequest 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/a2662b5b-97d0-4312-8946-598355851b3b/MicrosoftEdgeEnterpriseX64.msi'  -OutFile $Download
Start-Process "$Download" -ArgumentList "/quiet"

# Restart machine
shutdown -r -t 10;
</powershell>