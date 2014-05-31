//
//  CreateExpenseTableCell.m
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateExpenseFeaturedCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColor.h"

#import "IOUser.h"
#import "CurrencyFormatterUtility.h"
#import "CurrencyService.h"
//#import "NSAttributedString+Attributes.h"


#import "Policy.h"
#import "PolicyConstants.h"

@interface CreateExpenseFeaturedCell ()


@end

@implementation CreateExpenseFeaturedCell
@synthesize _title,_imgView,_share,_total,_feature;
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
-(void) setShareText:(double) share withCurrencySign:(Currency *)currency forMember:(Policy *)policy{
    
//    double share = policy.share;
    
    NSString *amount = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:share
                                                         withSign:currency.sign]];
    
    NSString *shareTxt = [NSString stringWithFormat:@"Share* : "];

    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*share;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                                      formateCurrencyTypeFloat:balanceRate 
                                                                      withSign:policy.user.currency.sign]];
    }

    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor redColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_share withAttributes:txtWithColors];

    

}

-(void) setFeatureText:(NSString *)policyTxt 
            withAmount:(double )amountVal
          withCurrency:(Currency*)currency
             forMember:(Policy*)policy{

    NSString *amount = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:amountVal 
                                                         withSign:currency.sign]];
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*amountVal;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }

    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor redColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:policyTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_feature withAttributes:txtWithColors];


}


-(void) setTotalText:(double)val withCurrency:(Currency *)currency forMember:(Policy *)policy{
    
    NSString *amount = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:val
                                                         withSign:currency.sign]];
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*val;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }

    NSString *shareTxt = [NSString stringWithFormat:@"Owes  "];
    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor redColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_total withAttributes:txtWithColors];
 

}




#pragma mark - SET CONTENT STUFF
-(void) setExpenseCellWith:(IOUser *)member
                     share:(Policy *)policy
              withCurrency:(Currency*)currency
               atIndexPath:(NSIndexPath*)indexPath{
   
//    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",member.fId]];

	[_imgView setImage:kIMG_User_PlaceHolder];
	[_title setText:member.name];

    
    double individualShare = 0;
    double featuredShare = 0;
    NSString *policyText = nil;
    
    if (policy.type == SPType1Guest) {
        
        individualShare = policy.share /2;
        featuredShare   = individualShare;
        policyText      = @"+1Guest:";
        
    } else if(policy.type == SPType2Guest){

        
        individualShare = policy.share/3;
        featuredShare = individualShare*2;
        policyText      = @"+2Guest:";
    }
    else if(policy.type == SPType3Guest){
        individualShare = policy.share/4;
        featuredShare = individualShare*3;
        policyText      = @"+3Guest:";
    }
    else if(policy.type == SPTypeFixedPercentage){
        individualShare = policy.share;
        featuredShare = individualShare*(policy.fixedPercentage/100.0);
        policyText      = @"FixedPer:";
    }
    
    
    
    [self setShareText:individualShare withCurrencySign:currency forMember:policy];
    [self setFeatureText:policyText withAmount:featuredShare withCurrency:currency forMember:policy];   
    [self setTotalText:policy.share withCurrency:currency forMember:policy];

    [_btn setTag:indexPath.row]; 


}

@end
