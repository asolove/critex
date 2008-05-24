;; Nukefile

;; Set resource paths:
(set @nu_files (filelist "^nu/.*\.nu$")) 	;; don't forget that filelist expects regular expressions.
(set @icon_files (filelist "^resources/.*icns$"))
(set @nib_files (filelist "^resources/English\.lproj/.*\.nib$"))

;; Unclear if I have to set these even with info.plist below
(set @application "Critex")
(set @application_identifier "ds.text.Critex")


;; specify the entire Info.plist here:
(set @info
     (dict "CFBundleDevelopmentRegion" "English"
           "CFBundleDocumentTypes"
           (array (dict "CFBundleTypeExtensions" (array "crtx")
                        "CFBundleTypeName" "DocumentType"
                        "CFBundleTypeRole" "Editor"
                        "NSDocumentClass" "MyDocument"))
           "CFBundleExecutable" "Critex"
           "CFBundleIdentifier" "ds.text.Critex"
           "CFBundleInfoDictionaryVersion" "6.0"
           "CFBundleName" "Critex"
           "CFBundlePackageType" "APPL"
           "CFBundleSignature" "????"
           "CFBundleVersion" "1.2"
           "NSAppleScriptEnabled" "YES"
           "NSMainNibFile" "MainMenu"
           "NSPrincipalClass" "NSApplication"))

(application-tasks)

(task "default" => "application")
