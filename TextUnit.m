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
	return [self initWithStringForMain:@"王來紹上帝，自服於土中。旦曰：『其作大邑，其自時配皇天；毖祀於上下，其自時中乂，王厥有成命，治民今休。』王先服殷御事，比介於我有周御事。節性，惟日其邁；王敬作所，不可不敬德。」"
							translated:@"The King comes to make divination to the lord on high. regarding his exercising submission on the middle of the Earth. Dan says: 'They have made the great city. They from this time they will be added to sovereign heaven, carefully sacrificing above and below. They from this time will hit the mark of peace. The king has now fulfilled the mandate. He governs the people so that they become virtuous."
							 footnotes:@"These are the footnotes"];
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
		
		mainText = [[NSMutableAttributedString alloc] initWithString:mainString
														  attributes:textAttributes];
		translationText = [[NSMutableAttributedString alloc] initWithString:translationString
																attributes:textAttributes];
		footnoteText = [[NSMutableAttributedString alloc] initWithString:footnotesString];
	}
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
