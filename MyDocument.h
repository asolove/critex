//
//  MyDocument.h
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "TextUnit.h"

@interface MyDocument : NSDocument
{
	TextUnit *textUnit;
	IBOutlet NSTextView *mainTextView;
	IBOutlet NSTextView *footnoteTextView;
}
-(IBAction)createFootnoteForSelection:(id)sender;

-(void)createFootnoteForRange:(NSRange)range;

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString;

@end
