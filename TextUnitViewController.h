//
//  TextUnitViewController.h
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TextUnit;
@class TextUnitView;
@class FlippedView;

@interface TextUnitViewController : NSObject {
	NSTextView *mainTextView;
	NSTextView *translationView;
	NSTextView *footnoteTextView;
	TextUnit   *textUnit;
	NSView	   *view;	
	int			bottom;
	NSBox	   *separator;
	BOOL		isResizing;
}

-(id)initWithTextUnit:(TextUnit *)tu
				 view:(NSView *)view
			  originX:(int)x;
-(NSTextView *)createTextViewWithFrame:(NSRect)frame;

-(void)handleResizeNotification:(NSNotification *)n;
-(void)reframeTextAreas;
-(void)reframeTextAreasAtY:(int)y;
-(int)bottom;

-(IBAction)setTextUnitToHeader:(id)sender;

-(BOOL)textView:(NSTextView *)aTextView 
doCommandBySelector: (SEL)aSelector;

-(void)encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;
-(BOOL)commitEditing;
@end
