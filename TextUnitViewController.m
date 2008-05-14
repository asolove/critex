//
//  TextUnitViewController.m
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

// TODO: set setLineHeight, setHeaderLevel
// TODO: remove box, extra views, just init view inside passed scrolled view and 

#import "TextUnitViewController.h"
#import "TextUnit.h"
#import "FlippedView.h"

@implementation TextUnitViewController

-(id)initWithTextUnit:(TextUnit *)tu
				 view:(NSView *)contentView
			  originX:(int)x
{
	if (![super init]) {
		return nil;
	}
	textUnit = tu;
	view = contentView;
	int width = [view frame].size.width - 70;
	
	
	mainTextView = [self createTextViewWithFrame:NSMakeRect(25.0, 15.0, width*1/3, 24)];
	translationView = [self createTextViewWithFrame:NSMakeRect(width*1/3 + 45, 15.0, width*2/3, 24)];
	footnoteTextView = [self createTextViewWithFrame:NSMakeRect(25.0, 44, width, 24)];
	separator = [[NSBox alloc] initWithFrame:NSMakeRect(25.0, 40, width, 10)];	
	[separator setBoxType:NSBoxSeparator];
	
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
	
	[view addSubview:mainTextView];
	[view addSubview:translationView];
	[view addSubview:footnoteTextView];
	[view addSubview:separator];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleResizeNotification:)
												 name:NSViewFrameDidChangeNotification
											   object:mainTextView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleResizeNotification:)
												 name:NSViewFrameDidChangeNotification
											   object:translationView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleResizeNotification:)
												 name:NSViewFrameDidChangeNotification
											   object:footnoteTextView];
	
	
	
	[mainTextView release];
	[translationView release];
	[footnoteTextView release];
	
	
	return self;
}

-(void)handleResizeNotification:(NSNotification *)n
{
	NSLog(@"Send a %@ notification for %@", [n name], [n object]);
	[self reframeTextAreas];
}

-(void)reframeTextAreas
{
	int width = [view frame].size.width - 60;
	
	NSRect frame = [mainTextView frame];
	int height = frame.size.height;
	int highest = height;
	[mainTextView setFrame:NSMakeRect(25.0, 25.0, width*1/3, height)];
	
	frame = [translationView frame];
	height = frame.size.height;
	if (height > highest) {
		highest = height;
	}
	[translationView setFrame:NSMakeRect(width*1/3 + 35, 25.0, width*2/3, height)];
	
	[separator setFrame:NSMakeRect(25.0, highest + 40, width + 10, 1)];
	
	frame = [footnoteTextView frame];
	height = frame.size.height;
	[footnoteTextView setFrame:NSMakeRect(25.0, highest + 45, width + 10, height)];
	
	[view setNeedsDisplay:true];
}

-(NSTextView *)createTextViewWithFrame:(NSRect)frame
{
	NSTextView *textView = [[NSTextView alloc] initWithFrame:frame];
	return textView;
}

@end
