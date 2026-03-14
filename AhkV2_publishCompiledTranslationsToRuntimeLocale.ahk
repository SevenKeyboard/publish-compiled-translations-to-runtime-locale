#Requires AutoHotkey v2.0.0+
;==============================================================
; AhkV2_publishCompiledTranslationsToRuntimeLocale — Publishes I18n compiled translations into the L10nUtils runtime locale layout
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

    #Include <AhkV2_publishCompiledTranslationsToRuntimeLocale>
    ;  AhkV2_publishCompiledTranslationsToRuntimeLocale()
*/

class VersionManager_AhkV2_publishCompiledTranslationsToRuntimeLocale
{
    static _ := this._init()
    static _init()    {
        global
        AHKV2_PUBLISHCOMPILEDTRANSLATIONSTORUNTIMELOCALE_VERSION := "1.0.0"
    }
}
AhkV2_publishCompiledTranslationsToRuntimeLocale(domain?, locale?)    {
    if (isSet(domain) && trim(domain) == "")
        throw valueError("Parameter #1 of AhkV2_publishCompiledTranslationsToRuntimeLocale must not be empty.", -1)
    if (isSet(locale) && trim(locale) == "")
        throw valueError("Parameter #2 of AhkV2_publishCompiledTranslationsToRuntimeLocale must not be empty.", -1)
    languagesDir := A_ScriptDir "\languages"
    localeDir := A_ScriptDir "\locale"
    copiedCount := 0
    skippedCount := 0
    outputDebug("Publishing compiled translations to runtime locale...")
    /*
    from:   .\languages\<domain>\<locale>.mo
    to:     .\locale\<locale>.UTF-8\LC_MESSAGES\<domain>.mo
    */
    if (isSet(domain))    {                                                         ;  default
        if (isSet(locale))    {                                                     ;  es_ES
            sourcePath := languagesDir "\" domain "\" locale ".mo"                  ;  .\languages\default\es_ES.mo
            if (fileExist(sourcePath))    {
                targetDir := localeDir "\" locale ".UTF-8\LC_MESSAGES"              ;  .\locale\es_ES.UTF-8\LC_MESSAGES
                dirCreate(targetDir)
                targetPath := targetDir "\" domain ".mo"                            ;  .\locale\es_ES.UTF-8\LC_MESSAGES\default.mo
                fileCopy(sourcePath, targetPath, 1)
                ++copiedCount
                outputDebug('Success: Copied "' sourcePath '" to "' targetPath '".')
            }  else  {
                ++skippedCount
                outputDebug('Warning: Source file not found: "' sourcePath '".')
            }
            outputDebug("Done. Copied: " copiedCount ", Skipped: " skippedCount ".")
            return
        }
        loop files, languagesDir "\" domain "\*.mo", "F"
        {
            loopSourcePath := A_LoopFileFullPath                                    ;  .\languages\default\<locale>.mo
            splitPath(loopSourcePath,,,, &loopLocale)                               ;  <locale>
            loopTargetDir := localeDir "\" loopLocale ".UTF-8\LC_MESSAGES"          ;  .\locale\<locale>.UTF-8\LC_MESSAGES
            dirCreate(loopTargetDir)
            loopTargetPath := loopTargetDir "\" domain ".mo"                        ;  .\locale\<locale>.UTF-8\LC_MESSAGES\default.mo
            fileCopy(loopSourcePath, loopTargetPath, 1)
            ++copiedCount
            outputDebug('Success: Copied "' loopSourcePath '" to "' loopTargetPath '".')
        }
        outputDebug("Done. Copied: " copiedCount ", Skipped: " skippedCount ".")
        return
    }
    loop files, languagesDir "\*", "D"    {
        loopDomain := A_LoopFileName                                                ;  <domain>
        if (isSet(locale))    {                                                     ;  es_ES
            sourcePath := A_LoopFileFullPath "\" locale ".mo"                       ;  .\languages\<domain>\es_ES.mo
            if (fileExist(sourcePath))    {
                targetDir := localeDir "\" locale ".UTF-8\LC_MESSAGES"              ;  .\locale\es_ES.UTF-8\LC_MESSAGES
                dirCreate(targetDir)
                targetPath := targetDir "\" loopDomain ".mo"                        ;  .\locale\es_ES.UTF-8\LC_MESSAGES\<domain>.mo
                fileCopy(sourcePath, targetPath, 1)
                ++copiedCount
                outputDebug('Success: Copied "' sourcePath '" to "' targetPath '".')
            }  else  {
                ++skippedCount
                outputDebug('Warning: Source file not found: "' sourcePath '".')
            }
            continue
        }
        loop files, A_LoopFileFullPath "\*.mo", "F"
        {
            loopSourcePath := A_LoopFileFullPath                                    ;  .\languages\<domain>\<locale>.mo
            splitPath(loopSourcePath,,,, &loopLocale)                               ;  <locale>
            loopTargetDir := localeDir "\" loopLocale ".UTF-8\LC_MESSAGES"          ;  .\locale\<locale>.UTF-8\LC_MESSAGES
            dirCreate(loopTargetDir)
            loopTargetPath := loopTargetDir "\" loopDomain ".mo"                    ;  .\locale\<locale>.UTF-8\LC_MESSAGES\<domain>.mo
            fileCopy(loopSourcePath, loopTargetPath, 1)
            ++copiedCount
            outputDebug('Success: Copied "' loopSourcePath '" to "' loopTargetPath '".')
        }
    }
    outputDebug("Done. Copied: " copiedCount ", Skipped: " skippedCount ".")
}