//
//  CreateExpenseController.h
//  IOTab
//
//  Created by Yunas Qazi on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyConverter.h"
#import "SharingPolicyController.h"
#import "QuickDescriptionController.h"

@class Currency;
@protocol CreateExpenseDelegate;


@interface CreateExpenseController : UIViewController
<CurrencyConverterDelegate,
SharingPolicyDelegate,
QuickDescriptionDelegate>
{
    
	IBOutlet UITableView *_tableView;
	IBOutlet UITextField *_tfDescription;
	CurrencyConverter *curConverter;
	
	NSMutableArray *contributorsArr;//==> Array of users who are contributing in expense
    NSMutableArray *policyArr;      //==> To contain the sharing Policy of each selected+member(Contributor)
    
    Currency *selectedCurrency;
    NSNumber *payeeMemberId;
    int policyContributorCount;
    double headerHeight;
    IBOutlet UIView *_selectorView;
    
}

@property (nonatomic,assign) id<CreateExpenseDelegate> delegate;
@property (nonatomic,retain) NSNumber *groupId;

@end


@protocol CreateExpenseDelegate <NSObject>

-(void) expenseCreatedSuccessfully;

@optional 

-(void) expenseCreationFailed;


@end