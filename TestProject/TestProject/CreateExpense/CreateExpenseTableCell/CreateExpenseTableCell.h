//
//  CreateExpenseTableCell.h
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@class Policy;
@class IOUser;
@interface CreateExpenseTableCell : BaseCell <OHAttributedLabelDelegate>

@property(nonatomic, retain) IBOutlet UIImageView	*_imgView;
@property(nonatomic, retain) IBOutlet UILabel	*_title;
@property(nonatomic, retain) IBOutlet UILabel	*_balance;
@property(nonatomic, retain) IBOutlet UILabel	*_criteria;
@property(nonatomic, retain) IBOutlet UIButton	*_btn;

@property (retain, nonatomic) IBOutlet UILabel *notIncludedLabel;
@property (retain, nonatomic) IBOutlet UIView *crossLine;

-(void) applyFormatting;

-(void) setExpenseCellWith:(IOUser *)member 
                     share:(Policy *)policy
              withCurrency:(Currency*)currency
               atIndexPath:(NSIndexPath*)indexPath  ;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *balnceTxt;

@end
