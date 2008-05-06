//
//  TextUnitViewController.m
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextUnitViewController.h"


@implementation TextUnitViewController
@synthesize textUnit;

-(id)initWithTextUnit:(TextUnit *)tu
{
	if (![super initWithNibName:@"TextUnitView"
						 bundle:nil]) {
		return nil;
	}
	[self setTitle:@"TextUnit"];
	[self setTextUnit:tu];
	return self;
}
@end

@end
