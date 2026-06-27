Unicode true
Name "T-Embed"
OutFile "build\qT-EmbedSetup.exe"
InstallDir "$PROGRAMFILES64\T-Embed"
RequestExecutionLevel admin
Icon "application\assets\icons\qtembed.ico"
SetCompressor /solid lzma

Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "Install"
  SetOutPath "$INSTDIR"
  File /r "build\qtembed\*"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  CreateShortCut "$DESKTOP\T-Embed.lnk" "$INSTDIR\qtembed.exe" "" "$INSTDIR\qtembed.exe" 0
  CreateShortCut "$SMPROGRAMS\T-Embed.lnk" "$INSTDIR\qtembed.exe" "" "$INSTDIR\qtembed.exe" 0
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\T-Embed" "DisplayName" "T-Embed"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\T-Embed" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\T-Embed" "DisplayIcon" "$\"$INSTDIR\qtembed.exe$\""
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\T-Embed.lnk"
  Delete "$SMPROGRAMS\T-Embed.lnk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\T-Embed"
SectionEnd
