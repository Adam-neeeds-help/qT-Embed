Unicode true
Name "qFlipper Custom"
OutFile "build\qFlipperCustomSetup.exe"
InstallDir "$PROGRAMFILES64\qFlipper Custom"
RequestExecutionLevel admin
Icon "application\assets\icons\qFlipper-purple.ico"
SetCompressor /solid lzma

Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "Install"
  SetOutPath "$INSTDIR"
  File /r "build\qFlipper\*"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  CreateShortCut "$DESKTOP\qFlipper Custom.lnk" "$INSTDIR\qFlipper.exe" "" "$INSTDIR\qFlipper.exe" 0
  CreateShortCut "$SMPROGRAMS\qFlipper Custom.lnk" "$INSTDIR\qFlipper.exe" "" "$INSTDIR\qFlipper.exe" 0
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qFlipperCustom" "DisplayName" "qFlipper Custom"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qFlipperCustom" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qFlipperCustom" "DisplayIcon" "$\"$INSTDIR\qFlipper.exe$\""
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\qFlipper Custom.lnk"
  Delete "$SMPROGRAMS\qFlipper Custom.lnk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\qFlipperCustom"
SectionEnd
