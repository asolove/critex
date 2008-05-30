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
     
     (ivar-accessors)
     
     ;; init and dealloc
     (- (id)init is
        (super init)
        (set @textUnits ((NSMutableArray alloc) init))
        (@textUnits << ((SimpleTextUnit alloc) init)) ; in case this is a new doc
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
        (set @textUnits (NSKeyedUnarchiver unarchiveObjectWithData:data))
        (debug "textUnits: #{(@textUnits count)}")
        YES)
     
     (- (id) printOperationWithSettings:(id)printSettings error:(id *)errorReference is))

;; @class DocumentController
;; @description Controls the main document view and its contained textUnits
(class TextController is NSWindowController
     (ivar (id) contentView         ;; document view inside right-side scrollView
           (id) window              ;; need to set this in IB
           (id) drawer
           (id) textUnits           ;; array of TextUnit items
           (id) savedTextUnits      ;; array of saved textUnits waiting to have views added
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
     
     (- toggleDrawer:(id)sender is
        (@drawer toggle:self))
     
     (- scrollToIndex:(int)index is
        (@contentView scrollPoint:(scroll-to-frame ((@textUnitViews index) frame))))
     
     (- tableViewSelectionDidChange:(id)n is
        (self scrollToIndex:(@headerTableView selectedRow)))
     
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
        (NSFont fontWithName:"Baskerville" size:13)
        ;(NSFont systemFontOfSize:13)
        ; FIXME: return nicer-looking font and change tableView rowHeight
        )
     
     ;; FIXME: this isn't getting called from the TextUnitView. Why?
     (- reloadHeaderTableData is
        (@headerTableView reloadData))
     
     ;; Setup views once the window is loaded
     (- windowDidLoad is
        (debug "did load window")
        ((NSNotificationCenter defaultCenter)
         addObserver:self
         selector:"contentViewDidResize"
         name:"NSViewFrameDidChangeNotification"
         object:@contentView)
        
        ;; display saved data being loaded
        (if @textUnits
            (debug "have text units")
            (@textUnits each: (do (textUnit)
                                  (self insertViewForTextUnit:textUnit)))
            (debug "finished showing text units"))
        
        (@headerTableView setDataSource:self)
        (@headerTableView setRowHeight:20)
        (@headerTableView setDelegate:self)
        (debug "finished loading window"))
     
     (- makeNextTextUnitFirstResponder:(id)previous is
        (self makeFirstResponderTextUnitIndex:
              (+ (@textUnitViews indexOfObject:previous) 1)))
     
     (- makePreviousTextUnitFirstResponder:(id)previous is
        (self makeFirstResponderTextUnitIndex:
              (- (@textUnitViews indexOfObject:previous) 1)))
     
     (- makeFirstResponderTextUnitIndex:(int)i is
        (debug "before compare")
        (< i 0)
        (>= i (@textUnitViews count))
        (debug "after compares")
        
        (unless (or (< i 0) (>= i (@textUnitViews count)))
                ((self window) makeFirstResponder:(((@textUnitViews i) textViews) 0)))
        ;; FIXME: Test if first responder is not in clipped view
        ;; and scroll
        ;(self scrollToIndex:i)
        
        (debug "end of make next...")
        )
     
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
        (self reframeAllTextUnitViews)
        (self makeFirstResponderTextUnitIndex:(- index 1)))
     
     (- insertTextUnitAtIndex:(int)i is
        (self insertTextUnit: (self textUnitForDocument)
              atIndex:i))
     
     ;; @function insertTextUnit
     ;; @description: main insert Text Unit method, responsible for undo,
     ;; reformatting, adding observer, etc.
     (- insertTextUnit:(id) textUnit atIndex:(int)index is
        
        (@textUnits insertObject:textUnit atIndex:index)
        (self insertViewForTextUnit:textUnit))
     
     (- insertViewForTextUnit:(id)textUnit is
        
        ;; can't call this unless textUnit is already in @textUnits
        (set index (@textUnits indexOfObject:textUnit))
        
        (set top (if (and (> (@textUnitViews count) 0) (> index 0))
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
        
        (self reframeAllTextUnitViews)
        (self makeFirstResponderTextUnitIndex:index))
     
     
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
     (- addGloss:(id)note forTextView:(id)textView is
        (set noteStorage ((@noteViews 0) textStorage))
        (noteStorage beginEditing)
        (noteStorage appendAttributedString:(note attributedString))
        (noteStorage endEditing)
        
        ((self window) makeFirstResponder:(@noteViews 0)))
     
     
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
                           3))
        (set top 0)
        (set left 0)
        ('(0 1) each: (do (i)
                          (set textView (@textViews i))
                          (set height (frame-height (textView frame)))
                          (textView setFrame:(list left 0 (* (+ 1 i) each-width) height))
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
              ("insertTab:" ((aTextView window) selectNextKeyView:self) t)
              ("insertBacktab:" ((aTextView window) selectPreviousKeyView:self) t)
              ("scrollPageDown:" (((aTextView window) windowController)
                                  makeNextTextUnitFirstResponder:self) t)
              ("scrollPageUp:" (((aTextView window) windowController)
                                makePreviousTextUnitFirstResponder:self) t)
              (else nil)))
     
     ;; Intercept frame size changes
     (- textViewFrameDidChange is
        (self reframeTextAreas))
     
     (- (id)addTextViewBoundTo:(id)object keyPath:(id)keyPath withFrame:(NSRect)frame attributes:(id)attributes is
        (self addTextViewSubclass:DSTextView boundTo:object keyPath:keyPath withFrame:frame attributes:attributes))
     
     (- (id)addNoteViewBoundTo:(id)object keyPath:(id)keyPath withFrame:(NSRect)frame attributes:(id)attributes is
        (self addTextViewSubclass:DSNoteView boundTo:object keyPath:keyPath withFrame:frame attributes:attributes))
     
     (- (id)addTextViewSubclass:(id)class boundTo:(id)object keyPath:(id)keyPath withFrame:(NSRect)frame attributes:(id)attributes is
        (set view ((class alloc) initWithFrame:frame))
        (view bind:"attributedString" toObject:object withKeyPath:keyPath options:nil)
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
     
     (- (id)initWithFrame:(NSRect)frame TextUnit:(id)textUnit is
        (super initWithFrame:frame)
        (set @textViews ((NSMutableArray alloc) init))
        (set @noteViews ((NSMutableArray alloc) init))
        
        ;; TODO: More abstract system for specifying how a TextUnit
        ;; should be displayed. Horizontal and vertical grouping, ratios, etc.
        (@textViews << (self addTextViewBoundTo:textUnit
                             keyPath:"mainText"
                             withFrame:'(0 0 100 20)
                             attributes:textAttributes))
        (@textViews << (self addTextViewBoundTo:textUnit
                             keyPath:"transText"
                             withFrame:'(110 0 190 20)
                             attributes:textAttributes))
        
        (set @separator ((NSBox alloc) initWithFrame:(list 0 25 300 1)))
        (@separator setBoxType: "NSBoxSeparator")
        (self addSubview:@separator)
        
        
        (@noteViews << (self addNoteViewBoundTo:textUnit
                             keyPath:"glossNotes"
                             withFrame:'(0 30 300 15)
                             attributes:noteAttributes))
        
        (@noteViews << (self addTextViewBoundTo:textUnit
                             keyPath:"footNotes"
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
(class SimpleTextUnit is NSObject
     (ivar (id) mainText
           (id) transText
           (id) footNotes
           (id) glossNotes
           (int)level)
     
     (ivar-accessors)
     
     
     (- encodeWithCoder:(id)coder is
        (debug "encoding text unit")
        (coder encodeObject:@mainText forKey:"mainText")
        (coder encodeObject:@transText forKey:"transText")
        (coder encodeObject:@footNotes forKey:"footNotes")
        (coder encodeObject:@glossNotes forKey:"glossNotes")
        (coder encodeInt:   @level forKey:"level")
        (debug "one string: #{@mainText}"))
     
     (- (id)initWithCoder:(id)coder is
        (debug "initing from encoder")
        (set @mainText (coder decodeObjectForKey:"mainText"))
        (set @transText (coder decodeObjectForKey:"transText"))
        (set @footNotes (coder decodeObjectForKey:"footNotes"))
        (set @glossNotes (coder decodeObjectForKey:"glossNotes"))
        (set @level (coder decodeIntForKey:"level"))
        (debug "one string: #{@mainText}")
        self)
     
     ;; init and dealloc
     (- (id)init is
        (super init)
        (set @mainText ((NSAttributedString alloc) init))
        (set @transText ((NSAttributedString alloc) init))
        (set @footNotes ((NSAttributedString alloc) init))
        (set @glossNotes ((NSAttributedString alloc) init))
        (set @level 0)
        self)
     
     (- dealloc is
        (@mainText release)
        (@transText release)
        (@footNotes release)
        (@glossNotes release)))

;; TODO: Add other TextUnitTypes

;; @class DSTextView
;; @description NSTextView suvclass
(class DSTextView is NSTextView
     
     ;; TODO: Add corresponding methods for footnotes
     
     (- addGlossForSelection:(id)sender is
        (set gloss ((DSNote alloc)
                    initWithLemma:(self selectedSubstring)
                    text:""))
        ((self textStorage) addAttribute:DSNoteIdAttribute value:(gloss id) range:(self selectedRange))
        ((self superview) addGloss:gloss forTextView:self)))

;; @class DSNoteView
;; @description NSTextView subclass for displaying notes includres
;; methods for finding, appending, deleting DSNote objects to string.
(class DSNoteView is NSTextView
     ;; TODO: Add methods to prevent selecting/deleting multiple notes
     
     )

;; @class DSNote
;; @description attributed string of a note with appropriate
;; information
(class DSNote is NSObject
     (ivar (id)  attributedString
           (int) id)
     
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
        (set @id (NuMath random))
        (set lemma ((NSMutableAttributedString alloc) initWithString:lemma
                    attributes:lemmaAttributes))
        (set text ((NSAttributedString alloc) initWithString:" | #{text} "
                   attributes:noteAttributes))
        
        (lemma appendAttributedString:text)
        (lemma addAttribute:DSNoteIdAttribute value:@id range:(list 0 (lemma length)))
        (set @attributedString lemma)
        self)
     
     (- string is
        (@attributedString string))
     
     (- dealloc is
        (@attributedString release)))
