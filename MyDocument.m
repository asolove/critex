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
	
	
	
	TextUnit *textUnit = [[TextUnit alloc] init];
	viewControllers = [[NSMutableArray alloc] init];
	
	TextUnitViewController* vc = [[TextUnitViewController alloc] initWithTextUnit:textUnit
																			 view:contentView
																		  originX:20];
	[viewControllers addObject:vc];
	
	//		textUnit = [[TextUnit alloc] initWithStringForMain:@"Main text"
	//												translated:@"Trans. text"
	//												 footnotes:@"Footnotes text"];
	//		vc = [[TextUnitViewController alloc] initWithTextUnit:textUnit];
	//		[viewControllers addObject:vc];
	//		
	//		vc = [[TextUnitViewController alloc] initWithTextUnit:textUnit];
	//		[viewControllers addObject:vc];
	
	[textUnit release];
	[vc release];
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
