;; utility.nu
;; Utility classes

;; @class View
;; @description View that calculates positions from upper left
(class FlippedView is NSView
     (- (BOOL) isFlipped is
        t))

;; Methods for dealing with frames
(function frame-x (frame)
     (car frame))

(function frame-y (frame)
     (car (cdr frame)))

(function frame-width (frame)
     (car (cdr (cdr frame))))

(function frame-height (frame)
     (car (cdr (cdr (cdr frame)))))

;; @class NSObject
;; sometimes we have an object and just want to use it
;; instead of a keypath for it. Well, here is the key-
;; path identity.
(class NSObject
     (- (id)identity is
        self)
     
     (- (void)setIdentity:(id)new is
        (set self new)))

(class NSArray
     (- last is
        (self (- (self count) 1))))