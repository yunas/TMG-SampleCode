//
//  SharingPolicyController.h
//  IOTab
//
//  Created by Yunas Qazi on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyConstants.h"
#import "Policy.h"

@protocol SharingPolicyDelegate;

@interface SharingPolicyController : UIViewController<UITextFieldDelegate>
{
	IBOutlet UITableView *_tableView;
	NSArray *policyArr;
	NSString *selectedPolicy;
    SPType previousPolicyType;
    
    double totalPercentage;
    double remainingPercentage;
    double totalFixedAmount;
    double remainingTotalAmount;
    
	
}

@property (nonatomic,retain) Policy *policy;
@property (nonatomic,retain) NSArray *allPoliciesArr;
@property double totalAmount;
-(void) preselectPolicy:(NSString*)policy;
@property (nonatomic,assign) id<SharingPolicyDelegate> delegate;
- (IBAction)closeSharingPolicy:(id)sender;

@end


@protocol SharingPolicyDelegate <NSObject>

-(void) sharingPolicySelected:(SPType )policyType;

@end


