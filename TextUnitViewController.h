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

@interface TextUnitViewController : NSViewController {
	TextUnit *textUnit;
	NSBox *boxView;
	NSTextView *mainTextView;
	NSTextView *translationView;
	NSTextView *footnoteTextView;
}
@property (retain) TextUnit *textUnit;

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString;
-(IBAction)createFootnoteForSelection:(id)sender;
-(void)createFootnoteForRange:(NSRange)range;
-(NSTextView *)createTextViewWithFrame:(NSRect)frame;

-(id)initWithTextUnit:(TextUnit *)tu;
@end
