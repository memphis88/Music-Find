//
//  XMLParser.h
//  Music Find
//
//  Created by Memphis on 12/12/12.
//  Copyright (c) 2012 Memphis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>
{
	NSString		*current;
	NSMutableString	*outstring;
	NSURL			*url;
	id              delegate;
	NSThread		*thread;
    NSThread       	*myThread;
    NSString        *elementCheck;
    NSMutableArray  *outTitles;
    NSMutableString        *tmp;
}

-(id)initWithDelegate:(id)d :(NSURL *)u;

@end
