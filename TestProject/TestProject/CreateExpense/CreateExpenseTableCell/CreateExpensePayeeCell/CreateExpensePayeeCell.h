//
//  CreateExpenseTableCell.h
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OHAttributedLabel.h"
#import "BaseCell.h"

@class IOUser;
@class Policy;

@interface CreateExpensePayeeCell : BaseCell

@property(nonatomic, retain) IBOutlet UIImageView	*_imgView;
@property(nonatomic, retain) IBOutlet UILabel	*_title;
@property(nonatomic, retain) IBOutlet OHAttributedLabel	*_paid;
@property(nonatomic, retain) IBOutlet OHAttributedLabel	*_share;
@property(nonatomic, retain) IBOutlet OHAttributedLabel	*_balance;
@property(nonatomic, retain) IBOutlet UIButton	*_btn;
@property (retain, nonatomic) IBOutlet UILabel *notIncludedLabel;
@property (retain, nonatomic) IBOutlet UIView *crossLine;

-(void) applyFormatting;
-(void) setExpensePayeeCellWith:(IOUser *)member
                          share:(Policy *)policy
                        andPaid:(NSNumber*)paid 
                   withCurrency:(Currency*)currency
                    atIndexPath:(NSIndexPath *)indexPath;

@end
