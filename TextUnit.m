//
//  TextUnit.m
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnit.h"

@implementation TextUnit
@synthesize mainText, translationText, footnoteText;

- (id)init
{
	return [self initWithStringForMain:@" "
							translated:@" "
							 footnotes:@" "
								 level:0];
}

-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString
					 level: (int)initLevel
{
	self = [super init];
    if (self) {		
		NSArray *objects = [NSArray arrayWithObject:[NSFont fontWithName:@"Baskerville" size:16] ];
		NSArray *keys = [NSArray arrayWithObject: NSFontAttributeName];
		NSDictionary *textAttributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		objects = [NSArray arrayWithObject:[NSFont fontWithName:@"Baskerville" size:14]];
		keys = [NSArray arrayWithObject: NSFontAttributeName];
		NSDictionary *noteAttributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		[self setMainText:[[NSMutableAttributedString alloc] initWithString:mainString
														  attributes:textAttributes]];
		[self setTranslationText:[[NSMutableAttributedString alloc] initWithString:translationString
																attributes:textAttributes]];
		[self setFootnoteText:[[NSMutableAttributedString alloc] initWithString:footnotesString
															  attributes:noteAttributes]];
		[self setLevel: initLevel];
	}
	return self;
	
}


-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString
{
	return [self initWithStringForMain: mainString
							translated: translationString
							 footnotes: footnotesString
								 level: 0];
}


-(void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:mainText forKey:@"mainText"];
	[coder encodeObject:translationText forKey:@"translationText"];
	[coder encodeObject:footnoteText forKey:@"footnoteText"];
}

-(id)initWithCoder:(NSCoder *)coder
{
	[super init];
	[self setMainText:[coder decodeObjectForKey:@"mainText"]];
	[self setTranslationText:[coder decodeObjectForKey:@"translationText"]];
	[self setFootnoteText:[coder decodeObjectForKey:@"footnoteText"]];
	return self;
}

-(int)level
{
	return level;
}

-(void)setLevel:(int)l
{
	level = l;
	if (l > 0) {
		NSLog(@"Adding attribute");
		[mainText beginEditing];
		[mainText addAttribute:NSFontAttributeName
						 value:[NSFont fontWithName:@"Baskerville" size:20] 
						 range:NSMakeRange(0, [mainText length])];
		[mainText endEditing];
	}
}

-(void)dealloc
{
	[mainText release];
	[translationText release];
	[footnoteText release];
	[super dealloc];
}

@end
