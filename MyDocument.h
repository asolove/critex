//
//  MyDocument.h
//  Critex
//
//  Created by Adam Solove on 5/13/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
@class FlippedView;
@class TextUnit;

@interface MyDocument : NSDocument
{
	IBOutlet NSView *contentView;
	IBOutlet NSScrollView *scrollView;
	NSMutableArray *viewControllers;
	BOOL isResizing;
}

// Add a text block to the end
-(IBAction)appendTextUnitViewController:(id)sender;
-(void)appendControllerForTextUnit:(TextUnit *)tu;

// Notified of text view's frame size changing
-(void)handleResizeNotification:(NSNotification *)n;

// Adjust tops of all views
-(IBAction)reframeAllTextAreasAction:(id)sender;
-(void)reframeAllTextAreas;

// Change frame of the content view when items are added or removed.
-(void)setContentViewHeightTo:(int)height;
-(void)setContentViewHeightToFit;
-(int)bottom;

@end
