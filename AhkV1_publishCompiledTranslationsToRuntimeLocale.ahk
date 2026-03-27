;@I18n-IgnoreFile
#Requires AutoHotkey v1.1.21+
;==============================================================
; AhkV1_publishCompiledTranslationsToRuntimeLocale — Publishes I18n compiled translations into the L10nUtils runtime locale layout
;
; GitHub: https://github.com/SevenKeyboard/publish-compiled-translations-to-runtime-locale
; Author: SevenKeyboard Ltd. (2026)
; License: The Unlicense
;
; Documentation / References:
;   I18n
;     https://github.com/SevenKeyboard/i18n
;   L10nUtils
;     https://github.com/SevenKeyboard/l10n-utils
;==============================================================

/*
Example Usage:

    This function is designed to be placed in the user library
    (or standard library) and called from the main script that
    publishes compiled translations for localization.

    During normal use, leave the call commented out.
    Uncomment it only when publishing compiled translations.

    ;  #Include <AhkV1_publishCompiledTranslationsToRuntimeLocale>
    ;  AhkV1_publishCompiledTranslationsToRuntimeLocale()
*/

/*
%A_MyDocuments%\
└─ AutoHotkey\
   └─ lib\
      └─ AhkV1_publishCompiledTranslationsToRuntimeLocale.ahk
my-app\
└─ MyApp.ahk
*/

class VersionManager_AhkV1_publishCompiledTranslationsToRuntimeLocale
{
    static _ := VersionManager_AhkV1_publishCompiledTranslationsToRuntimeLocale._init()
    _init()    {
        global
        AhkV1_PUBLISHCOMPILEDTRANSLATIONSTORUNTIMELOCALE_VERSION := "1.0.0"
    }
}
AhkV1_publishCompiledTranslationsToRuntimeLocale(domain := "UNSET_F74BFA06", locale := "UNSET_F74BFA06")    {
    if (domain !== "UNSET_F74BFA06" && trim(domain) == "")
        throw exception("Parameter #1 of AhkV1_publishCompiledTranslationsToRuntimeLocale must not be empty.", -1)
    if (locale !== "UNSET_F74BFA06" && trim(locale) == "")
        throw exception("Parameter #2 of AhkV1_publishCompiledTranslationsToRuntimeLocale must not be empty.", -1)
    if (domain == "UNSET_F74BFA06")
        domain := ""
    if (locale == "UNSET_F74BFA06")
        locale := ""
    languagesDir := A_ScriptDir "\languages"
    localeDir := A_ScriptDir "\locale"
    copiedCount := 0
    skippedCount := 0
    outputDebug % "Publishing compiled translations to runtime locale..."
    /*
    from:   .\languages\<domain>\<locale>.mo
    to:     .\locale\<locale>.UTF-8\LC_MESSAGES\<domain>.mo
    */
    if (domain !== "")    {                                                         ;  default
        if (locale !== "")    {                                                     ;  es_ES
            sourcePath := languagesDir "\" domain "\" locale ".mo"                  ;  .\languages\default\es_ES.mo
            if (fileExist(sourcePath))    {
                targetDir := localeDir "\" locale ".UTF-8\LC_MESSAGES"              ;  .\locale\es_ES.UTF-8\LC_MESSAGES
                fileCreateDir % targetDir
                targetPath := targetDir "\" domain ".mo"                            ;  .\locale\es_ES.UTF-8\LC_MESSAGES\default.mo
                fileCopy % sourcePath, % targetPath, 1
                ++copiedCount
                outputDebug % "Success: Copied """ sourcePath """ to """ targetPath """."
            }  else  {
                ++skippedCount
                outputDebug % "Warning: Source file not found: """ sourcePath """."
            }
            outputDebug % "Done. Copied: " copiedCount ", Skipped: " skippedCount "."
            return
        }
        loop Files, % languagesDir "\" domain "\*.mo", % "F"
        {
            loopSourcePath := A_LoopFileFullPath                                    ;  .\languages\default\<locale>.mo
            splitPath loopSourcePath,,,, loopLocale                                 ;  <locale>
            loopTargetDir := localeDir "\" loopLocale ".UTF-8\LC_MESSAGES"          ;  .\locale\<locale>.UTF-8\LC_MESSAGES
            fileCreateDir % loopTargetDir
            loopTargetPath := loopTargetDir "\" domain ".mo"                        ;  .\locale\<locale>.UTF-8\LC_MESSAGES\default.mo
            fileCopy % loopSourcePath, % loopTargetPath, 1
            ++copiedCount
            outputDebug % "Success: Copied """ loopSourcePath """ to """ loopTargetPath """."
        }
        outputDebug % "Done. Copied: " copiedCount ", Skipped: " skippedCount "."
        return
    }
    loop Files, % languagesDir "\*", % "D"
    {
        loopDomain := A_LoopFileName                                                ;  <domain>
        if (locale !== "")    {                                                     ;  es_ES
            sourcePath := A_LoopFileFullPath "\" locale ".mo"                       ;  .\languages\<domain>\es_ES.mo
            if (fileExist(sourcePath))    {
                targetDir := localeDir "\" locale ".UTF-8\LC_MESSAGES"              ;  .\locale\es_ES.UTF-8\LC_MESSAGES
                fileCreateDir % targetDir
                targetPath := targetDir "\" loopDomain ".mo"                        ;  .\locale\es_ES.UTF-8\LC_MESSAGES\<domain>.mo
                fileCopy % sourcePath, % targetPath, 1
                ++copiedCount
                outputDebug % "Success: Copied """ sourcePath """ to """ targetPath """."
            }  else  {
                ++skippedCount
                outputDebug % "Warning: Source file not found: """ sourcePath """."
            }
            continue
        }
        loop Files, % A_LoopFileFullPath "\*.mo", % "F"
        {
            loopSourcePath := A_LoopFileFullPath                                    ;  .\languages\<domain>\<locale>.mo
            splitPath loopSourcePath,,,, loopLocale                                 ;  <locale>
            loopTargetDir := localeDir "\" loopLocale ".UTF-8\LC_MESSAGES"          ;  .\locale\<locale>.UTF-8\LC_MESSAGES
            fileCreateDir % loopTargetDir
            loopTargetPath := loopTargetDir "\" loopDomain ".mo"                    ;  .\locale\<locale>.UTF-8\LC_MESSAGES\<domain>.mo
            fileCopy % loopSourcePath, % loopTargetPath, 1
            ++copiedCount
            outputDebug % "Success: Copied """ loopSourcePath """ to """ loopTargetPath """."
        }
    }
    outputDebug % "Done. Copied: " copiedCount ", Skipped: " skippedCount "."
}