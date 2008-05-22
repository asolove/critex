//
//  MyDocument.m
//  Critex
//
//  Created by Adam Solove on 5/13/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

// TODO:
//
// As you add the text fields remember the last one you added. 
// When you add another use the setNextKeyView: message on the previous 
// item to add the new one to the end of the key view loop. If you are making 
// the window or all of it's useful content programatically then you can use 
// setInitialFirstRepsonder: on that window to point to the first of your text fields.

#import "MyDocument.h"
#import "FlippedView.h"
#import "TextUnit.h"
#import "TextUnitViewController.h"

@implementation MyDocument

@synthesize textUnits, viewControllers;

- (id)init
{
    self = [super init];
    if (self) {
		viewControllers = [[NSMutableArray alloc] init];
		textUnits = [[NSMutableArray alloc] init];
		wikiPages = [[NSMutableArray alloc] init];
		isResizing = false;
    }
    return self;
}

-(void)dealloc 
{
	[viewControllers release];
	[textUnits release];
	[wikiPages release];
	
	[contentView release];
	[scrollView release];
	[drawer release];
	[wikiPagesController release];
	[wikiTextView release];
	[wikiNameField release];
	
	[super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	if ([textUnits count] > 0) {
		NSLog(@"Opening a saved document");
		
		// Add controllers for all text units opened at save:		
		NSEnumerator *e = [textUnits objectEnumerator];
		TextUnit *tu;
		while (tu = [e nextObject]) {
			[self appendControllerForTextUnit:tu];
		}
	} else {
		[self appendTextUnitViewController:self];
	}
	NSTextView *first = [[viewControllers objectAtIndex:0] valueForKey:@"mainTextView"];
	[[first window] makeFirstResponder:first];
}

-(IBAction)appendTextUnitViewController:(id)sender
{
	TextUnit *textUnit = [[TextUnit alloc] init];
	[textUnits addObject:textUnit];
	[self appendControllerForTextUnit:textUnit];
}

-(void)appendControllerForTextUnit:(TextUnit *)tu
{
	int bottom = [self bottom];
	
	TextUnitViewController* vc = [[TextUnitViewController alloc] initWithTextUnit:tu
																			 view:contentView
																		  originX:bottom];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleResizeNotification:)
												 name:NSViewFrameDidChangeNotification
											   object:[vc valueForKey:@"footnoteTextView"]];
	
	[viewControllers addObject:vc];
	
	[vc release];
	[tu release];
	[self setContentViewHeightToFit];
}
	 
	 
-(void)handleResizeNotification:(NSNotification *)n
{
	if (!isResizing)
	{	
		[self reframeAllTextAreas];
	}
}
	 
-(IBAction)reframeAllTextAreasAction:(id)sender
{
	[self reframeAllTextAreas];
}

-(void)reframeAllTextAreas
{
	isResizing = true;
	NSEnumerator *e = [viewControllers objectEnumerator];
	TextUnitViewController *tuvc;
	int bottom = 0;
	
	while(tuvc = [e nextObject]) {
		[tuvc reframeTextAreasAtY:bottom];
		bottom = [tuvc bottom];
	}
	[self setContentViewHeightToFit];
	isResizing = false;
}

-(void)setContentViewHeightToFit
{
	int bottom = [self bottom];
	[self setContentViewHeightTo: bottom + 5];
}

-(void)setContentViewHeightTo:(int)height
{
	NSRect frame = [contentView frame];
	frame.size.height = height;
	[contentView setFrame:frame];
}

-(int)bottom
{
	TextUnitViewController *tu;
	if(tu = [viewControllers lastObject]) {
		return [tu bottom];
	} else {
		return 0;
	}
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	
	return [NSKeyedArchiver archivedDataWithRootObject: textUnits];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{	
    NSMutableArray *newTextUnits;
	newTextUnits = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	viewControllers = [[NSMutableArray alloc] init];
	textUnits = [[NSMutableArray alloc] init];
	isResizing = false;
	
	if (newTextUnits == nil) {
		NSLog(@"unarchive failed");
	} else {	
		[self setTextUnits:newTextUnits];
	}
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

// Commit editing on key view

-(BOOL)commitEditing
{
	return [[[scrollView window] firstResponder] commitEditing];
}

// exploratory
-(IBAction)setKeyTextUnitToHeader:(id)sender
{
	// how do we get to the controller when we only have the text view?
	NSLog(@"Caught a header menu cmd");
	[[[[scrollView window] firstResponder] delegate] setTextUnitToHeader:self];
}

// Drawer methods
-(IBAction)toggleDrawer:(id)sender
{
	[drawer toggle:self];
}

-(NSString *)fontForDrawer
{
	return @"Baskerville";
}

// Data Source for Drawer table view
-(int)numberOfRowsInTableView:(NSTableView *)tableView
{
	NSEnumerator *e = [viewControllers objectEnumerator];
	TextUnitViewController *tuvc;
	int i = 0;
	
	while(tuvc = [e nextObject]) {
		if ([tuvc isHeader])
			i++;
	}
	
	return i;
}
-(id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)column
		   row:(int)rowIndex
{
	// return [[[[viewControllers objectAtIndex:0] valueForKey:@"mainTextView"] textStorage] string]; 
	switch (rowIndex) {
		case 0: 
			return @"Imitating the Crown Prince of Wei's";
		case 1:
			return @" Zhi, Marquis of Pingyuan";
			break;
		case 2:
			return @" Pi, The Crown Prince";
			break;
			
	}
}
	 
-(IBAction)nextKeyView:(id)sender
{
	[[scrollView window] selectNextKeyView:self];
}

// Printing
-(void)printShowingPrintPanel:(BOOL)flag
{
	NSPrintInfo *printInfo = [self printInfo];
	float width = [printInfo paperSize].width - 2 * [printInfo leftMargin];
	NSRect beforeFrame = [contentView frame];
	NSNumber *oldWidth = [[NSNumber alloc] initWithInt:beforeFrame.size.width];
	NSRect tmpFrame = beforeFrame;
	tmpFrame.size.width = width;
	[contentView setFrame:tmpFrame];
	[self reframeAllTextAreas];
	
	NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:contentView
															   printInfo:printInfo];
	
	[printOp setShowPanels:flag];
	[self runModalPrintOperation:printOp
						delegate:self
				  didRunSelector:@selector(documentDidRunModalPrintOperation:success:contextInfo:)
					 contextInfo:oldWidth];
	
}
- (void)documentDidRunModalPrintOperation:(NSDocument *)document  
								  success:(BOOL)success  
							  contextInfo:(NSNumber *)width
{
	NSRect frame = [contentView frame];
	frame.size.width = [width intValue]; 
	[contentView setFrame:frame];
	[self reframeAllTextAreas];
}
@end
