;; classes.nu
;; utility classes

(class FlippedView is NSView
     (- (BOOL) isFlipped is
        t)
        
    (- (void) woot is
        (NSLog "Inside flippedView")))
