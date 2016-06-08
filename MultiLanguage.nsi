
; Request rights

  RequestExecutionLevel admin

  SetOverwrite on
; Includes

  !include "MUI2.nsh"
  !include "nsDialogs.nsh"
  !include "FileFunc.nsh"
  !include "LogicLib.nsh"
  !include "x64.nsh"

; Variables & stuff

  Unicode true
  
  Name "FOnline 2"
  OutFile "FOnline2.exe"

; Defines

!define CSIDL_PROGRAMFILES '0x26'


; GetWindowsVersion 4.1.1 (2015-06-22) - alternate script with server versions
 
!ifndef __GET_WINDOWS_VERSION_NSH
!define __GET_WINDOWS_VERSION_NSH



; StrContains
; This function does a case sensitive searches for an occurrence of a substring in a string. 
; It returns the substring if it is found. 
; Otherwise it returns null(""). 
; Written by kenglish_hi
; Adapted from StrReplace written by dandaman32
 
 
Var STR_HAYSTACK
Var STR_NEEDLE
Var STR_CONTAINS_VAR_1
Var STR_CONTAINS_VAR_2
Var STR_CONTAINS_VAR_3
Var STR_CONTAINS_VAR_4
Var STR_RETURN_VAR
 
Function StrContains
  Exch $STR_NEEDLE
  Exch 1
  Exch $STR_HAYSTACK
  ; Uncomment to debug
  ;MessageBox MB_OK 'STR_NEEDLE = $STR_NEEDLE STR_HAYSTACK = $STR_HAYSTACK '
    StrCpy $STR_RETURN_VAR ""
    StrCpy $STR_CONTAINS_VAR_1 -1
    StrLen $STR_CONTAINS_VAR_2 $STR_NEEDLE
    StrLen $STR_CONTAINS_VAR_4 $STR_HAYSTACK
    loop:
      IntOp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_1 + 1
      StrCpy $STR_CONTAINS_VAR_3 $STR_HAYSTACK $STR_CONTAINS_VAR_2 $STR_CONTAINS_VAR_1
      StrCmp $STR_CONTAINS_VAR_3 $STR_NEEDLE found
      StrCmp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_4 done
      Goto loop
    found:
      StrCpy $STR_RETURN_VAR $STR_NEEDLE
      Goto done
    done:
   Pop $STR_NEEDLE ;Prevent "invalid opcode" errors and keep the
   Exch $STR_RETURN_VAR  
FunctionEnd
 
!macro _StrContainsConstructor OUT NEEDLE HAYSTACK
  Push `${HAYSTACK}`
  Push `${NEEDLE}`
  Call StrContains
  Pop `${OUT}`
!macroend
 
!define StrContains '!insertmacro "_StrContainsConstructor"'


Function GetWindowsVersion
 
  Push $R0
  Push $R1
  Push $R2
 
  ClearErrors
 
  ; check if Windows NT family
  ReadRegStr $R0 HKLM \
  "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
 
  IfErrors 0 lbl_winnt
 
  ; we are not NT
  ReadRegStr $R0 HKLM \
  "SOFTWARE\Microsoft\Windows\CurrentVersion" VersionNumber
 
  StrCpy $R1 $R0 1
  StrCmp $R1 '4' 0 lbl_error
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '4.0' lbl_win32_95
  StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98
 
  lbl_win32_95:
    StrCpy $R0 '95'
  Goto lbl_done
 
  lbl_win32_98:
    StrCpy $R0 '98'
  Goto lbl_done
 
  lbl_win32_ME:
    StrCpy $R0 'ME'
  Goto lbl_done
 
  lbl_winnt:
 
  ; check if Windows is Client or Server.
  ReadRegStr $R2 HKLM \
  "SOFTWARE\Microsoft\Windows NT\CurrentVersion" InstallationType
 
  StrCpy $R1 $R0 1
 
  StrCmp $R1 '3' lbl_winnt_x
  StrCmp $R1 '4' lbl_winnt_x
 
  StrCpy $R1 $R0 3
 
  StrCmp $R1 '5.0' lbl_winnt_2000
  StrCmp $R1 '5.1' lbl_winnt_XP
  StrCmp $R1 '5.2' lbl_winnt_2003
  StrCmp $R1 '6.0' lbl_winnt_vista_2008
  StrCmp $R1 '6.1' lbl_winnt_7_2008R2
  StrCmp $R1 '6.2' lbl_winnt_8_2012
  StrCmp $R1 '6.3' lbl_winnt_81_2012R2
  StrCmp $R1 '6.4' lbl_winnt_10_2016 ; the early Windows 10 tech previews used version 6.4
 
  StrCpy $R1 $R0 4
 
  StrCmp $R1 '10.0' lbl_winnt_10_2016
  Goto lbl_error
 
  lbl_winnt_x:
    StrCpy $R0 "NT $R0" 6
  Goto lbl_done
 
  lbl_winnt_2000:
    Strcpy $R0 '2000'
  Goto lbl_done
 
  lbl_winnt_XP:
    Strcpy $R0 'XP'
  Goto lbl_done
 
  lbl_winnt_2003:
    Strcpy $R0 '2003'
  Goto lbl_done
 
  ;----------------- Family - Vista / 2008 -------------
  lbl_winnt_vista_2008:
    StrCmp $R2 'Client' go_vista
    StrCmp $R2 'Server' go_2008
 
    go_vista:
      Strcpy $R0 'Vista'
      Goto lbl_done
 
    go_2008:
      Strcpy $R0 '2008'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 7 / 2008R2 -------------
  lbl_winnt_7_2008R2:
    StrCmp $R2 'Client' go_7
    StrCmp $R2 'Server' go_2008R2
 
    go_7:
      Strcpy $R0 '7'
      Goto lbl_done
 
    go_2008R2:
      Strcpy $R0 '2008R2'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 8 / 2012 -------------
  lbl_winnt_8_2012:
    StrCmp $R2 'Client' go_8
    StrCmp $R2 'Server' go_2012
 
    go_8:
      Strcpy $R0 '8'
      Goto lbl_done
 
    go_2012:
      Strcpy $R0 '2012'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 8.1 / 2012R2 -------------
  lbl_winnt_81_2012R2:
    StrCmp $R2 'Client' go_81
    StrCmp $R2 'Server' go_2012R2
 
    go_81:
      Strcpy $R0 '8.1'
      Goto lbl_done
 
    go_2012R2:
      Strcpy $R0 '2012R2'
      Goto lbl_done
  ;-----------------------------------------------------
 
  ;----------------- Family - 10 / 2016 -------------
  lbl_winnt_10_2016:
    StrCmp $R2 'Client' go_10
    StrCmp $R2 'Server' go_2016
 
    go_10:
      Strcpy $R0 '10.0'
      Goto lbl_done
 
    go_2016:
      Strcpy $R0 '2016'
      Goto lbl_done
  ;-----------------------------------------------------
 
  lbl_error:
    Strcpy $R0 ''
  lbl_done:
 
  Pop $R2
  Pop $R1
  Exch $R0
 
FunctionEnd
 
!macro GetWindowsVersion OUTPUT_VALUE
	Call GetWindowsVersion
	Pop `${OUTPUT_VALUE}`
!macroend
 
!define GetWindowsVersion '!insertmacro "GetWindowsVersion"'
 
!endif






  !define MAIN_APP_EXE "FOnline 2.exe"
  !define APP_NAME "FOnline 2"
  !define COMP_NAME "FOnline 2 Team"
  !define VERSION "01.00.00.00"
  !define COPYRIGHT "FOnline 2 Team © 2016"
  !define DESCRIPTION "FOnline 2 Installation"
  !define INSTALLER_NAME "FOnline2.exe"
  !define WEB_SITE "http://fonline2.com"
; !define INSTALL_TYPE "SetShellVarContext all"
  !define REG_ROOT "HKCU"
  !define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"
  !define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
  !define MUI_ABORTWARNING
  !define MUSICFILE "worldmap.wav";
  !define MUI_ICON "fonline.ico";
  !define MUI_UNICON "fonline.ico";
  !define MUI_WELCOMEFINISHPAGE_BITMAP "fonline.bmp";
  !define MUI_LANGDLL_ALLLANGUAGES
  !ifdef REG_START_MENU
  !define MUI_STARTMENUPAGE_NODISABLE
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "FOnline 2"
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
;  !insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
  !endif

  VIProductVersion  "${VERSION}"
  VIAddVersionKey "ProductName"  "${APP_NAME}"
  VIAddVersionKey "CompanyName"  "${COMP_NAME}"
  VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
  VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
  VIAddVersionKey "FileVersion"  "${VERSION}"


;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\FOnline 2" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"



;Pages



 ; !include "Form1.nsdinc"

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "$(License_file)"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
; Page custom fnc_Form1_Show
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
 
 ; !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

 ; !insertmacro MUI_UNPAGE_FINISH


;--------------------------------
; Language constants




  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "Russian"



;Lang-strings

  

  LicenseLangString 	License_file    ${LANG_ENGLISH}	"D:\mason\readme_en.txt"
  LicenseLangString 	License_file    ${LANG_RUSSIAN}	"D:\mason\readme_ru.txt"

  LangString 	Lang_name    ${LANG_ENGLISH}	"engl"
  LangString 	Lang_name    ${LANG_RUSSIAN}	"russ"


  LangString 	FOnline2_Section_name	${LANG_ENGLISH}	"FOnline 2 client"
  LangString 	FOnline2_Section_name	${LANG_RUSSIAN}	"Клиент FOnline 2"


  LangString 	FOnline2_Section_desc	${LANG_ENGLISH}	"FOnline 2 client files and game data"
  LangString 	FOnline2_Section_desc	${LANG_RUSSIAN}	"Клиент FOnline 2 и все необходимое для игры"



    LangString 	Startmenu_Section_name	${LANG_ENGLISH}	"Start menu folder"
  LangString 	Startmenu_Section_name	${LANG_RUSSIAN}	"Папка в главном меню"


  LangString 	Startmenu_Section_desc	${LANG_ENGLISH}	"Create FOnline 2 start menu folder"
  LangString 	Startmenu_Section_desc	${LANG_RUSSIAN}	"Создание папки FOnline 2 в главном меню"
 

  LangString 	Desktop_Section_name	${LANG_ENGLISH}	"Shorcuts at desktop"
  LangString 	Desktop_Section_name	${LANG_RUSSIAN}	"Иконки на рабочем столе"


  LangString 	Desktop_Section_desc	${LANG_ENGLISH}	"Create shorcuts of FOnline 2 at desktop"
  LangString 	Desktop_Section_desc	${LANG_RUSSIAN}	"Создание иконок игры на рабочем столе"


;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL




;General

  ;Default installation folder


InstallDir "C:\FOnline 2"

  ;Get installation folder from registry if available
InstallDirRegKey HKCU "Software\FOnline 2" ""


;--------------------------------
;FOnline 2 install section

Section "$(FOnline2_Section_name)" SecFo


  SectionIn RO
  SetOutPath "$INSTDIR"

 
  ;ADD YOUR OWN FILES HERE...
  ;File "FOnline 2 D3D.exe"
  file /r "d:\Fonline2\*"

;  ${If} ${LANG_ENGLISH} = $Language
;  	File "en\FOnline.cfg"
;  ${Else}
;  	File "ru\FOnline.cfg"
;  ${EndIf}


FileOpen $9 FOnline.cfg w ;Opens a Empty File an fills it

FileWrite $9 "[Game Options]$\r$\n"		
FileWrite $9 "Language       			= $(Lang_name)$\r$\n"
FileWrite $9 "WinNotify 	     		= True$\r$\n"
FileWrite $9 "SoundNotify   	 		= False$\r$\n"
FileWrite $9 "InvertMessBox  			= False$\r$\n"
FileWrite $9 "Logging        			= True$\r$\n"
FileWrite $9 "LoggingTime    			= False$\r$\n"
FileWrite $9 "FixedFPS 			= 100$\r$\n"
FileWrite $9 "ScrollDelay 			= 30$\r$\n"
FileWrite $9 "ScrollStep 			= 30$\r$\n"
FileWrite $9 "TextDelay 			= 3000$\r$\n"
FileWrite $9 "AlwaysRun 			= True$\r$\n"
FileWrite $9 "RemoteHost 			= game.fonline2.com$\r$\n"
FileWrite $9 "RemotePort 			= 4000$\r$\n"

System::Call 'user32::GetSystemMetrics(i 0) i .r0'
System::Call 'user32::GetSystemMetrics(i 1) i .r1'

FileWrite $9 "ScreenWidth 			= $0$\r$\n"
FileWrite $9 "ScreenHeight 			= $1$\r$\n"
FileWrite $9 "Light 				= 20$\r$\n"
FileWrite $9 "FlushValue 			= 250$\r$\n"
FileWrite $9 "BaseTexture 			= 512$\r$\n"
FileWrite $9 "DoubleClickTime			= 1$\r$\n"
FileWrite $9 "FullScreen 			= True$\r$\n"
FileWrite $9 "VSync 				= False$\r$\n"
FileWrite $9 "AlwaysOnTop 			= False$\r$\n"
FileWrite $9 "Animation3dSmoothTime		= 0$\r$\n"
FileWrite $9 "Animation3dFPS 			= 0$\r$\n"
FileWrite $9 "MusicVolume 			= 73$\r$\n"
FileWrite $9 "SoundVolume 			= 77$\r$\n"
FileWrite $9 "DefaultCombatMode 		= 0$\r$\n"
FileWrite $9 "IndicatorType 			= 2$\r$\n"
FileWrite $9 "CombatMessagesType 		= 1$\r$\n"
FileWrite $9 "DamageHitDelay 			= 2000$\r$\n"
FileWrite $9 "MultiSampling 			= 0$\r$\n"
FileWrite $9 "FonlineDataPath		 	= .\data$\r$\n"
FileWrite $9 "$\r$\n"
FileWrite $9 "[Updater]$\r$\n"
FileWrite $9 "Source0=http://updater1.fonline2.com/updater.php$\r$\n"
FileWrite $9 "Source1=stream://updater2.fonline2.com/4040/2/$\r$\n"
FileWrite $9 "RandomSource=0$\r$\n"

FileClose $9 ;Closes the filled file
 
  ;Store installation folder
  WriteRegStr HKCU "Software\FOnline 2" "" $INSTDIR


   ${If} ${RunningX64}
    	SetRegView 64
  	${Else}
  		SetRegView 32
	${EndIf}
  
System::Call 'shell32::SHGetSpecialFolderPath(i $HWNDPARENT, t .r1, i ${CSIDL_PROGRAMFILES}, i0)i.r2'


${StrContains} $0 $1 $INSTDIR
${If} $0 == ""

${Else}
	
	
  ${GetWindowsVersion} $R0

  ${If} $R0 == "8.1"
   
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "^ RUNASADMIN"

  ${EndIf}

  ${If} $R0 == "10.0"
   
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "^ RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "^ RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "^ RUNASADMIN"

  ${EndIf}

  ${If} $R0 == "8"
   
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "~RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "~RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "~RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "~RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "~RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "~RUNASADMIN"

  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "~RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "~RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "~RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "~RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "~RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "~RUNASADMIN"


  ${EndIf}

  ${If} $R0 == "7"
   
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "RUNASADMIN"
  WriteRegStr HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "RUNASADMIN"

  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe" "RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat" "RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe" "RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe" "RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe" "RUNASADMIN"
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe" "RUNASADMIN"

  ${EndIf} 


${EndIf}
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "" "$INSTDIR\${MAIN_APP_EXE}"
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\FOnline 2.exe"
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "${VERSION}"
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"

 ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
 IntFmt $0 "0x%08X" $0
 WriteRegDWORD ${REG_ROOT} "${UNINSTALL_PATH}"  "EstimatedSize" "$0"



  !ifdef WEB_SITE
  WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
  !endif


SectionEnd




;--------------------------------
;Start menu

Section "$(Startmenu_Section_name)" SecSM

  createDirectory "$SMPROGRAMS\FOnline 2"
  createShortCut "$SMPROGRAMS\FOnline 2\FOnline 2.lnk" "$INSTDIR\FOnline 2.exe" "" "$INSTDIR\FOnline 2.exe"
  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Config.lnk" "$INSTDIR\FOConfig.exe" "" "$INSTDIR\FOConfig.exe"
  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Updater.lnk" "$INSTDIR\FOUpdater.exe" "" "$INSTDIR\Updater.exe"
 
 
SectionEnd
;--------------------------------
;Desktop

Section "$(Desktop_Section_name)" SecDe

CreateShortCut "$DESKTOP\FOnline 2.lnk" "$INSTDIR\FOnline 2.exe" "" "$INSTDIR\FOnline 2.exe" 0
; CreateShortCut "$DESKTOP\FOnline (Config).lnk" "$INSTDIR\FOConfig.exe" "" "$INSTDIR\FOConfig.exe" 0
 
SectionEnd

Section "-hidden" SecCo

 
!ifdef FalloutPath

CopyFiles "$R0\critter.dat" "$INSTDIR"
CopyFiles "$R0\master.dat" "$INSTDIR"

!endif


 
SectionEnd

;--------------------------------
;Installer Functions

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

  InitPluginsDir
  SetOutPath "$TEMP"
  SetShellVarContext current
  File "${MUSICFILE}"
  StrCpy $0 "$TEMP\${MUSICFILE}" ; location of the wav file
  IntOp $1 "SND_ASYNC" || 1
  System::Call 'winmm::PlaySound(t r0, i 0, i r1) b'


FunctionEnd


;--------------------------------
;Descriptions

  ;USE A LANGUAGE STRING IF YOU WANT YOUR DESCRIPTIONS TO BE LANGAUGE SPECIFIC

  ;Assign descriptions to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFo} "$(FOnline2_Section_desc)"
 
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSM} "$(Startmenu_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDe} "$(Desktop_Section_desc)"
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

 
;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  RMDir /r "$INSTDIR\*.*"    
  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\FOnline 2"

  DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
  DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
 


  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe"
  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat"
  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe"
  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe"
  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe"
  DeleteRegValue HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe"
  DeleteRegKey /ifempty HKLM "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOnline 2.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\CleanCache.bat"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOUpdater.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfig.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPL.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\FOConfigPT.exe"
  DeleteRegKey /ifempty HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"



  delete "$SMPROGRAMS\FOnline 2\FOnline Config.lnk"
  delete "$SMPROGRAMS\FOnline 2\FOnline 2.lnk"
  delete "$SMPROGRAMS\FOnline 2\FOnline Updater.lnk"

  rmDir "$SMPROGRAMS\FOnline 2"

  delete "$DESKTOP\FOnline (Config).lnk"
  delete "$DESKTOP\FOnline 2.lnk"


SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit

   ${If} ${RunningX64}
    	SetRegView 64
  	${Else}
  		SetRegView 32
	${EndIf}

  !insertmacro MUI_UNGETLANGUAGE

FunctionEnd
