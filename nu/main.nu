;; main.nu
;; Main launch-point code from Tim Burks' Nu examples

(load "nu")      	;; essentials
(load "cocoa")		;; wrapped frameworks
(load "console")

(load "attribute-names") ;; globals for Apple attribute name strings
(load "utility")
(load "critex")

(global DEBUG t)    ;; turn off to remove log messages

(set SHOW_CONSOLE_AT_STARTUP nil)

(class AppDelegate is NSObject
     (- applicationDidFinishLaunching: (id) sender is
        (set $console ((NuConsoleWindowController alloc) init))
        (if SHOW_CONSOLE_AT_STARTUP ($console toggleConsole:self))
        (NuMath srandom:((NSCalendarDate calendarDate) timeIntervalSince1970))))


((NSApplication sharedApplication) setDelegate:(set $delegate ((AppDelegate alloc) init)))
((NSApplication sharedApplication) activateIgnoringOtherApps:YES)
(NSApplicationMain 0 nil)

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
