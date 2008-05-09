//
//  TextUnitView.h
//  TextUnit
//
//  Created by Adam Solove on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextUnitView : NSView {
	NSTextView *mainTextView;
	NSTextView *translatedTextView;
	NSTextView *footnotesTextView;
}

-(id)initAndBindToMainText:(NSAttributedString *)mainText
			translatedText:(NSAttributedString *)translatedText
			 footnotesText:(NSAttributedString *)footnotesText;

@end
