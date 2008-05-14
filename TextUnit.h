//
//  TextUnit.h
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextUnit : NSObject <NSCoding> {
	NSTextStorage *mainText;
	NSTextStorage *translationText;
	NSTextStorage *footnoteText;
}

-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString;

// Encoding and deencoding
-(void)encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;

@end
