<#
Initial settings derived from @WackyJacky101 youtube videos:
-[MY PUBG SETTINGS - Showing and explaining all my settings](https://youtu.be/MddquVCgYGY) - 2019-08-24
-[ALL MY SETTINGS - Mouse/Keybindings/Sound + MY GEAR - PUBG](https://youtu.be/yLjXnXurLlo) - 2020-09-17
#>

Set-strictMode -version latest

###############################################################################
# CONSTANTS
###############################################################################

# Windows Mouse Speed (0-20)
$newSpeed = 11 

# Path to PUBG Game User Settings file
$FileName = "$($env:localappdata)\TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini"

# PUBG SETTINGS --> GRAPHICS --> DISPLAY SETTINGS
$LobbyFrameRateLimitType = "Fixed_60"
$InGameFrameRateLimitType = "Unlimited"
$bUseInGameSmoothedFrameRate = "False"

# PUBG SETTINGS --> GRAPHICS --> ADVANCED SETTINGS
$ScreenScale = "100.000000"
$FpsCameraFov = "103.000000" # FPP Camera FOV
$sgAntiAliasingQuality = 4 # 1 for Low, 4 for Ultra, etc.
$sgPostProcessQuality = 1
$sgShadowQuality = 1
$sgTextureQuality = 4
$sgEffectsQuality = 1
$sgFoliageQuality = 4
$sgViewDistanceQuality = 2
$bSharpen = "False"
$bUseVSync = "False"
$bMotionBlur = "False"

# PUBG SETTINGS --> AUDIO --> SOUND
$bIsEnabledHrtfRemoteWeaponSound = "True" 

# PUBG SETTINGS --> CONTROLS --> MOUSE
$Normal = "32.000000" # General Sensitivity
$MouseVerticalSensitivityMultiplierAdjusted = "1.000000" # Vertical Sensitivity Multiplier
$Targeting = "32.000000" # Aim Sensitivity
$Scoping = "32.000000" # ADS Sensitivity
$ScopingMagnified = "42.000000"  # Scoping Sensitivity - WackyJacky's preference is 32
$bIsUsingPerScopeMouseSensitivity = "False" # Universal Sensitivtiy for All Scopes
$Scope2X = "32.000000"
$Scope3X = "32.000000"
$Scope4X = "32.000000"
$Scope6X = "32.000000"
$Scope8X = "32.000000"
$Scope15X = "32.000000"

# PUBG SETTINGS --> GAMEPLAY --> UI
$CrosshairColorString = "CUSTOM"
$CustomCrosshairColor = "(B=0,G=0,R=255,A=255)"

# PUBG SETTINGS --> GAMEPLAY --> FUNCTIONALITIES
$bUseFreeLookInterp = "True"  # Free Look
$bAutoReloadOnOutOfAmmoFire = "False"   # Auto Reload
$HGsFiringMode = "Normal"
$SMGsFiringMode = "FullAuto"
$ARsFiringMode = "FullAuto"
$DMRsFiringMode = "Normal"
$SecondarySMGsFiringMode = "Burst"
$SecondaryARsFiringMode = "Burst"
$bAutoEquipAttachmentByInteraction = "True"
$bAutoEquipAttachmentFromInventory = "True"

# PUBG SETTINGS --> GAMEPLAY --> REPLAY
$bUseClientReplay = "False"
$bUseKillCam = "False"

# PUBG SETTINGS --> GAMEPLAY --> NETWORK
$bShowNetworkInfo = "False"

###############################################################################
# SET WINDOWS MOUSE SPEED
###############################################################################
$winApi = add-type -name user32 -namespace tq84 -passThru -memberDefinition '
   [DllImport("user32.dll")]
    public static extern bool SystemParametersInfo(
       uint uiAction,
       uint uiParam ,
       uint pvParam ,
       uint fWinIni
    );
'

$SPI_SETMOUSESPEED = 0x0071
$null = $winApi::SystemParametersInfo($SPI_SETMOUSESPEED, 0, $newSpeed, 0)
set-itemProperty 'hkcu:\Control Panel\Mouse' -name MouseSensitivity -value $newSpeed -ErrorAction SilentlyContinue | Out-Null

###############################################################################
# DISABLE WINDOWS POINTER PRECISION
###############################################################################
$code=@'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
 public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, int[] pvParam, uint fWinIni);
'@
Add-Type $code -name Win32 -NameSpace System
[System.Win32]::SystemParametersInfo(4,0,0,2) | Out-Null

###############################################################################
# RESTORE DESIRED PUBG MOUSE SETTINGS
###############################################################################
$GameUserSettings = Get-Content -Path $FileName

# FOV Settings
$GameUserSettings2 = $GameUserSettings -replace "FpsCameraFov=\d+\.\d+","FpsCameraFov=$($FpsCameraFov)"

# Multiplier Settings
$GameUserSettings2 = $GameUserSettings2 -replace "MouseVerticalSensitivityMultiplierAdjusted=\d+\.\d+,",",MouseVerticalSensitivityMultiplierAdjusted=$($MouseVerticalSensitivityMultiplierAdjusted),"

# PerScope Settings
$GameUserSettings2 = $GameUserSettings2 -replace "bIsUsingPerScopeMouseSensitivity=(True|False)","bIsUsingPerScopeMouseSensitivity=$($bIsUsingPerScopeMouseSensitivity)"

# Sensitivty Settings
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Normal`",Sensitivity=\d+\.\d+,","SensitiveName=`"Normal`",Sensitivity=$($Normal),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Targeting`",Sensitivity=\d+\.\d+,","SensitiveName=`"Targeting`",Sensitivity=$($Targeting),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"ScopingMagnified`",Sensitivity=\d+\.\d+,","SensitiveName=`"ScopingMagnified`",Sensitivity=$($ScopingMagnified),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope2X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope2X`",Sensitivity=$($Scope2X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope3X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope3X`",Sensitivity=$($Scope3X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope4X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope4X`",Sensitivity=$($Scope4X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope6X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope6X`",Sensitivity=$($Scope6X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope8X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope8X`",Sensitivity=$($Scope8X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scope15X`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scope15X`",Sensitivity=$($Scope15X),"
$GameUserSettings2 = $GameUserSettings2 -replace "SensitiveName=`"Scoping`",Sensitivity=\d+\.\d+,","SensitiveName=`"Scoping`",Sensitivity=$($Scoping),"

# Audio Settings
$GameUserSettings2 = $GameUserSettings2 -replace "bIsEnabledHrtfRemoteWeaponSound=(True|False)","bIsEnabledHrtfRemoteWeaponSound=$($bIsEnabledHrtfRemoteWeaponSound)"


# Display Settings
$GameUserSettings2 = $GameUserSettings2 -replace "LobbyFrameRateLimitType=.*","LobbyFrameRateLimitType=$($LobbyFrameRateLimitType)"
$GameUserSettings2 = $GameUserSettings2 -replace "InGameFrameRateLimitType=.*","InGameFrameRateLimitType=$($InGameFrameRateLimitType)"
$GameUserSettings2 = $GameUserSettings2 -replace "bUseInGameSmoothedFrameRate=(True|False)","bUseInGameSmoothedFrameRate=$($bUseInGameSmoothedFrameRate)"
$GameUserSettings2 = $GameUserSettings2 -replace "ScreenScale=.*","ScreenScale=$($ScreenScale)"
$GameUserSettings2 = $GameUserSettings2 -replace ",FpsCameraFov=\d+\.\d+",",FpsCameraFov=$($FpsCameraFov)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.AntiAliasingQuality=.*","sg.AntiAliasingQuality=$($sgAntiAliasingQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.PostProcessQuality=.*","sg.PostProcessQuality=$($sgPostProcessQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.ShadowQuality=.*","sg.ShadowQuality=$($sgShadowQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.TextureQuality=.*","sg.TextureQuality=$($sgTextureQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.EffectsQuality=.*","sg.EffectsQuality=$($sgEffectsQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.FoliageQuality=.*","sg.FoliageQuality=$($sgFoliageQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "sg\.ViewDistanceQuality=.*","sg.ViewDistanceQuality=$($sgViewDistanceQuality)"
$GameUserSettings2 = $GameUserSettings2 -replace "bSharpen=(True|False)","bSharpen=$($bSharpen)"
$GameUserSettings2 = $GameUserSettings2 -replace "bUseVSync=(True|False)","bUseVSync=$($bUseVSync)"
$GameUserSettings2 = $GameUserSettings2 -replace "bMotionBlur=(True|False)","bMotionBlur=$($bMotionBlur)"
$GameUserSettings2 = $GameUserSettings2 -replace "bMotionBlur=(True|False)","bMotionBlur=$($bMotionBlur)"
$GameUserSettings2 = $GameUserSettings2 -replace "bUseClientReplay=(True|False)","bUseClientReplay=$($bUseClientReplay)"
$GameUserSettings2 = $GameUserSettings2 -replace "bUseKillCam=(True|False)","bUseKillCam=$($bUseKillCam)"
$GameUserSettings2 = $GameUserSettings2 -replace "CrosshairColorString=.*","CrosshairColorString=$($CrosshairColorString)"
$GameUserSettings2 = $GameUserSettings2 -replace "CustomCrosshairColor=.*","CustomCrosshairColor=$($CustomCrosshairColor)"
$GameUserSettings2 = $GameUserSettings2 -replace "bUseFreeLookInterp=.*","bUseFreeLookInterp=$($bUseFreeLookInterp)"
$GameUserSettings2 = $GameUserSettings2 -replace "bAutoReloadOnOutOfAmmoFire=(True|False)","bAutoReloadOnOutOfAmmoFire=$($bAutoReloadOnOutOfAmmoFire)"
$GameUserSettings2 = $GameUserSettings2 -replace "HGsFiringMode=(Normal|FullAuto|Burst)","HGsFiringMode=$($HGsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "SMGsFiringMode=(Normal|FullAuto|Burst)","SMGsFiringMode=$($SMGsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "ARsFiringMode=(Normal|FullAuto|Burst)","ARsFiringMode=$($ARsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "DMRsFiringMode=(Normal|FullAuto|Burst)","DMRsFiringMode=$($DMRsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "SecondarySMGsFiringMode=(Normal|FullAuto|Burst)","SecondarySMGsFiringMode=$($SecondarySMGsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "SecondaryARsFiringMode=(Normal|FullAuto|Burst)","SecondaryARsFiringMode=$($SecondaryARsFiringMode)"
$GameUserSettings2 = $GameUserSettings2 -replace "bAutoEquipAttachmentByInteraction=(True|False)","bAutoEquipAttachmentByInteraction=$($bAutoEquipAttachmentByInteraction)"
$GameUserSettings2 = $GameUserSettings2 -replace "bAutoEquipAttachmentFromInventory=(True|False)","bAutoEquipAttachmentFromInventory=$($bAutoEquipAttachmentFromInventory)"
$GameUserSettings2 = $GameUserSettings2 -replace "bShowNetworkInfo=(True|False)","bShowNetworkInfo=$($bShowNetworkInfo)"

# Commit Change to PUBG Settings File
$GameUserSettings2 | Out-File -FilePath "$($FileName)"

write-host "Settings applied to windows and pubg preference file $($FileName)."


# Also make sure soundlock settings are as preferred
$SL_Path = 'C:\Program Files (x86)\3 APPES\Sound Lock\SoundLock.exe'
$SL_AlwaysOnTop = 0
$SL_AutoEnable = 1
$SL_Channels = 16383  # Not yet sure what this value means
$SL_Mode = 0
$SL_SoundLevel  = 45

# stop the process
Get-Process 'SoundLock' | Stop-Process -Force

# Apply the preferred settings
set-itemProperty 'hkcu:\Software\3APPES\SoundLock' -name 'AlwaysOnTop' -value $SL_AlwaysOnTop -ErrorAction SilentlyContinue | Out-Null
set-itemProperty 'hkcu:\Software\3APPES\SoundLock' -name 'AutoEnable' -value $SL_AutoEnable -ErrorAction SilentlyContinue | Out-Null
set-itemProperty 'hkcu:\Software\3APPES\SoundLock' -name 'Channels' -value $SL_Channels -ErrorAction SilentlyContinue | Out-Null
set-itemProperty 'hkcu:\Software\3APPES\SoundLock' -name 'Mode' -value $SL_Mode -ErrorAction SilentlyContinue | Out-Null
set-itemProperty 'hkcu:\Software\3APPES\SoundLock' -name 'SoundLevel' -value $SL_SoundLevel -ErrorAction SilentlyContinue | Out-Null

# Restart the process
Start-Process -FilePath $SL_Path

