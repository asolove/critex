//
//  TextUnitView.m
//  TextUnit
//
//  Created by Adam Solove on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnitView.h"


@implementation TextUnitView

-(id)initWithFrame:(NSRect) frame
{
	[super initWithFrame:frame];
	
	[[NSColor grayColor] set];
	[NSBezierPath fillRect:frame];
	
	NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:@"Hello there"];
	NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
	[textStorage addLayoutManager:layoutManager];
	
	NSRect cFrame = frame;
	cFrame.origin.y = 5;
	cFrame.origin.x = 5;
	cFrame.size.width = cFrame.size.width - 10;
	cFrame.size.height /= 2;
	cFrame.size.height -= 10;
	NSTextContainer *container;
	
	container = [[NSTextContainer alloc]
				 initWithContainerSize:cFrame.size];
	[layoutManager addTextContainer:container];
	[container release];
	
	NSTextView *textView = [[NSTextView alloc]
							initWithFrame:cFrame 
							textContainer:container];
	[self addSubview:textView];
	
	[textStorage release];
	[layoutManager release];
	
	return self;
}

-(void)dealloc
{
	[[self subviews] release];
	[super dealloc];
}

-(id)initAndBindToMainText:(NSAttributedString *)mainText
			translatedText:(NSAttributedString *)translatedText
			 footnotesText:(NSAttributedString *)footnotesText
{
	return nil;
}

@end
