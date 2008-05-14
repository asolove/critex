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
	[textUnit retain];
	
	view = contentView;
	int width = [view frame].size.width - 70;
	x = x + 25;
	
	mainTextView = [self createTextViewWithFrame:NSMakeRect(25.0, x, width*1/3, 24)];
	translationView = [self createTextViewWithFrame:NSMakeRect(width*1/3 + 45, x, width*2/3, 24)];
	footnoteTextView = [self createTextViewWithFrame:NSMakeRect(25.0, x + 30, width, 24)];
	separator = [[NSBox alloc] initWithFrame:NSMakeRect(25.0, x + 25, width, 10)];	
	[separator setBoxType:NSBoxSeparator];
	
	bottom = x + 35;
	
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
	
	isResizing = true;
	
	[view addSubview:mainTextView];
	[view addSubview:translationView];
	[view addSubview:footnoteTextView];
	[view addSubview:separator];
	
	[self reframeTextAreas];
	
	
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
	
	isResizing = false;
	NSLog(@"Done with creating this controller");
	
	[mainTextView release];
	[translationView release];
	[footnoteTextView release];
	
	
	return self;
}

-(void)handleResizeNotification:(NSNotification *)n
{
	if (!isResizing) {
		[self reframeTextAreas];
	}
}

-(void)reframeTextAreasAtY:(int)y
{
	y = y + 25; // top margin
	
	isResizing = true;
	int width = [view frame].size.width - 60;
	
	NSRect frame = [mainTextView frame];
	frame.origin.y = y;
	int height = frame.size.height;
	int top = frame.origin.y;
	bottom = height + top;
	
	[mainTextView setFrame:NSMakeRect(25.0, top, width*1/3, height)];
	
	frame = [translationView frame];
	frame.origin.y = y;
	height = frame.size.height;
	if (height + top  > bottom) {
		bottom = height + top;
	}
	[translationView setFrame:NSMakeRect(width*1/3 + 35, top, width*2/3, height)];
	
	[separator setFrame:NSMakeRect(25.0, bottom + 10 , width + 10, 1)];
	
	frame = [footnoteTextView frame];
	height = frame.size.height;
	[footnoteTextView setFrame:NSMakeRect(25.0, bottom + 15, width + 10, height)];
	
	[view setNeedsDisplay:true];
	
	bottom = bottom + 10 + height;
	
	isResizing = false;
	
}

-(void)reframeTextAreas
{
	[self reframeTextAreasAtY:[mainTextView frame].origin.y - 25];
}

-(NSTextView *)createTextViewWithFrame:(NSRect)frame
{
	NSTextView *textView = [[NSTextView alloc] initWithFrame:frame];
	return textView;
}

-(int)bottom
{
	return bottom;
}


-(void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:textUnit forKey:@"textUnit"];
}

-(id)initWithCoder:(NSCoder *)coder
{
	[super init];
	textUnit = [coder decodeObjectForKey:@"textUnit"];
	return self;
}

@end
