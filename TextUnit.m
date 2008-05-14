//
//  TextUnit.m
//  TextUnit
//
//  Created by Adam Solove on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnit.h"

@implementation TextUnit

- (id)init
{
	return [self initWithStringForMain:@" "
							translated:@" "
							 footnotes:@" "];
}

-(id)initWithStringForMain: (NSString *)mainString
				translated: (NSString *)translationString
				 footnotes: (NSString *)footnotesString
{
	self = [super init];
    if (self) {		
		NSArray *objects = [NSArray arrayWithObject:[NSFont fontWithName:@"Baskerville" size:16] ];
		NSArray *keys = [NSArray arrayWithObject: NSFontAttributeName];
		NSDictionary *textAttributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		objects = [NSArray arrayWithObject:[NSFont fontWithName:@"Baskerville" size:14]];
		keys = [NSArray arrayWithObject: NSFontAttributeName];
		NSDictionary *noteAttributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		mainText = [[NSMutableAttributedString alloc] initWithString:mainString
														  attributes:textAttributes];
		translationText = [[NSMutableAttributedString alloc] initWithString:translationString
																attributes:textAttributes];
		footnoteText = [[NSMutableAttributedString alloc] initWithString:footnotesString
															  attributes:noteAttributes];
	}
	return self;
	
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
	mainText		= [coder decodeObjectForKey:@"mainText"];
	translationText = [coder decodeObjectForKey:@"translationText"];
	footnoteText	= [coder decodeObjectForKey:@"footnoteText"];
	return self;
}

-(void)dealloc
{
	[mainText release];
	[translationText release];
	[footnoteText release];
	[super dealloc];
}

@end
