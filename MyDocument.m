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
		isResizing = false;
    }
    return self;
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
	
	[scrollView setDocumentView:contentView];
	
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

@end
