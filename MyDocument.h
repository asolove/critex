//
//  MyDocument.h
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
@class TextUnit;
@class TextUnitViewController;

@interface MyDocument : NSDocument
{
	IBOutlet NSScrollView *scrollView;
	NSMutableArray *viewControllers;
}

-(void)addTextUnitToEnd:(NSView *)textUnitView;
-(IBAction)textViewSize:(id)sender;
@end
