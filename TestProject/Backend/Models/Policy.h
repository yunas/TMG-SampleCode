//
//  Policy.h
//  IOTab
//
//  Created by Yunas Qazi on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PolicyConstants.h"

#import "IOUser.h"

@interface Policy : NSObject

@property (nonatomic,retain) IOUser *user;
@property       double share;
@property       double featuredShare;
@property       SPType type;
@property       double fixedPrice;
@property       double fixedPercentage;    
@property       BOOL isMember;

-(id) initWithContributorId:(NSNumber *)__cid andShare:(double)__share andType:(SPType)__type;
+(Policy*) getPolicyUserWithContributionId:(NSNumber *)__cid andShare:(double)__share andType:(SPType)__type;
@end


