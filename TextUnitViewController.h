//
//  TextUnitViewController.h
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TextUnit;


@interface TextUnitViewController : NSViewController {
	TextUnit *textUnit;
	IBOutlet NSTextView *mainTextView;
	IBOutlet NSTextView *translationView;
	IBOutlet NSTextView *footnoteTextView;
}
@property (retain) TextUnit *textUnit;

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString;
-(IBAction)createFootnoteForSelection:(id)sender;
-(void)createFootnoteForRange:(NSRange)range;

-(id)initWithTextUnit:(TextUnit *)tu;
@end
