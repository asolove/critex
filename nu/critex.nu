;; @file critex.nu
;; @discussion Main Critex classes

(global PADDING 10) ;; Space between each textView

;; @class MyDocument
;; @discussion Each Critex document has textUnits and wikiPages
(class MyDocument is NSDocument
     
     (- (id)init is
        (super init)
        self)
     
     (- (void)dealloc is
        ((self windowControllers) release))
     
     ; (- (id)windowNibName is "MyDocument")
     (- makeWindowControllers is
        (set documentController ((DocumentController alloc) initWithWindowNibName:"Document"))
        (self addWindowController:documentController))
     
     (- (id)dataRepresentationOfType:(id)aType is)
     
     (- (BOOL)loadDataRepresentation:(id)data ofType:(id)aType is
        YES)
     
     (- (id) printOperationWithSettings:(id)printSettings error:(id *)errorReference is
        (NSPrintOperation printOperationWithView:@packerView printInfo:(self printInfo))))

;; @class DocumentController
;; @description Controls the main document view and its contained textUnits
(class DocumentController is NSWindowController
     (ivar (id) contentView
           (id) textUnits
           (id) textUnitViews
           (int) bottom)
     
     (- (void)contentViewDidResize is
        ;; might consider limiting this to only after mouseup
        (@textUnitViews each: (do (textUnitView)
                                  (textUnitView reframeTextAreas))))
     
     (- windowDidLoad is
        (set @bottom 0)
        (set @textUnitViews ((NSMutableArray alloc) init))
        (set @textUnits ((NSMutableArray alloc) init))
        ((NSNotificationCenter defaultCenter)
         addObserver:self
         selector:"contentViewDidResize"
         name:"NSViewFrameDidChangeNotification"
         object:@contentView)
        (self addNewTextUnitToEnd)
        (self addNewTextUnitToEnd))
     
     (- addNewTextUnitToEnd is
        (NSLog "adding new text unit")
        (set textUnit ((SimpleTextUnit alloc) init))
        (@textUnits << textUnit)
        (set textUnitView ((TextUnitView alloc)
                           initWithFrame:(list
                                              20
                                              (+ 30 @bottom)
                                              (- (frame-width (@contentView frame)) (* 2 20))
                                              20)
                           TextUnit: textUnit))
        (textUnitView setAutoresizingMask:2)
        (@textUnitViews << textUnitView)
        (@contentView addSubview:textUnitView)
        (set @bottom (+ @bottom 20 (frame-height (textUnitView frame)))))
     
     (- dealloc is
        ((NSNotificationCenter defaultCenter)
         removeObserver:self
         name:"NSViewFrameDidChangeNotification"
         object:@contentView)
        (@textUnits release)
        (@textUnitViews release)
        (@contentView release)))


;; @class TextUnitView
;; @description View class creates and arranges all text views for a TextUnit
;; also handles responder chain actions that target a whole TextUnit.
(class TextUnitView is FlippedView
     (ivar (id) textUnit
           (id) textViews
           (id) separator
           (id) noteViews)
     
     (- appendTextUnit:(id)sender is
        (set controller ((self window) windowController))
        (controller addNewTextUnitToEnd))
     
     (- reframeTextAreas is
        (set frame (self frame))
        (set width (frame-width frame))
        (set each-width (/ (- width (* (- (@textViews count) 1) PADDING))
                           (@textViews count)))
        (set top 0)
        (set left 0)
        (@textViews each: (do (textView)
                              (set height (frame-height (textView frame)))
                              (textView setFrame:(list left 0 each-width height))
                              (set left (+ left each-width PADDING))
                              (if (> height top) (set top height))))
        
        (set top (+ top PADDING))
        (@separator setFrame:(list 0 top width 2))
        (set top (+ top PADDING))
        
        (@noteViews each: (do (noteView)
                              (set height (frame-height (noteView frame)))
                              (noteView setFrame:(list 0 top width height))
                              (set top (+ top PADDING height))))
        (set frame (self frame))
        (self setFrame:(list (frame-x frame) (frame-y frame) (frame-width frame)
                             top))
        
        (self setNeedsDisplay:t))
     
     ;; delegate methods for textViews:
     
     ;; Intercept command key strokes
     (- (BOOL)textView:(id)aTextView doCommandBySelector:(SEL)aSelector is
        (if (eq aSelector "insertTab:")
            (then
                 ((aTextView window) selectNextKeyView:self)
                 t)
            (else nil)))
     
     ;; Intercept frame size changes
     (- textViewFrameDidChange is
        (self reframeTextAreas))
     
     ;; @macro textview
     ;; @description create an appropriately sized and bound TextUnit and add
     ;; to the calling environments subviews.
     (macro textview
          (set __text (eval (car margs)))
          (set __view ((NSTextView alloc) initWithFrame:(eval (car (cdr margs)))))
          (__view bind:"attributedString" toObject:__text withKeyPath:"identity" options:nil)
          (self addSubview:__view)
          (__view setDelegate:self)
          (__view setAllowsUndo:t)
          
          ((NSNotificationCenter defaultCenter)
           addObserver:self
           selector:"textViewFrameDidChange"
           name:"NSViewFrameDidChangeNotification"
           object:__view)
          __view) ;; return view so we can grab it
     
     ;; @macro arrangeKeyOrder
     ;; @description given an array of views, connect their nextKeyView in a circle
     (macro arrangeKeyOrder
          (set __views (eval (car margs)))
          (set __last_view (__views last))
          (__views each: (do (__view)
                             (__last_view setNextKeyView:__view)
                             (set __last_view __view))))
     
     (- (id)initWithFrame:(NSRect)frame TextUnit:(id)tu is
        (super initWithFrame:frame)
        (set @textUnit tu)
        (set @textViews ((NSMutableArray alloc) init))
        (set @noteViews ((NSMutableArray alloc) init))
        
        (@textViews << (textview ((@textUnit texts) 0) '(0    0 140  20)))
        (@textViews << (textview ((@textUnit texts) 1) '(150  0 150  20)))
        
        (set @separator ((NSBox alloc) initWithFrame:(list 0 25 300 1)))
        (@separator setBoxType: "NSBoxSeparator")
        (self addSubview:@separator)
        
        (@noteViews << (textview ((@textUnit notes) 0) '(0   30 300  15)))
        (@noteViews << (textview ((@textUnit notes) 1) '(0   50 300  15)))
        
        (arrangeKeyOrder (@textViews arrayByAddingObjectsFromArray:@noteViews))
        
        (self reframeTextAreas)
        self)
     
     (- drawRect:(NSRect)rect is)
     
     (- dealloc is
        (@textUnit release)
        (@textViews each: (do (view)
                              ((NSNotificationCenter defaultCenter)
                               removeObserver:self
                               name:"NSViewFrameDidChangeNotification"
                               object:view)))))

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
     (set textAttributes
          (NSDictionary
                       dictionaryWithObject:(NSFont fontWithName:"Baskerville" size:16)
                       forKey:"NSFont"))
     (set noteAttributes
          (NSDictionary
                       dictionaryWithObject:(NSFont fontWithName:"Baskerville" size:13)
                       forKey:"NSFont"))
     
     
     (- (id) init is
        (super init)
        
        
        (@texts addObject:((NSMutableAttributedString alloc)
                           initWithString:" "
                           attributes:textAttributes))
        (@texts addObject:((NSMutableAttributedString alloc)
                           initWithString:" "
                           attributes:textAttributes))
        (@notes addObject:((NSAttributedString alloc) initWithString:" "
                           attributes:noteAttributes))
        (@notes addObject:((NSAttributedString alloc) initWithString:" "
                           attributes:noteAttributes))
        self))
