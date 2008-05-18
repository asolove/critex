//
//  WikiPage.h
//  Critex
//
//  Created by Adam Solove on 5/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WikiPage : NSObject {
	NSString *title;
	NSString *tags;
	NSAttributedString *text;
}
@property(retain) NSString *title;
@property(retain) NSString *tags;
@property(retain) NSAttributedString *text;
@end
