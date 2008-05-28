;; main.nu
;; Main launch-point code from Tim Burks' Nu examples

(load "Nu:nu")      	;; essentials
(load "Nu:cocoa")		;; wrapped frameworks
(load "Nu:console")

(load "attribute-names") ;; globals for Apple attribute name strings
(load "utility")    
(load "critex")

(global DEBUG t)    ;; turn off to remove log messages

;; seed random (should be in App delegate)
(NuMath srandom:((NSCalendarDate calendarDate) timeIntervalSince1970))

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
