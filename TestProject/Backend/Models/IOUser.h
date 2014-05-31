//
//  IOUser.h
//  IOTab
//
//  Created by Yunas Qazi on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

@interface IOUser : NSObject

@property (nonatomic, retain) NSNumber * fId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *contributions;
@property (nonatomic, retain) Currency *currency;
@property (nonatomic, retain) NSSet *enrollments;
@property (nonatomic, retain) NSSet *posts;


-(void) parseWithDict:(NSDictionary *)userDict ;
-(id) initWithDict:(NSDictionary *)userDict;

+(NSArray *) getAllUsersFromLocalDBWithContext;

@end
