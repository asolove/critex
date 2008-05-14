//
//  MyDocument.m
//  Critex
//
//  Created by Adam Solove on 5/13/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "MyDocument.h"
#import "FlippedView.h"
#import "TextUnit.h"
#import "TextUnitViewController.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		viewControllers = [[NSMutableArray alloc] init];
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
	
	if ([viewControllers count] > 0) {
		NSLog(@"Opening a saved document");
		
	} else {
		[self appendTextUnitViewController:self];
	}
}

-(IBAction)appendTextUnitViewController:(id)sender
{
	TextUnit *textUnit = [[TextUnit alloc] init];
	[self appendControllerForTextUnit:textUnit];
}

-(void)appendControllerForTextUnit:(TextUnit *)tu
{
	int bottom = [self bottom];
	
	TextUnitViewController* vc = [[TextUnitViewController alloc] initWithTextUnit:tu
																			 view:contentView
																		  originX:bottom];
	
	[viewControllers addObject:vc];
	
	[vc release];
	[tu release];
	[self setContentViewHeightToFit];
}

-(IBAction)reframeAllTextAreasAction:(id)sender
{
	[self reframeAllTextAreas];
}

-(void)reframeAllTextAreas
{
	NSEnumerator *e = [viewControllers objectEnumerator];
	TextUnitViewController *tuvc;
	int bottom = 0;
	
	while(tuvc = [e nextObject]) {
		[tuvc reframeTextAreasAtY:bottom];
		bottom = [tuvc bottom];
	}
	
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
	NSLog(@"Setting content height to %d", height);
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

	return [NSKeyedArchiver archivedDataWithRootObject: viewControllers];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
