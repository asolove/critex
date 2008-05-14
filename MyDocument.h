//
//  MyDocument.h
//  Critex
//
//  Created by Adam Solove on 5/13/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
@class FlippedView;

@interface MyDocument : NSDocument
{
	IBOutlet NSView *contentView;
	NSMutableArray *viewControllers;
}
@end
