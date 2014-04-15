
;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "WinT Messenger Setup"
  OutFile "WinT Messenger Setup.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\WinT Messenger"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\WinT Messenger" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "WinT Messenger\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "WinT Messenger (required)" SecDummy

  SectionIn RO
  SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  File /r "WinT Messenger\*"
  
  ;Store installation folder
  WriteRegStr HKCU "Software\WinT Messenger" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\WinT Messenger"
  CreateShortCut "$SMPROGRAMS\WinT Messenger\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\WinT Messenger\WinT Messenger.lnk" "$INSTDIR\WinT Messenger.exe" "" "$INSTDIR\WinT Messenger.exe" 0
  CreateShortCut "$SMPROGRAMS\WinT Messenger\License.lnk" "$INSTDIR\License.txt" "" "$INSTDIR\License.txt" 0
  
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "Contains the WinT Messenger executable."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  
  RMDir "$SMPROGRAMS\WinT Messenger"
  Delete "$SMPROGRAMS\WinT Messenger\Uninstall.lnk"
  Delete "$SMPROGRAMS\WinT Messenger\WinT Messenger.lnk"
  Delete "$SMPROGRAMS\WinT Messenger\License.lnk"

  RMDir /r "$INSTDIR"

  DeleteRegKey HKCU "Software\WinT Messenger"

SectionEnd