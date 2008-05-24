;; @file critex.nu
;; @discussion Main Critex classes

(global PADDING 10) ;; Space between each textView

;; @class MyDocument
;; @discussion Each Critex document has textUnits and wikiPages
(class MyDocument is NSDocument
     (ivar (id) contentView)
     
     (- appendTextUnit:(id)sender is
        (NSLog "caught append"))
     
     (- (id)init is
        (super init)
        self)
     
     (- (id)windowNibName is "MyDocument")
     
     (- (void)windowControllerDidLoadNib:(id) aController is
        (super windowControllerDidLoadNib:aController)
        (@contentView addSubview:((TextUnitView alloc)
                                  initWithFrame:(list PADDING PADDING 500 200)
                                  TextUnit: ((SimpleTextUnit alloc) init))))
     
     (- (id)dataRepresentationOfType:(id)aType is)
     
     (- (BOOL)loadDataRepresentation:(id)data ofType:(id)aType is
        YES)
     
     (- (id) printOperationWithSettings:(id)printSettings error:(id *)errorReference is
        (NSPrintOperation printOperationWithView:@packerView printInfo:(self printInfo))))

;; @macro textview
;; @description create an appropriately sized and bound TextUnit and add
;; to the calling environments subviews.
(macro textview
     (set __text (eval (car margs)))
     (set __view ((NSTextView alloc) initWithFrame:(eval (car (cdr margs)))))
     (__view bind:"attributedString" toObject:__text withKeyPath:"string" options:nil)
     (self addSubview:__view)
     ((@textViews last) setNextKeyView:__view)
     (__view setNextKeyView: (@textViews 0))
     (__view setDelegate:self)
     (@textViews << __view))

;; @class TextUnitView
;; @description View class creates and arranges all text views for a TextUnit
;; also handles responder chain actions that target a whole TextUnit.
(class TextUnitView is FlippedView
     (ivar (id) textUnit
           (id) textViews
           (id) noteViews)
     
     (- appendTextUnit:(id)sender is
        ())
     
     (- (BOOL)textView:(id)aTextView doCommandBySelector:(SEL)aSelector is
        (NSLog "called do commandSelector for #{aSelector}")
        (if (eq aSelector "insertTab:")
            (then
                 ((aTextView window) selectNextKeyView:self)
                 (NSLog "#{(aTextView window)}")
                 t)
            (else nil)))
     
     (- (id)initWithFrame:(NSRect)frame TextUnit:(id)tu is
        (super initWithFrame:frame)
        (set @textUnit tu)
        
        (textview ((@textUnit texts) 0) '(0    0 140  50))
        (textview ((@textUnit texts) 1) '(150  0 150  50))
        (textview ((@textUnit notes) 0) '(0   55 300  20))
        (textview ((@textUnit notes) 1) '(0   80 300  20))
        self)
     
     (- drawRect:(NSRect)rect is)
     
     (- dealloc is
        (@textUnit release)))
;; NuParseError: no open sexpr
;; NuParseError: no open sexpr

;; @class TextUnit
;; @description A single block of text with multiple texts and note streams
(class TextUnit is NSObject
     (ivar (id)  texts
           (id)  notes
           (int) level)
     
     (ivar-accessors)
     
     ;; init and dealloc
     (- (id)init is
        (super init)
        (set @texts ((NSMutableArray alloc) init))
        (set @notes ((NSMutableArray alloc) init))
        self)
     
     (- dealloc is
        (texts release)
        (notes reelase)))

;; @class SimpleTextUnit
;; @description A text unit with text, translation, glosses and notes
(class SimpleTextUnit is TextUnit
     (- (id) init is
        (super init)
        (@texts addObject:((NSAttributedString alloc) initWithString:"Hello"))
        (@texts addObject:((NSAttributedString alloc) initWithString:"Hi there"))
        (@notes addObject:((NSAttributedString alloc) init))
        (@notes addObject:((NSAttributedString alloc) init))
        self))
