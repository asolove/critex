//
//  MyDocument.m
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "MyDocument.h"
#import "TextUnit.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		textUnit = [[TextUnit alloc] init];
    }
    return self;
}

-(void)dealloc
{
	[textUnit release];
	[super dealloc];
}


-(IBAction)createFootnoteForSelection:(id)sender
{
	NSArray *selections = [mainTextView selectedRanges];
	NSRange range;
	NSInteger i = 0;
	
	for(i=0; i < [selections count]; i++) {
		range = [[selections objectAtIndex:i] rangeValue];
		[self createFootnoteForRange:range];
	}
	
}

-(void)createFootnoteForRange:(NSRange)range
{
	NSTextStorage *mainStorage = [mainTextView textStorage];
	[mainStorage beginEditing];
	
	// Add attribute to mark this as a footnote, then create lemma in footnoteStorage
	[mainStorage addAttribute:@"DSNoteAttributeName" value:@"1" range:range];
	[mainStorage addAttribute:NSBackgroundColorAttributeName
						value:[NSColor colorWithCalibratedRed:0.95
														green:0.95
														 blue:0.95
														alpha:0.95]
						range:range];
	
	
	[mainStorage endEditing];
	
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
	NSTextStorage *storage = [aTextView textStorage];

	// Don't let user delete part of a lemma unless only editing the lemma
	NSDictionary* startAttributes = [storage attributesAtIndex:affectedCharRange.location 
												effectiveRange:NULL];
	NSDictionary* finalAttributes = [storage attributesAtIndex:affectedCharRange.location + affectedCharRange.length - 1
												effectiveRange:NULL];
	
	if ([startAttributes objectForKey:@"DSNoteAttributeName"] == [finalAttributes objectForKey:@"DSNoteAttributeName"]) {
		return YES;
	} else {
		return NO;
	}
}

// Generated code

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}




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
