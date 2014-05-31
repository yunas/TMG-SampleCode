//
//  CreateExpenseTableCell.m
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatePayeeFeaturedCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

#import "UIColor+CustomColor.h"
#import "IOUser.h"

#import "Policy.h"
#import "PolicyConstants.h"

#import "CurrencyFormatterUtility.h"

@interface CreatePayeeFeaturedCell ()


@end

@implementation CreatePayeeFeaturedCell
@synthesize _paid,_title,_share,_balance,_imgView,_feature;
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

-(void) setBalanceText:(double)val withCurrency:(Currency *)currency forMember:(Policy *)policy{

    NSString *amount = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:val 
                                                         withSign:currency.sign]];
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = 1;//[CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*val;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }

    NSString *shareTxt = [NSString stringWithFormat:@"Gets: "];
    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor darkGreenColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_balance withAttributes:txtWithColors];


}

-(void) setShareText:(double)val withCurrencySign:(Currency *)currency forMember:(Policy *)policy{
    double share = val;
    NSString *amount = [NSString stringWithFormat:@"-%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:share 
                                                         withSign:currency.sign]];
    
    
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = 1;// [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*val;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }

    
    NSString *shareTxt = [NSString stringWithFormat:@"Share*: "];
    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor redColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_share withAttributes:txtWithColors];
 
    
}

-(void) setPaidText:(double)val withCurrency:(Currency *)currency forMember:(Policy*)policy{

    NSString *amount = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:val 
                                                         withSign:currency.sign]];

    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = 1;// [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*val;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                            formateCurrencyTypeFloat:balanceRate 
                                                            withSign:policy.user.currency.sign]];
    }
    
    
    NSString *shareTxt = [NSString stringWithFormat:@"Paid: "];

    UIColor *txtColor = [UIColor grayColor];
    UIColor *amountColor    = [UIColor darkGreenColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shareTxt,txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amount,amountColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_paid withAttributes:txtWithColors];

}

-(void) setFeatureText:(NSString *)policyTxt 
               withVal:(double)val 
          withCurrency:(Currency *)currency forMember:(Policy *)policy{
    
    
    NSString *amount = [NSString stringWithFormat:@"-%@",[CurrencyFormatterUtility 
                                                         formateCurrencyTypeFloat:val 
                                                         withSign:currency.sign]];
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = 1;//[CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*val;
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



#pragma mark - SET CONTENT STUFF
-(void) setExpensePayeeCellWith:(IOUser *)member
                          share:(Policy *)policy
                        andPaid:(NSNumber*)paid 
                   withCurrency:(Currency*)currency 
                    atIndexPath:(NSIndexPath *)indexPath {
   
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",member.fId]];
	[_imgView setImageWithURL:imgUrl placeholderImage:kIMG_User_PlaceHolder];

	[_title setText:member.name];
    
    [_feature setHidden:NO];

    double individualShare  = 0;
    double featuredShare    = 0;
    double balance            = 0;
    NSString *policyText = @"";
    
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
    
    if(policy.type==SPTypeFixedPercentage){
    
        balance=policy.share;
        individualShare=policy.share;
        [_feature setHidden:YES];
        CGRect shareFrame=_share.frame;
        shareFrame.origin.y=_feature.frame.origin.y;
        _share.frame=shareFrame;
    
    }else{
    
        balance =  [paid doubleValue] - (individualShare + featuredShare) ;

    }
    
    [self setShareText:individualShare withCurrencySign:currency forMember:policy];
    [self setFeatureText:policyText withVal:featuredShare withCurrency:currency forMember:policy];
    [self setPaidText:[paid doubleValue] withCurrency:currency forMember:policy];
    [self setBalanceText:balance withCurrency:currency forMember:policy];
    
    [_btn setTag:indexPath.row];

    
}

@end
