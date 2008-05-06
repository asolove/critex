//
//  TextUnitViewController.m
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnitViewController.h"
#import "TextUnit.h"


@implementation TextUnitViewController
@synthesize textUnit;

-(id)initWithTextUnit:(TextUnit *)tu
{
	NSLog(@"Creating Text Unit View Controller.");
	if (![super initWithNibName:@"TextUnit"
						 bundle:nil]) {
		return nil;
	}
	[self setTitle:@"TextUnit"];
	[self setTextUnit:tu];
	NSLog(@"TUVC created successfully.");
	return self;
}

-(void)dealloc
{
	[textUnit release];
	[super dealloc];
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



@end
