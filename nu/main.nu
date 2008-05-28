;; main.nu
;; Main launch-point code from Tim Burks' Nu examples

(load "nu")      	;; essentials
(load "cocoa")		;; wrapped frameworks
(load "Nu:console")
(load "utility")
(load "critex")

(global DEBUG t)    ;; turn off to remove log messages

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
