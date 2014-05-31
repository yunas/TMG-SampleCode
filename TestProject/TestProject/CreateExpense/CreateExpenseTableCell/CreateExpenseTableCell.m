//
//  CreateExpenseTableCell.m
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateExpenseTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColor.h"

#import "IOUser.h"
#import "CurrencyFormatterUtility.h"

#import "Policy.h"
#import "PolicyConstants.h"




#define CELL_BACKGROUND_COLOR    [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

@interface CreateExpenseTableCell ()


@end

@implementation CreateExpenseTableCell
@synthesize _title,_balance,_imgView,_criteria;
@synthesize _btn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


#pragma mark - FORMAT STUFF
-(void) applyFormatting{
    [_imgView.layer setCornerRadius:5];
    [_imgView.layer setMasksToBounds:YES];
    [_btn.layer setCornerRadius:5];
    [_btn.layer setMasksToBounds:YES];
    [self.contentView setBackgroundColor:[UIColor lightGreenColor]];
}

#pragma mark - APPLY COLORING




#pragma mark - SET CONTENT STUFF
-(void) setExpenseCellWith:(IOUser *)member
                     share:(Policy *)policy
              withCurrency:(Currency*)currency
               atIndexPath:(NSIndexPath*)indexPath  {
   

    NSString *policyShare=@"";
    
    if(!policy.isMember){
        
        double rate = 1.0;//[CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*policy.share;
        policyShare = [policyShare stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility
                                                                      formateCurrencyTypeFloat:balanceRate
                                                                      withSign:policy.user.currency.sign]];
        currency=policy.user.currency;


    }else{
    
        policyShare = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility
                                                        formateCurrencyTypeFloat:policy.share
                                                        withSign:currency.sign]];
    }
    

    if (policy.type == SPTypeNotIncluded) {
        [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
        [self.notIncludedLabel setHidden:NO];
        [self.crossLine setHidden:NO];
    }
    else {
        
        [self.contentView setBackgroundColor:[UIColor lightGreenColor]];
        [self.notIncludedLabel setHidden:YES];
        [self.crossLine setHidden:YES];
    }
    
	[_imgView setImage:kIMG_User_PlaceHolder];
	[_title setText:member.name];
    
   

    NSString *shareTxt = [NSString stringWithFormat:@"Owes: "];
    if (policy.type != SPTypeEqaulShare) {
        shareTxt = [NSString stringWithFormat:@"Owes*: "];
    }
    
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = 1.0;//[CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*policy.share;
        policyShare = [policyShare stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }

    
    UIColor *shareTxtColor = [UIColor grayColor];
    UIColor *shareColor = [UIColor redColor];
    if (policy.share <= 0) {
        shareColor = [UIColor blackColor];
    }
    
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,shareTxtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:policyShare,shareColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
      [self setTextForLabel:self.balnceTxt withAttributes:txtWithColors];
    
    [_btn setTag:indexPath.row];
    
    CGSize maximumSize = CGSizeMake(145, 45);
//    CGSize myStringSize = [_title.text sizeWithFont:_title.font
//                                       constrainedToSize:maximumSize
//                                           lineBreakMode:NSLineBreakByWordWrapping];

    CGRect rect = [_title.text
                   boundingRectWithSize:maximumSize
                   options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:nil
                   context:nil];
    
    CGSize myStringSize = rect.size;
    
    CGRect lineFrame=self.crossLine.frame;
    float width=_title.text.length*8;
    if(width>145)
        width=140;
    lineFrame.size.width=myStringSize.width;
    
    self.crossLine.frame=lineFrame;

}

@end
