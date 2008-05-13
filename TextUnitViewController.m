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
	
	mainTextView = [self createTextViewWithFrame:NSMakeRect(5.0, 5.0, width*1/3, 24)];
	translationView = [self createTextViewWithFrame:NSMakeRect(width*1/3 + 5, 5.0, width*2/3 - 10, 24)];
	footnoteTextView = [self createTextViewWithFrame:NSMakeRect(5.0, 34, width - 15, 24)];
	
	[mainTextView bind:@"attributedString"
			  toObject:tu 
		   withKeyPath:@"mainText"
			   options:nil];
	[translationView bind:@"attributedString"
			  toObject:tu 
		   withKeyPath:@"translationText"
			   options:nil];
	[footnoteTextView bind:@"attributedString"
			  toObject:tu 
		   withKeyPath:@"footnoteText"
			   options:nil];
	
	[boxView addSubview:mainTextView];
	[boxView addSubview:translationView];
	[boxView addSubview:footnoteTextView];
	
	NSRect boxFrame = [boxView frame];
	
	boxFrame.origin.y = 0;
	boxFrame.size.height = 68;
	[boxView setFrame:NSMakeRect(0, 5, [boxView frame].size.width, 80)];
	[[self view] setFrame:NSMakeRect(0, 50, [[self view] frame].size.width, 80)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleResizeNotification:)
												 name:NSViewFrameDidChangeNotification
											   object:mainTextView];
	
	[mainTextView release];
	[translationView release];
	[footnoteTextView release];
	
	return self;
}

-(void)reframeAllTextAreas
{
	NSRect boxFrame = [boxView frame];
	int width = boxFrame.size.width;
	float y = 5;
	
	NSRect mainFrame = [mainTextView frame];
	[mainTextView setFrame:NSMakeRect(5.0, 5.0, width*1/3, mainFrame.size.height)];
	y = mainFrame.size.height;
	
	NSLog(@"Height of main frame is %f", y);
	
	NSRect transFrame = [translationView frame];
	[translationView setFrame:NSMakeRect(width*1/3 + 5, 5.0, width*2/3 - 10, transFrame.size.height)];
	if (y < transFrame.size.height) {
		y = transFrame.size.height;
	}
	
	NSLog(@"Height of translation frame is %f", y);
	NSLog(@"Height of tallest frame is %f", y);
	
	NSRect noteFrame = [footnoteTextView frame];
	[footnoteTextView setFrame:NSMakeRect(5.0, y + 5, width - 15, noteFrame.size.height)];	
	NSLog(@"Putting footnotes at y: %f, height: %f", y, noteFrame.size.height);
	
	boxFrame = [boxView frame];
	boxFrame.size.height = y + noteFrame.size.height + 10;
	boxFrame.origin.y = 0;
	boxFrame.origin.x = 0;
	NSLog(@"Changing box %@ to frame y: %f, x: %f, height: %f, width: %f", boxView, boxFrame.origin.y, boxFrame.origin.x, boxFrame.size.height, boxFrame.size.width);
	[boxView setFrame:boxFrame];
	[boxView setNeedsDisplay:true];
	
	[[boxView contentView] setFrame:boxFrame];
	[[boxView contentView] setNeedsDisplay:true];
	
	NSRect viewFrame = [[self view] frame];
	viewFrame.origin.y = 5;
	viewFrame.size.height = y + noteFrame.size.height + 20;
	[[self view] setFrame:viewFrame];
	NSLog(@"Changing view frame for: %@ to frame y: %f, x: %f, height: %f, width: %f", boxView, viewFrame.origin.y, viewFrame.origin.x, viewFrame.size.height, viewFrame.size.width);
	
	[[self view] setNeedsDisplay:true];
	
}

-(void)handleResizeNotification:(NSNotification *)n
{
	NSLog(@"Send a %@ notification for %@", [n name], [n object]);
	[self reframeAllTextAreas];
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
