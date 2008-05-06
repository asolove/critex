//
//  MyDocument.m
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "MyDocument.h"
#import "TextUnit.h"
#import "TextUnitViewController.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		TextUnit *textUnit = [[TextUnit alloc] init];
		viewControllers = [[NSMutableArray alloc] init];
		
		TextUnitViewController* vc = [[TextUnitViewController alloc] initWithTextUnit:textUnit];
		[viewControllers addObject:vc];
		
		[textUnit release];
		[vc release];
    }
    return self;
}

-(void)dealloc
{
	[viewControllers release];
	[super dealloc];
}

-(void)addTextUnitToEnd:(NSView *)textUnitView
{
	[[scrollView contentView] addSubview:textUnitView positioned:NSWindowAbove relativeTo:nil];
	NSRect frame = [textUnitView frame];
	frame.origin.y = 20;
	[textUnitView setFrame:frame];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	[self addTextUnitToEnd: [[viewControllers objectAtIndex:0] view]];
}

-(IBAction)textViewSize:(id)sender
{
	NSTextView *textView = [[viewControllers objectAtIndex:0] valueForKey:@"mainTextView"];
	NSRect rect = [textView bounds];
	NSSize size = rect.size;
	NSNumber *height = [NSNumber numberWithFloat:size.height];
	NSNumber *width = [NSNumber numberWithFloat:size.width];
	NSLog(@"Text view for main notes is %@ by %@", height, width);
}

// Genrated Code

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

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
