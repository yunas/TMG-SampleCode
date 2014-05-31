//
//  IOUserService.h
//  IOTab
//
//  Created by Yunas Qazi on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class IOUser;
//@protocol IOUserServiceDelegate ;


typedef void (^IOUserServiceCompletion)(NSArray *usersArr);
typedef void (^IOUserServiceError)(NSError *error);


@interface IOUserService : NSObject

//@property (nonatomic,assign) id<IOUserServiceDelegate> delegate;

-(void) getAllUsersWithSuccess:(IOUserServiceCompletion)successBlock andError:(IOUserServiceError)errorBlock;
-(void) syncUserssWithSuccess:(IOUserServiceCompletion)successBlock andError:(IOUserServiceError)errorBlock;

-(IOUser*) getAppUser;
@end



//@protocol IOUserServiceDelegate <NSObject>
//
//@optional
//-(void)serverRequestFailed:(NSError*)error;
//-(void) allUsers:(NSArray *)users;
//
//@end