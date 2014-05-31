//
//  CreateExpenseTableCell.h
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"


@class IOUser;
@class Policy;
@interface CreateExpenseFeaturedCell : BaseCell

@property(nonatomic, retain) IBOutlet UIImageView	*_imgView;
@property(nonatomic, retain) IBOutlet UILabel	*_title;
@property(nonatomic, retain) IBOutlet UIButton	*_btn;

@property(nonatomic, retain) IBOutlet OHAttributedLabel     *_share;
@property(nonatomic, retain) IBOutlet OHAttributedLabel     *_feature;
@property(nonatomic, retain) IBOutlet OHAttributedLabel     *_total;



-(void) applyFormatting;
-(void) setExpenseCellWith:(IOUser *)member
                     share:(Policy *)policy
              withCurrency:(Currency*)currency
               atIndexPath:(NSIndexPath*)indexPath;

@end
