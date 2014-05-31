//
//  IOUser.m
//  IOTab
//
//  Created by Yunas Qazi on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IOUser.h"
#import "Currency.h"



#import "IOUserConstants.h"

@implementation IOUser


#pragma mark - PARSER STUFF




-(id) initWithDict:(NSDictionary *)userDict{
    self = [super init];
    if (self) {
        [self parseWithDict:userDict];
    }
    return self;
}

-(void) parseWithDict:(NSDictionary *)userDict {
	[self setFId		:[NSNumber numberWithDouble:[userDict[kIOUSER_FID]doubleValue]]];
	[self setName		:[userDict objectForKey:kIOUSER_Name]];
	[self setUid		:[NSNumber numberWithDouble:[[userDict objectForKey:kIOUSER_Id]doubleValue]]];
}





+(NSArray *) getAllUsersFromLocalDBWithContext{
	NSArray *usersArr = nil;
	
    NSArray *array ;//[managedObjectContext executeFetchRequest:request error:&error];
    
    if ([array count]) {
        return [NSMutableArray arrayWithArray:array];
    }
    else{
        return nil;
    }
	return usersArr;
}


@end
