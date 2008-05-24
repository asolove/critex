;; main.nu
;; Main launch-point code from Tim Burks' Nu examples

(load "nu")      	;; essentials
(load "cocoa")		;; wrapped frameworks

(load "utility")
(load "critex")

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
