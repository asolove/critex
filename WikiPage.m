//
//  WikiPage.m
//  Critex
//
//  Created by Adam Solove on 5/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WikiPage.h"


@implementation WikiPage
@synthesize title, tags, text;

-(id)init
{
	if (![super init])
		return nil;
	
	[self setTitle:[[NSString alloc] init]];
	[self setTags:[[NSString alloc] init]];
	
	NSArray *objects = [NSArray arrayWithObject:[NSColor colorWithCalibratedRed:1.0
																		  green:1.0
																		   blue:1.0
																		  alpha:0.7]];
	NSArray *keys = [NSArray arrayWithObject: NSForegroundColorAttributeName];
	NSDictionary *textAttributes = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
	[textAttributes setValue:[NSFont fontWithName:@"Lucida Grande"
											 size:12]
					  forKey:NSFontFamilyAttribute];
						
	[self setText:[[NSAttributedString alloc] initWithString:@" "
												  attributes:textAttributes]];
	
	
	
	return self;
}


-(void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:text forKey:@"text"];
	[coder encodeObject:title forKey:@"title"];
	[coder encodeObject:tags forKey:@"tags"];
}

-(id)initWithCoder:(NSCoder *)coder
{
	[super init];
	[self setTitle:[coder decodeObjectForKey:@"title"]];
	[self setText:[coder decodeObjectForKey:@"text"]];
	[self setTags:[coder decodeObjectForKey:@"tags"]];
	return self;
}

-(void)dealloc
{
	[title release];
	[text release];
	[tags release];
	[super dealloc];
}

@end
