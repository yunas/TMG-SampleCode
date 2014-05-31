//
//  Policy.m
//  IOTab
//
//  Created by Yunas Qazi on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Policy.h"


@implementation Policy

@synthesize user,share,featuredShare,type,fixedPrice,fixedPercentage,isMember;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id) initWithContributorId:(NSNumber *)__cid andShare:(double)__share andType:(SPType)__type{
    self = [super init];
    if (self) {
        
        self.user.uid = __cid;
        self.share = __share;
        self.type = __type;    
    }
    return self;
   
}

+(Policy*) getPolicyUserWithContributionId:(NSNumber *)__cid andShare:(double)__share andType:(SPType)__type{
    
    Policy *p = [Policy new];
    p.user.uid = __cid;
    p.share = __share;
    p.type = __type;    
    return p;
}

@end
