//
//  IOUserService.m
//  IOTab
//
//  Created by Yunas Qazi on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IOUserService.h"
#import "IOUser.h"
#import "IOUserConstants.h"

//#import "UsersFetcher.h"

@implementation IOUserService
//@synthesize delegate;

//GETTER

-(void) getUsersFromServerWithSuccess:(IOUserServiceCompletion)successBlock
                             andError:(IOUserServiceError)errorBlock{

//	NSMutableDictionary *params = [[[NSMutableDictionary alloc]init]autorelease];
//	[params setValue:[DataBridge dataForKey:kFBAuth] forKey:kFBAuth];
//	
//	UsersFetcherCompletion UserCompleteBlock = ^(NSArray *IOUsersArr){
//        
//		[self setUsersOnLocalDBAndReturnWithSuccess:successBlock
//                                           andError:errorBlock];
//        
//	};
//	
//	UsersFetcherError UserErrorBlock = ^(NSError *error){
//        errorBlock(error);
////        if ([delegate respondsToSelector:@selector(serverRequestFailed:)]) {
////            [delegate serverRequestFailed:error];
////        }
//
//	};
//	
//	UsersFetcher *fetcher = [[[UsersFetcher alloc]init]autorelease];
//	[fetcher fetchAllUsersWithParams:params completionBlock:UserCompleteBlock errorBlock:UserErrorBlock];
	
}




-(NSArray *) getUsersFromLocalDBWithSuccess:(IOUserServiceCompletion)successBlock
                                   andError:(IOUserServiceError)errorBlock{

    
    IOUser *user1 = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@1133183378,kIOUSER_Name:@"Yunas Qazi",kIOUSER_Id:@1}];
    IOUser *user2 = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@100000780334679,kIOUSER_Name:@"Imran Khan",kIOUSER_Id:@2}];
    IOUser *user3 = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@1536465468,kIOUSER_Name:@"Salman Ronaldo",kIOUSER_Id:@3}];
    IOUser *user4 = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@1519660979,kIOUSER_Name:@"Nabeel Javaid",kIOUSER_Id:@4}];
    IOUser *user5 = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@7952995,kIOUSER_Name:@"Omer Shakil",kIOUSER_Id:@5}];
    
    

    NSArray *usersArr = [NSArray arrayWithObjects:user1,user2,user3,user4,user5, nil];
    successBlock(usersArr);
	return usersArr;

}


#pragma mark - PUBLIC GETTERS

-(void) getAllUsersWithSuccess:(IOUserServiceCompletion)successBlock
                      andError:(IOUserServiceError)errorBlock{
	
    [self getUsersFromLocalDBWithSuccess:^(NSArray *usersArr) {
       
        if (usersArr.count > 1 ) {
            successBlock(usersArr);
        }
        else {
            [self getUsersFromServerWithSuccess:^(NSArray *usersArr) {
                successBlock(usersArr);
            } andError:^(NSError *error) {
                errorBlock(error);
            }];
        }
    } andError:^(NSError *error) {
        
    }];
	
	
}

- (void)syncUserssWithSuccess:(IOUserServiceCompletion)successBlock
                     andError:(IOUserServiceError)errorBlock
{
    [self getUsersFromServerWithSuccess:^(NSArray *usersArr) {
        successBlock(usersArr);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}


-(IOUser*) getAppUser{
    IOUser *user = [[IOUser alloc]initWithDict:@{kIOUSER_FID:@1133183378,kIOUSER_Name:@"Yunas Qazi",kIOUSER_Id:@1}];
    return user;
//   return [IOUser getUserWithId:[DataBridge dataForKey:kUserLogInId] withContext:self.managedObjectContext];
}

#pragma mark - PUBLIC SETTERS
//SETTER

-(void) setUsersOnLocalDBAndReturnWithSuccess:(IOUserServiceCompletion)successBlock
                                     andError:(IOUserServiceError)errorBlock{
	
	
    [self getUsersFromLocalDBWithSuccess:^(NSArray *usersArr) {
        successBlock(usersArr);
        
    } andError:^(NSError *error) {
        NSError *errorM = [NSError errorWithDomain:@"Custom" code:420 userInfo:@{@"msg":@"Problem saving the currency Locally"}];
        errorBlock(errorM);
    }];


	
}



@end
