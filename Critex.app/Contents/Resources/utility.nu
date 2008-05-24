;; utility.nu
;; Utility classes

;; @class View
;; @description View that calculates positions from upper left
(class FlippedView is NSView
     (- (BOOL) isFlipped is
        t))
