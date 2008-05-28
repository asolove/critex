;; @file critex.nu
;; @discussion Main Critex classes

(global PADDING 10)     ;; Space between each textView
(global X_MARGIN 20)    ;;
(global Y_MARGIN 30)    ;;

;; @class MyDocument
;; @discussion Each Critex document has textUnits and wikiPages
(class MyDocument is NSDocument
     (ivar (id) textController
           (id) wikiController
           (id) textUnits
           (id) wikiPages)
     
     ;; init and dealloc
     (- (id)init is
        (super init)
        (set @textUnits ((NSMutableArray alloc) init))
        (set @wikiPages ((NSMutableArray alloc) init))
        self)
     
     (- (void)dealloc is
        ((self windowControllers) release))
     
     (- makeWindowControllers is
        (set @textController ((TextController alloc)
                              initWithWindowNibName:"TextWindow"
                              textUnits:@textUnits))
        (self addWindowController:@textController))
     
     ;; save and load
     (- (id)dataRepresentationOfType:(id)aType is
        (NSKeyedArchiver archivedDataWithRootObject:@textUnits))
     
     ;; FIXME: load doesn't seem to work.
     (- (BOOL)loadDataRepresentation:(id)data ofType:(id)aType is
        (debug "started to load representation")
        (set @textUnits (NSKeyedUnarchiver unarchiveObjectWithData:data))
        YES)
     
     (- (id) printOperationWithSettings:(id)printSettings error:(id *)errorReference is))

;; @class DocumentController
;; @description Controls the main document view and its contained textUnits
(class TextController is NSWindowController
     (ivar (id) contentView         ;; document view inside right-side scrollView
           (id) window              ;; need to set this in IB
           (id) textUnits           ;; array of TextUnit items
           (id) headerTableView     ;; TableView listing header TextUnits
           (id) textUnitViews)       ;; array of TextUnitViews
     
     (ivar-accessors)
     
     (- initWithWindowNibName:(id)name textUnits:(id)textUnits is
        (super initWithWindowNibName:name)
        
        (set @textUnitViews ((NSMutableArray alloc) init))
        (set @textUnits textUnits)
        self)
     
     (- (void)contentViewDidResize is
        ;; might consider limiting this to only after mouseup
        (@textUnitViews each: (do (textUnitView)
                                  (textUnitView reframeTextAreas))))
     
     ;; Set the frames of all textUnitViews to appropriate tops and heights
     ;; vertical sizes
     (- reframeAllTextUnitViews is
        (set top Y_MARGIN)
        (@textUnitViews each:
             (do (tuv)
                 (set frame (tuv frame))
                 (tuv setFrame:(list X_MARGIN
                                     (+ top PADDING)
                                     (frame-width frame)
                                     (frame-height frame)))
                 (+= top PADDING (frame-height frame))))
        (set frame (@contentView frame))
        (@contentView setFrame:(list (frame-x frame) (frame-y frame) (frame-width frame) top)))
     
     (- textUnitViewFrameDidChange is
        (self reframeAllTextUnitViews))
     
     ;; Data source methods for headerTableView
     ;; TODO: This should be an outlineView, but I'm afraid of NSTreeController
     (- (int)numberOfRowsInTableView:(id)tableView is
        (@textUnits count))
     
     ;; TODO: unless we switch to an outline view, should return strings with
     ;; variable formatting to display relative header levels
     (- (id)tableView:(id)tableView objectValueForTableColumn:(id)column row:(int) row is
        (set level ((@textUnits row) level))
        (+ (if (> level 0)
               (then (" " times:((@textUnits row) level)))
               (else (" " times:6)))
           (((((@textUnitViews row) textViews) 0) textStorage) string)))
     
     (- headerTableFont is
        (NSFont menuFontOfSize:0))
     
     ;; FIXME: this isn't getting called from the TextUnitView. Why?
     (- reloadHeaderTableData is
        (@headerTableView reloadData))
     
     ;; Setup views once the window is loaded
     (- windowDidLoad is
        ((NSNotificationCenter defaultCenter)
         addObserver:self
         selector:"contentViewDidResize"
         name:"NSViewFrameDidChangeNotification"
         object:@contentView)
        (self addNewTextUnitToEnd:self)
        (@headerTableView setDataSource:self))
     
     (- makeNextTextUnitFirstResponder:(id)previous is
        (set index (+ (@textUnitViews indexOfObject:previous) 1))
        (@window makeFirstResponder:(((@textUnitViews index) textViews) 0)))
     
     ;; @function textUnitForDocument
     ;; @description returns an initialized textUnit to be used in the document
     ;; TODO: Use document settings to choose appropriate TextUnit subclass
     (- (id)textUnitForDocument is
        ((SimpleTextUnit alloc) init))
     
     ;; Add Text Unit commands:
     
     (- addTextUnitAfter:(id)previous is
        (set index (@textUnitViews indexOfObject:previous))
        (self insertTextUnitAtIndex:(+ index 1)))
     
     (- addNewTextUnitToEnd:(id)sender is
        (self insertTextUnit: (self textUnitForDocument)
              atIndex:(@textUnits count)))
     
     (- removeTextUnitAtIndex:(int)index is
        (debug "removing at: #{index}")
        (set textUnit       (@textUnits index))
        (set textUnitView   (@textUnitViews index))
        
        ((NSNotificationCenter defaultCenter)
         removeObserver:self
         name:"textUnitViewFrameDidChange"
         object:textUnitView)
        
        (textUnitView removeFromSuperview)
        
        (set undo ((self document) undoManager))
        ((undo prepareWithInvocationTarget:self)
         insertTextUnit:textUnit
         atIndex:index)
        
        (unless (undo isUndoing) (undo setActionName:"Remove Text Block"))
        
        (@textUnits     removeObjectAtIndex:index)
        (@textUnitViews removeObjectAtIndex:index)
        (self reframeAllTextUnitViews))
     
     (- insertTextUnitAtIndex:(int)i is
        (self insertTextUnit: (self textUnitForDocument)
              atIndex:i))
     
     ;; @function insertTextUnit
     ;; @description: main insert Text Unit method, responsible for undo,
     ;; reformatting, adding observer, etc.
     (- insertTextUnit:(id) textUnit atIndex:(int)index is
        (set undo ((self document) undoManager))
        
        ((undo prepareWithInvocationTarget:self)
         removeTextUnitAtIndex:index)
        
        (unless (undo isUndoing)
                (undo setActionName:"Insert Text Block"))
        
        (@textUnits insertObject:textUnit atIndex:index)
        
        (set top (if (> index 0)
                     (then
                          (set frame ((@textUnitViews (- index 1)) frame))
                          (+ (frame-height frame) (frame-y frame)))
                     (else 0)))
        
        (set textUnitView ((TextUnitView alloc)
                           initWithFrame:(list
                                              X_MARGIN
                                              (+ Y_MARGIN top)
                                              (- (frame-width (@contentView frame)) (* 2 X_MARGIN))
                                              20)
                           TextUnit: textUnit))
        
        (textUnitView setAutoresizingMask:2)
        (@textUnitViews insertObject:textUnitView atIndex:index)
        (@contentView addSubview:textUnitView)
        ((NSNotificationCenter defaultCenter)
         addObserver:self
         selector:"textUnitViewFrameDidChange"
         name:"NSViewFrameDidChangeNotification"
         object:textUnitView)
        (@headerTableView reloadData)
        (self reframeAllTextUnitViews))
     
     
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
     
     (ivar-accessors)
     
     ;; Font styles. These should be in user preferences so they can be changed
     
     (set textAttributes
          (NSDictionary
                       dictionaryWithObject:(NSFont fontWithName:"Baskerville" size:16)
                       forKey:NSFontAttributeName))
     (set headerAttributes
          (NSDictionary
                       dictionaryWithObject:(NSFont fontWithName:"Baskerville" size:20)
                       forKey:NSFontAttributeName))
     (set noteAttributes
          (NSDictionary
                       dictionaryWithObject:(NSFont fontWithName:"Baskerville" size:13)
                       forKey:NSFontAttributeName))
     
     (- attributesForLevel:(int)level is
        (if (> level 0)
            (then headerAttributes)
            (else textAttributes)))
     
     
     ;; Note adding, finding, editing methods
     (- addGloss:(id)note is
        (set text ((@noteViews 0) textStorage))
        (text beginEditing)
        (text appendAttributedString:(note attributedString))
        (text endEditing))
     
     
     ;; Menu commands to intercept
     
     
     ;; setLevel command to set the relative header level of text.
     (- setHeaderLevel1:(id)sender is
        (self setLevel:1))
     (- setHeaderLevel2:(id)sender is
        (self setLevel:2))
     (- setHeaderLevel3:(id)sender is
        (self setLevel:3))
     (- setHeaderLevel0:(id)sender is
        (self setLevel:0))
     
     (- setLevel:(int)level is
        (set attributes (self attributesForLevel: level))
        (@textUnit setLevel:level)
        
        (@textViews each:(do (view)
                             (set text (view textStorage))
                             (text beginEditing)
                             (text addAttributes:attributes
                                   range:(list 0 (text length)))
                             (text endEditing)
                             (view setTypingAttributes:attributes)))
        (self setNeedsDisplay:t)
        (((self window) windowController) reloadHeaderTableData))
     
     ;; appendTextUnit to add another paragraph on to the end
     ;; TODO: add  addTextUnitAtRow:(int)row
     ;; This menu command is not in use. Instead using button/shortcut key
     (- addTextUnitAfterSelection:(id)sender is
        (((self window) windowController) addTextUnitAfter:self))
     
     ;; reframeTextAreas: called whenever the height of one changes
     ;; TODO: consider faster ways of doing this. Maybe in C instead of NSNumbers.
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
                              (+= left each-width PADDING)
                              (if (> height top) (set top height))))
        
        (+= top PADDING)
        (@separator setFrame:(list 0 top width 2))
        (+= top PADDING)
        
        (@noteViews each: (do (noteView)
                              (set height (frame-height (noteView frame)))
                              (noteView setFrame:(list 0 top width height))
                              (+= top PADDING height)))
        (set frame (self frame))
        (self setFrame:(list (frame-x frame) (frame-y frame) (frame-width frame)
                             top))
        
        (self setNeedsDisplay:t))
     
     ;; delegate methods for textViews:
     
     (- textDidEndEditing:(id)n is
        (((self window) windowController) reloadHeaderTableData))
     
     ;; Intercept command key strokes
     (- (BOOL)textView:(id)aTextView doCommandBySelector:(SEL)aSelector is
        (debug "#{aSelector}")
        (case aSelector
              ("insertTab:" ((aTextView window) selectNextKeyView:self))
              ("scrollPageDown:" (((aTextView window) windowController)
                                  makeNextTextUnitFirstResponder:self))
              (else nil)))
     
     ;; Intercept frame size changes
     (- textViewFrameDidChange is
        (self reframeTextAreas))
     
     (- (id)addTextViewBoundTo:(id)string withFrame:(NSRect)frame attributes:(id)attributes is
        (self addTextViewSubclass:DSTextView boundTo:string withFrame:frame attributes:attributes))
     
     (- (id)addNoteViewBoundTo:(id)string withFrame:(NSRect)frame attributes:(id)attributes is
        (self addTextViewSubclass:DSNoteView boundTo:string withFrame:frame attributes:attributes))
     
     (- (id)addTextViewSubclass:(id)class boundTo:(id)string withFrame:(NSRect)frame attributes:(id)attributes is
        (set view ((class alloc) initWithFrame:frame))
        (view bind:"attributedString" toObject:string withKeyPath:"identity" options:nil)
        (self addSubview:view)
        
        ;; would be nice if we could just get ligatures to always work
        ;; FIXME: but this isn't doing it
        ;;(__view setSelectedRange:(list 0 ((__view textStorage) length)))
        ;;(__view useStandardLigatures:self)
        
        (view setDelegate:self)
        (view setAllowsUndo:t)
        (view setTypingAttributes:attributes)
        
        ((NSNotificationCenter defaultCenter)
         addObserver:self
         selector:"textViewFrameDidChange"
         name:"NSViewFrameDidChangeNotification"
         object:view)
        view) ;; return view so we can grab it
     
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
        
        ;; TODO: More abstract system for specifying how a TextUnit
        ;; should be displayed. Horizontal and vertical grouping, ratios, etc.
        (@textViews << (self addTextViewBoundTo:((@textUnit texts) 0)
                             withFrame:'(0 0 140 20)
                             attributes:textAttributes))
        (@textViews << (self addTextViewBoundTo:((@textUnit texts) 1)
                             withFrame:'(150 0 150 20)
                             attributes:textAttributes))
        
        (set @separator ((NSBox alloc) initWithFrame:(list 0 25 300 1)))
        (@separator setBoxType: "NSBoxSeparator")
        (self addSubview:@separator)
        
        
        (@noteViews << (self addNoteViewBoundTo:((@textUnit notes) 0)
                             withFrame:'(0 30 300 15)
                             attributes:noteAttributes))
        
        (@noteViews << (self addTextViewBoundTo:((@textUnit notes) 1)
                             withFrame:'(0 50 300 15)
                             attributes:noteAttributes))
        
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
     
     ;; save and load
     (- encodeWithCoder:(id)coder is
        (coder encodeObject:@texts forKey:"texts")
        (coder encodeObject:@notes forKey:"notes")
        (coder encodeInt:   @level forKey:"level"))
     
     (- (id)initWithCoder:(id)coder is
        (super init)
        (self setTexts:(coder decodeObjectForKey:"texts"))
        (self setNotes:(coder decodeObjectForKey:"Notes"))
        (self setLevel:(coder decodeIntForKey:   "level")))
     
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
        
        (@texts addObject:((NSAttributedString alloc) init))
        (@texts addObject:((NSAttributedString alloc) init))
        (@notes addObject:((NSAttributedString alloc) init))
        (@notes addObject:((NSAttributedString alloc) init))
        self))

;; TODO: Add other TextUnitTypes

;; @class DSTextView
;; @description NSTextView suvclass with any additional features
;; I might want to add...
(class DSTextView is NSTextView
     (- addGlossForSelection:(id)sender is
        (set gloss ((DSNote alloc)
                    initWithLemma:(self selectedSubstring)
                    text:"there"))
        ((self superview) addGloss:gloss)))

;; @class DSNoteView
;; @description NSTextView subclass for displaying notes includres
;; methods for finding, appending, deleting DSNote objects to string.
(class DSNoteView is NSTextView
     )

;; @class DSNote
;; @description attributed string of a note with appropriate
;; information
(class DSNote is NSObject
     (ivar (id) attributedString)
     
     (ivar-accessors)
     
     
     (set lemmaAttributes
          (NSDictionary dictionaryWithObjects:(array (NSColor colorWithCalibratedRed:.9 green:.9 blue:.9 alpha:1)
                                                     (NSFont fontWithName:"Baskerville-Bold" size:13))
               forKeys: (array NSBackgroundColorAttributeName NSFontAttributeName)))
     
     (set noteAttributes
          (NSDictionary dictionaryWithObjects:(array (NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:1)
                                                     (NSFont fontWithName:"Baskerville" size:13))
               forKeys: (array NSBackgroundColorAttributeName NSFontAttributeName)))
     
     
     (- (id)initWithLemma:(id)lemma text:(id)text is
        (super init)
        (set lemma ((NSMutableAttributedString alloc) initWithString:lemma
                    attributes:lemmaAttributes))
        (set text ((NSAttributedString alloc) initWithString:" | #{text} "
                    attributes:noteAttributes))
        (debug "setting @aS")
        
        (lemma appendAttributedString:text)
        (set @attributedString lemma)
        (debug "end of init")
        self)
     
     (- string is
        (@attributedString string))
     
     (- dealloc is
        (@attributedString release)));; NuParseError: no open sexpr
