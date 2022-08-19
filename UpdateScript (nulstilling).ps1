
function Install-Drivers {

mmc devmgmt.msc

Write-Output "Tjekker internetforbindelse... `n " 

<# Script virker kun hvis der er forbindelse til internettet. Dette If statement tjekker og kører kun script 
   hvis der er forbindelse til internettet (ved at ping Googles server, så antager selvfølgelig også at Googles
   server er oppe. Hvis det viser sig at Googles server er nede, så har du nok andre ting at være bekymret for
   end hvorvidt dette script kan køre eller ej. #>

if ((test-connection 8.8.8.8 -Count 1 -Quiet)) {

    #Write-Verbose " `n Installerer Update modul... `n "
    #Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

    <# Tjekker om update modulet er installeret, og installerer kun hvis det ikke er #>
    if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
        Write-Output " `n Update modul er installeret. "
        } Else {
            <# Dette er modulet, der tiløjer funktionaliteten til at administrere
            Windows Updates i Powershell #>
            Write-Message " `n Installerer Update modul... `n "
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            Install-Module PSWindowsUpdate -Verbose -Confirm:$false -Force
            }

    Write-Output " `n Checker efter og installerer drivers. Vent venligst... `n "
    for ($i=1; $i -le 3; $i++) {

     Get-WindowsUpdate -Install -AutoReboot -UpdateType Driver -AcceptAll #-Verbose

     }

    Write-Output " `n Script er færdigt. Luk kommando vindue og åben genvejen igen hvis nødvendigt `n "
    $VerbosePreference = "SilentlyContinue"
    
    #Set-ExecutionPolicy -ExecutionPolicy Restricted
    
   } Else {

   <# Dette viser kun, hvis der ikke er nogen internetforbindelse #>

    Write-Error " `n Ingen internetforbindelse registreret. 
         Internet forbindelse kræves for at køre dette script. 
         Få forbindelse til internettet og kør scriptet igen. `n "
    $RestartScript= ""
    $RestartScript= Read-Host -Prompt "Genstart script? (Y/N):"
    if ($RestartScript -eq "y" -Or $RestartScript -eq "Y") {
        Install-Drivers
        }
        Else {
        exit
        }
    }

 }

 Install-Drivers
 Remove-Module PSWindowsUpdate
 exit
 #Uninstall-Module PSWindowsUpdate