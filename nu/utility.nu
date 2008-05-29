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

;; @macro array
;; returns NSMutableArray of all evaluated arguments
(macro array
    (set __array (NSMutableArray array))
    (margs each: (do (marg)
                    (__array << (eval marg))))
    __array)

;; Functions for dealing with frames
(function frame-x (frame)
     (car frame))

(function frame-y (frame)
     (car (cdr frame)))

(function frame-size (frame)
     (cdr (cdr frame)))
     
(function frame-origin (frame)
    (list (car frame) (car (cdr frame))))
    
(function scroll-to-frame (frame)
    (list (car frame) (- (car (cdr frame)) Y_MARGIN)))

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

(class NSTextView
     (- selectedSubstring is
        ((self attributedSubstringFromRange:(self selectedRange)) string)))

; (class NSTextView
;      (- initWithFrame:(NSRect)frame textStorageClass:(id)TextStorage is
;         (set storage ((TextStorage alloc) init))
;         (set layout ((NSLayoutManager alloc) init))
;         (storage addLayoutManager:layout)
;         (layout release)
;         (set container ((NSTextContainer alloc) initWithContainerSize:(frame-size frame)))
;         (layout addTextContainer:container)
;         (((self class) alloc) initWithFrame:frame textContainer:container)))
;
