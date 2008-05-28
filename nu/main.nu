;; main.nu
;; Main launch-point code from Tim Burks' Nu examples

(load "Nu:nu")      	;; essentials
(load "Nu:cocoa")		;; wrapped frameworks
(load "Nu:console")

(load "attribute-names") ;; globals for Apple attribute name strings
(load "utility")    
(load "critex")

(global DEBUG t)    ;; turn off to remove log messages

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
