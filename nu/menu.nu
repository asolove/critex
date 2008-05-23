(set critex-application-menu
     '(menu "Main"
            (menu "Application"
                  ("About #{appname}" action:"orderFrontStandardAboutPanel:")
                  (separator)
                  (menu "Services")
                  (separator)
                  ("Hide #{appname}" action:"hide:" key:"h")
                  ("Hide Others" action:"hideOtherApplications:" key:"h" modifier:(+ NSAlternateKeyMask NSCommandKeyMask))
                  ("Show All" action:"unhideAllApplications:")
                  (separator)
                  ("Quit #{appname}" action:"terminate:" key:"q"))
            (menu "File"
                  ("New" action:"newView:" target:$delegate key:"n")
                  ("Close" action:"performClose:" key:"w"))
            (menu "Window"
                  ("Minimize" action:"performMiniaturize:" key:"m")
                  (separator)
                  ("Bring All to Front" action:"arrangeInFront:"))))