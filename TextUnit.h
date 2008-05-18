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
	NSMutableAttributedString *translationText;
	NSMutableAttributedString *footnoteText;
	int			  level;
}
@property(retain) NSMutableAttributedString *mainText;
@property(retain) NSMutableAttributedString *translationText;
@property(retain) NSMutableAttributedString *footnoteText;
@property int level;

-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString;


-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString
					 level: (int) initLevel;

// Encoding and deencoding
-(void)encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;

@end
