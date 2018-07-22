
; Request admin rights

  RequestExecutionLevel admin
  SetOverwrite on

; Includes

  !include "MUI2.nsh"
  !include "nsDialogs.nsh"
  !include "FileFunc.nsh"
  !include "LogicLib.nsh"
  !include "x64.nsh"
  !include "DotNetChecker.nsh"

; Variables & stuff

  Unicode true
  
  Name "FOnline 2"
  OutFile "FOnline2Setup.exe"

; Defines

	!define CSIDL_PROGRAMFILES '0x26'

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

  !define MAIN_APP_EXE "FOnline 2.exe"
  !define APP_NAME "FOnline 2"
  !define COMP_NAME "FOnline 2 Team"
  !define VERSION "01.00.00.00"
  !define COPYRIGHT "FOnline 2 Team © 2016"
  !define DESCRIPTION "FOnline 2 Installation"
  !define INSTALLER_NAME "FOnline2.exe"
  !define WEB_SITE "http://fonline2.com"
  !define INSTALL_TYPE "SetShellVarContext all"
  !define REG_ROOT "SHCTX"
  !define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"
  !define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
  !define MUI_ABORTWARNING
  ;!define MUSICFILE "worldmap.wav";
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
  !endif

  VIProductVersion  "${VERSION}"
  VIAddVersionKey "ProductName"  "${APP_NAME}"
  VIAddVersionKey "CompanyName"  "${COMP_NAME}"
  VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
  VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
  VIAddVersionKey "FileVersion"  "${VERSION}"


;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "SHCTX" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\FOnline 2" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "$(License_file)"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

; Language constants

  !insertmacro MUI_LANGUAGE "English" ;first language is the default language
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "Russian"

;Lang-strings

  LicenseLangString 	License_file    ${LANG_ENGLISH}	"readme_en.txt"
  LicenseLangString 	License_file    ${LANG_RUSSIAN}	"readme_ru.txt"
  LicenseLangString 	License_file    ${LANG_POLISH}	"readme_pl.txt"
  LicenseLangString 	License_file    ${LANG_PORTUGUESE}	"readme_en.txt"

  LangString 	Lang_name    ${LANG_ENGLISH}	"engl"
  LangString 	Lang_name    ${LANG_RUSSIAN}	"russ"
  LangString 	Lang_name    ${LANG_POLISH}	  "pols"
  LangString 	Lang_name    ${LANG_PORTUGUESE}	  "ptbr"

  LangString 	Lang_name_short    ${LANG_ENGLISH}	"en"
  LangString 	Lang_name_short    ${LANG_RUSSIAN}	"ru"
  LangString 	Lang_name_short    ${LANG_POLISH}	  "pl"
  LangString 	Lang_name_short    ${LANG_PORTUGUESE}	  "pt"


  LangString    FOnline2_Section_name   ${LANG_ENGLISH} "FOnline 2 client"
  LangString    FOnline2_Section_name   ${LANG_RUSSIAN} "Клиент FOnline 2"
  LangString    FOnline2_Section_name   ${LANG_POLISH} "Klient FOnline 2"
  LangString    FOnline2_Section_name   ${LANG_PORTUGUESE} "Cliente FOnline 2"


  LangString    FOnline2_Section_desc   ${LANG_ENGLISH} "FOnline 2 client files and game data"
  LangString    FOnline2_Section_desc   ${LANG_RUSSIAN} "Клиент FOnline 2 и все необходимое для игры"
  LangString    FOnline2_Section_desc   ${LANG_POLISH} "Pliki klienta i gry FOnline 2"
  LangString    FOnline2_Section_desc   ${LANG_PORTUGUESE} "Arquivos do cliente FOnline 2 e dados do jogo"
 

  LangString    Startmenu_Section_name  ${LANG_ENGLISH} "Start menu folder"
  LangString    Startmenu_Section_name  ${LANG_RUSSIAN} "Папка в главном меню"
  LangString    Startmenu_Section_name  ${LANG_POLISH} "Start menu folder"
  LangString    Startmenu_Section_name  ${LANG_PORTUGUESE} "Pasta do menu Iniciar"

  LangString    Startmenu_Section_desc  ${LANG_ENGLISH} "Create FOnline 2 start menu folder"
  LangString    Startmenu_Section_desc  ${LANG_RUSSIAN} "Создание папки FOnline 2 в главном меню"
  LangString    Startmenu_Section_desc  ${LANG_POLISH} "Utwórz skrót FOnline 2 w start menu"
  LangString    Startmenu_Section_desc  ${LANG_PORTUGUESE} "Criar FOnline 2 na pasta do menu iniciar"


  LangString    Desktop_Section_name    ${LANG_ENGLISH} "Shorcuts at desktop"
  LangString    Desktop_Section_name    ${LANG_RUSSIAN} "Иконки на рабочем столе"
  LangString    Desktop_Section_name    ${LANG_POLISH} "Skrót na pulpicie"
  LangString    Desktop_Section_name    ${LANG_PORTUGUESE} "Atalhos no desktop"

  LangString    Desktop_Section_desc    ${LANG_ENGLISH} "Create shorcuts of FOnline 2 at desktop"
  LangString    Desktop_Section_desc    ${LANG_RUSSIAN} "Создание иконок игры на рабочем столе"
  LangString    Desktop_Section_desc    ${LANG_POLISH} "Utwórz skrót FOnline 2 na pulpicie"
  LangString    Desktop_Section_desc    ${LANG_PORTUGUESE} "Crie atalhos do FOnline 2 no desktop"
 

  LangString    DirectX_Section_name    ${LANG_ENGLISH} "DirectX installation"
  LangString    DirectX_Section_name    ${LANG_RUSSIAN} "Установка DirectX"
  LangString    DirectX_Section_name    ${LANG_POLISH} "Instalacja DirectX"
  LangString    DirectX_Section_name    ${LANG_PORTUGUESE} "Instalação DirectX"

  LangString    DirectX_Section_desc    ${LANG_ENGLISH} "DirectX installation"
  LangString    DirectX_Section_desc    ${LANG_RUSSIAN} "Установка DirectX"
  LangString    DirectX_Section_desc    ${LANG_POLISH} "Instalacja DirectX"
  LangString    DirectX_Section_desc    ${LANG_PORTUGUESE} "Instalação DirectX"


  LangString    DirectX_Section_running  ${LANG_ENGLISH}    "Running DirectX Web Setup..."
  LangString    DirectX_Section_running  ${LANG_RUSSIAN}    "Выполняется установка DirectX..."
  LangString    DirectX_Section_running  ${LANG_POLISH}    "Uruchamianie instalatora DirectX..."
  LangString    DirectX_Section_running  ${LANG_PORTUGUESE}    "Executando o DirectX Web Setup ..."

  LangString    DirectX_Section_finished    ${LANG_ENGLISH} "Finished DirectX Web Setup"
  LangString    DirectX_Section_finished    ${LANG_RUSSIAN} "Установка DirectX завершена"
  LangString    DirectX_Section_finished    ${LANG_POLISH} "Zakończono instalacje DirectX"
  LangString    DirectX_Section_finished    ${LANG_PORTUGUESE} "Configuração da Web do DirectX concluída"


  LangString    DotNET_Section_name ${LANG_ENGLISH} ".NET installation"
  LangString    DotNET_Section_name ${LANG_RUSSIAN} "Установка .NET"
  LangString    DotNET_Section_name ${LANG_POLISH} "Instalacja .NET"
  LangString    DotNET_Section_name ${LANG_PORTUGUESE} "Instalação do .NET"

  LangString    DotNET_Section_desc ${LANG_ENGLISH} ".NET installation"
  LangString    DotNET_Section_desc ${LANG_RUSSIAN} "Установка .NET"
  LangString    DotNET_Section_desc ${LANG_POLISH} "Instalacja .NET"
  LangString    DotNET_Section_desc ${LANG_PORTUGUESE} "Instalação do .NET"
 

  LangString    Updater_Section_name    ${LANG_ENGLISH} "Downloading latest updates"
  LangString    Updater_Section_name    ${LANG_RUSSIAN} "Установка последних обновлений"
  LangString    Updater_Section_name    ${LANG_POLISH} "Aktualizacja"
  LangString    Updater_Section_name    ${LANG_PORTUGUESE} "Baixando as últimas atualizações"

  LangString    Updater_Section_desc    ${LANG_ENGLISH} "Downloading latest updates"
  LangString    Updater_Section_desc    ${LANG_RUSSIAN} "Установка последних обновлений"
  LangString    Updater_Section_desc    ${LANG_POLISH} "Aktualizacja"
  LangString    Updater_Section_desc    ${LANG_PORTUGUESE} "Baixando as últimas atualizações"
 

  LangString    Updater_Section_running  ${LANG_ENGLISH}    "Downloading and installing latest updates"
  LangString    Updater_Section_running  ${LANG_RUSSIAN}    "Выполняется установка последних обновлений"
  LangString    Updater_Section_running  ${LANG_POLISH}    "Pobieranie i instalacja aktualizacji"
  LangString    Updater_Section_running  ${LANG_PORTUGUESE}    "Baixando e instalando as atualizações mais recentes"

  LangString    Updater_Section_finished    ${LANG_ENGLISH}  "Latest updates were downloaded and installed"
  LangString    Updater_Section_finished    ${LANG_RUSSIAN}  "Последние обновления установлены"
  LangString    Updater_Section_finished    ${LANG_POLISH}  "Aktualizacja została pobrana i zainstalowana"
  LangString    Updater_Section_finished    ${LANG_PORTUGUESE}  "Últimas atualizações foram baixadas e instaladas"


;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL


;Get installation folder from registry if available

  InstallDirRegKey HKCU "Software\FOnline 2" ""


;FOnline 2 install section

	Section "$(FOnline2_Section_name)" SecFo

	  SectionIn RO
	  SetOutPath "$INSTDIR"
	  file /r "game\*"

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
		FileWrite $9 "ProxyType 			= 0$\r$\n"
		FileWrite $9 "ProxyHost 			= $\r$\n"
		FileWrite $9 "ProxyPort 			= 0$\r$\n"
		FileWrite $9 "ProxyUser 			= $\r$\n"
		FileWrite $9 "ProxyPass 			= $\r$\n"

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
		FileWrite $9 "WindowName		 	= FOnline 2$\r$\n"
		FileWrite $9 "$\r$\n"
		FileWrite $9 "[Updater]$\r$\n"
		FileWrite $9 "Source0=http://updater1.fonline2.com/updater.php$\r$\n"
		FileWrite $9 "Source1=stream://updater2.fonline2.com/4040/2/$\r$\n"
		FileWrite $9 "RandomSource=0$\r$\n"

		FileClose $9 ;Closes the filled file
	 
	  ;Store installation folder

	  WriteRegStr SHCTX "Software\FOnline 2" "" $INSTDIR
	   ${If} ${RunningX64}
	    	SetRegView 64
	  	${Else}
	  		SetRegView 32
		${EndIf}
	  
		System::Call 'shell32::SHGetSpecialFolderPath(i $HWNDPARENT, t .r1, i ${CSIDL_PROGRAMFILES}, i0)i.r2'

		${StrContains} $0 $1 $INSTDIR
	  
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

; DirectX install section

	Section "$(DirectX_Section_name)" Sec_DXWEB
	                                                                              
		SetOutPath "$TEMP"
		File "dxwebsetup.exe"
		DetailPrint "$(DirectX_Section_running)"
		ExecWait '"$TEMP\dxwebsetup.exe" /Q'
		DetailPrint "$(DirectX_Section_finished)"                                                                                                                 
		Delete "$TEMP\dxwebsetup.exe"

	SectionEnd


; .NET install section


	Section "$(DotNET_Section_name)" Sec_DotNET

	  !insertmacro CheckNetFramework 20

	SectionEnd


; Updater section


	Section "$(Updater_Section_name)" Sec_Updater
	                                                                              
		DetailPrint "$(Updater_Section_running)"
		ExecWait '"$INSTDIR\FOUpdaterConsole.exe" /autoclose'
		DetailPrint "$(Updater_Section_finished)"

	SectionEnd


;Start menu section


	Section "$(Startmenu_Section_name)" SecSM

		createDirectory "$SMPROGRAMS\FOnline 2"
		createShortCut "$SMPROGRAMS\FOnline 2\FOnline 2.lnk" "$INSTDIR\FOnline 2.exe" "" "$INSTDIR\FOnline 2.exe"
		createShortCut "$SMPROGRAMS\FOnline 2\FOnline 2 D3D.lnk" "$INSTDIR\FOnline 2 D3D.exe" "" "$INSTDIR\FOnline 2 D3D.exe"

		${If} $(Lang_name) == "pols"
		  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Config.lnk" "$INSTDIR\FOConfigPL.exe" "" "$INSTDIR\FOConfigPL.exe"    
		${EndIf}

		${If} $(Lang_name) == "russ"
		  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Config.lnk" "$INSTDIR\FOConfig.exe" "" "$INSTDIR\FOConfig.exe"    
		${EndIf}

		${If} $(Lang_name) == "engl"
		  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Config.lnk" "$INSTDIR\FOConfig.exe" "" "$INSTDIR\FOConfig.exe"    
		${EndIf}

		${If} $(Lang_name) == "ptbr"
		  createShortCut "$SMPROGRAMS\FOnline 2\FOnline Config.lnk" "$INSTDIR\FOConfigPT.exe" "" "$INSTDIR\FOConfigPT.exe"    
		${EndIf}

		createShortCut "$SMPROGRAMS\FOnline 2\FOnline Updater.lnk" "$INSTDIR\FOUpdater.exe" "" "$INSTDIR\FOUpdater.exe"

	SectionEnd


;Desktop section

	Section "$(Desktop_Section_name)" SecDe
	  CreateShortCut "$DESKTOP\FOnline 2.lnk" "$INSTDIR\FOnline 2.exe" "" "$INSTDIR\FOnline 2.exe" 0
	SectionEnd



;Descriptions

  ;Assign descriptions to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFo} "$(FOnline2_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec_DXWEB} "$(DirectX_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec_DotNET} "$(DotNET_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec_Updater} "$(Updater_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSM} "$(Startmenu_Section_desc)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDe} "$(Desktop_Section_desc)"
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

 
;Uninstaller Section

	Section "Uninstall"

	  RMDir /r "$INSTDIR\*.*"    
	  RMDir "$INSTDIR"

	  DeleteRegKey /ifempty SHCTX "Software\FOnline 2"

	  DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
	  DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
	  delete "$SMPROGRAMS\FOnline 2\FOnline Config.lnk"
	  delete "$SMPROGRAMS\FOnline 2\FOnline 2.lnk"
	  delete "$SMPROGRAMS\FOnline 2\FOnline 2 D3D.lnk"
	  delete "$SMPROGRAMS\FOnline 2\FOnline Updater.lnk"

	  rmDir "$SMPROGRAMS\FOnline 2"

	  delete "$DESKTOP\FOnline 2.lnk"

	SectionEnd


;Installer init

	Function .onInit

	  !insertmacro MUI_LANGDLL_DISPLAY

		System::Call 'kernel32::GetLogicalDrives()i.r0'
		StrCpy $1 $windir 3 ; Fallback if things go wrong
		StrCpy $2 0
		StrCpy $4 65 ; 'A'
		loop:
	   	IntOp $3 $0 & 1
	   	${If} $3 <> 0
	      IntFmt $3 "%c:\" $4
	      System::Call 'kernel32::GetDiskFreeSpaceEx(tr3,*l.r5,*l,*l)i'
	      ${If} $5 L> $2
	          StrCpy $2 $5
	          StrCpy $1 $3
	      ${EndIf}
	   	${EndIf}
	   	IntOp $4 $4 + 1
	   	IntOp $0 $0 >> 1
	   	StrCmp $0 0 "" loop
		StrCpy $InstDir "$1Games\FOnline 2"

	  InitPluginsDir
	  SetOutPath "$TEMP"
	  SetShellVarContext all

	FunctionEnd



;Uninstaller init

	Function un.onInit
	   SetShellVarContext all
	   ${If} ${RunningX64}
	    	SetRegView 64
	  	${Else}
	  		SetRegView 32
		${EndIf}

	  !insertmacro MUI_UNGETLANGUAGE

	FunctionEnd
