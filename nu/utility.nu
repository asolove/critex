;; utility.nu
;; Utility classes, functions, macros


;; @class View
;; @description View that calculates positions from upper left
(class FlippedView is NSView
     (- (BOOL) isFlipped is
        t))

;; @macro +=
;; sets the first argument to the sum of all arguments and returns
(macro +=
     (set (unquote (car margs))
          (eval (append (list +) margs))))

(macro debug
     (if (DEBUG)
         (NSLog (eval (car margs)))))

;; Functions for dealing with frames
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

;; @class NSArray
;; add a method for getting to the last object in an array
(class NSArray
     (- last is
        (self (- (self count) 1))))

;; @class NSString
;; add a method for repeating a string multiple times
(class NSString
     (- times:(int)n is
        (set string (self copy))
        (set result (self copy))
        (n times:(do (i)
                     (+= result string)))
        result))


