//
//  TextUnitViewController.m
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnitViewController.h"
#import "TextUnit.h"
#import "TextUnitView.h"
#import "FlippedView.h"

@implementation TextUnitViewController
@synthesize textUnit;

-(id)initWithTextUnit:(TextUnit *)tu
{
	if (![super initWithNibName:@"TextUnit"
						 bundle:nil]) {
		return nil;
	}
	[self setTitle:@"TextUnit"];
	[self setTextUnit:tu];
	
	// Get the box view from the view hierarchy
	boxView = [[[self view] subviews] objectAtIndex:0];
	[boxView setContentView:[[FlippedView alloc] initWithFrame:[boxView frame]]];
	[boxView addSubview:mainTextView];
	
	int width = [boxView frame].size.width;
	
	mainTextView = [self createTextViewWithFrame:NSMakeRect(5.0, 5.0, width*2/3 - 15, 24)];
	translationView = [self createTextViewWithFrame:NSMakeRect(width*2/3 - 5, 5.0, width*1/3 - 5, 24)];
	footnoteTextView = [self createTextViewWithFrame:NSMakeRect(5.0, 34, width - 15, 24)];
	
	[boxView addSubview:mainTextView];
	[boxView addSubview:translationView];
	[boxView addSubview:footnoteTextView];
	
	NSRect boxFrame = [boxView frame];
	boxFrame.origin.y = 0;
	boxFrame.size.height = 68;
	[boxView setFrame:boxFrame];
	
	[mainTextView release];
	[translationView release];
	[footnoteTextView release];
	
	return self;
}

-(void)dealloc
{
	[boxView release];
	[mainTextView release];
	[textUnit release];
	[super dealloc];
}

-(NSTextView *)createTextViewWithFrame:(NSRect)frame
{
	NSTextView *textView = [[NSTextView alloc] initWithFrame:frame];
	return textView;
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
