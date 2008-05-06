//
//  TextUnitViewController.h
//  TextUnit
//
//  Created by Adam Solove on 5/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextUnitViewController : NSViewController {
	TextUnit *textUnit;
}
@property (retain) TextUnit *textUnit;

-(id)initWithTextUnit:(TextUnit *)tu;
@end
