;; critex.nu
;; Main Critex files

;; @class MyDocument
;; @description The main document that contains both textUnits and wikiPages,
;; deferring control to the documentController and wikiController.
(class MyDocument is NSDocument
     (ivar (id) documentWindow
           (id) documentController
           (id) textUnits
           (id) wikiPages)
     
     
     
     ;;; Init, dealloc,
     (- (id) init is
        (super init))
     
     (- (id) dealloc is
        (@textUnits release)
        (@wikipages release)
        (super dealloc))
     
     (- (id)makeWindowControllers is
        (set @documentController ((DocumentController alloc) init))
        (self addWindowController:@documentController))
     
     (- (void)windowControllerDidLoadNib:(id) aController is
        (super windowControllerDidLoadNib:aController)
        (@documentController windowControllerDidLoadNib:aController)))

(class DocumentController is NSWindowController
     (ivar (id) scrollView          ;; main scroll view for document
           (id) contentView         ;; scroll view's content view
           (id) contentsTableView)  ;; side contents panel
     
     ;; Menu items
     (- (void) appendTextUnitViewController: (id) sender is
        (NSLog "caught append tuvc"))
     
     (- (id) init is
        (super initWithWindowNibName:"DocumentWindow"))
     
     (- (void) windowControllerDidLoadNib:(id) aController is
        ))

(NSLog "At end of critex.nu")