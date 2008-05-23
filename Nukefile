;; Nukefile for Nu demo application

;; source files
(set @nu_files 	  (filelist "^nu/.*nu$"))
(set @resources   (filelist "^resources/English\.lproj/[^/]*$"))

;; application description
(set @application 	       	   "Critex")
(set @application_identifier   "ds.text.Critex")

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
           "NSMainNibFile" "MainMenu"
           "NSPrincipalClass" "NSApplication"))


;; tasks
(compilation-tasks)
(application-tasks)
(task "default" => "application")
