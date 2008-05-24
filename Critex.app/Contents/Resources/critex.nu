;; @file packer.nu
;; @discussion PagePacker in Nu.
;;
;; @copyright Copyright (c) 2007 Tim Burks, Neon Design Technology, Inc.
;; Substantially derived from original Objective-C source code by Aaron Hillegass.
;; See objc/PagePacker.m for the copyright notice for the original code.

(global BLOCK_COUNT 8) ;; We display 8 pages in a PagePacker document.  There is no easy way to change this.


;; @discussion This is the main PagePacker document.
(class MyDocument is NSDocument
     (ivar (id) contentView)
     
     (- (id)init is
        (super init)
        self)
     
     (- (id)windowNibName is "MyDocument")
     
     (- (void)windowControllerDidLoadNib:(id) aController is
        (super windowControllerDidLoadNib:aController)
        (@contentView addSubview:((NSTextView alloc) initWithFrame:'(0 0 200 200))))
     
     (- (id)dataRepresentationOfType:(id)aType is)
     
     (- (BOOL)loadDataRepresentation:(id)data ofType:(id)aType is
        YES)
     
     (- (id) printOperationWithSettings:(id)printSettings error:(id *)errorReference is
        (NSPrintOperation printOperationWithView:@packerView printInfo:(self printInfo))))

