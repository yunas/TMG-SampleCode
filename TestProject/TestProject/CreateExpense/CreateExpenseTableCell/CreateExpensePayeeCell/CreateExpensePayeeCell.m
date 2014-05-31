//
//  CreateExpenseTableCell.m
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateExpensePayeeCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CustomColor.h"
#import "IOUser.h"
#import "CurrencyFormatterUtility.h"
#import "NSAttributedString+Attributes.h"
#import "CurrencyService.h"

#import "Policy.h"
#import "PolicyConstants.h"

#define CELL_BACKGROUND_COLOR    [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

@interface CreateExpensePayeeCell ()


@end

@implementation CreateExpensePayeeCell
@synthesize _paid,_title,_share,_balance,_imgView;
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

//- (void)dealloc {
//    [_notIncludedLabel release];
//    [_crossLine release];
//	[super dealloc];
//}

#pragma mark - FORMAT STUFF
-(void) applyFormatting{
    
    [_imgView.layer setCornerRadius:5];
    [_imgView.layer setMasksToBounds:YES];
    [_btn.layer setCornerRadius:5];
    [_btn.layer setMasksToBounds:YES];
    [self.contentView setBackgroundColor:[UIColor lightGreenColor]];
}


#pragma mark - APPLY COLORING

-(void) setBalanceText:(double)balance withCurrency:(Currency *)currency forMember:(Policy *)p{
    

    
    NSString *policyShare = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                              formateCurrencyTypeFloat:balance 
                                                              withSign:currency.sign]];

    
    if (![currency.cid isEqualToNumber:p.user.currency.cid]) {
        double rate = [CurrencyService getCurrencyRateFor:p.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*balance;
        policyShare = [policyShare stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                                      formateCurrencyTypeFloat:balanceRate 
                                                                      withSign:p.user.currency.sign]];
    }

    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *balanceColor    = [UIColor darkGreenColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Gets: ",txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:policyShare,balanceColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    [self setTextForLabel:_balance withAttributes:txtWithColors];
}

-(void) setShareText:(Policy *)policy withCurrency:(Currency*)currency{

    
    double share = policy.share;
    NSString *amount = [NSString stringWithFormat:@"-%@",[CurrencyFormatterUtility 
                                                              formateCurrencyTypeFloat:share 
                                                              withSign:currency.sign]];
    
    if (![currency.cid isEqualToNumber:policy.user.currency.cid]) {
        double rate = [CurrencyService getCurrencyRateFor:policy.user.currency.cid againstCurrency:currency.cid];
        double balanceRate = rate*policy.share;
        amount = [amount stringByAppendingFormat:@" (%@)", [CurrencyFormatterUtility 
                                                                      formateCurrencyTypeFloat:balanceRate 
                                                                      withSign:policy.user.currency.sign]];
    }
    
    NSString *shareTxt = [NSString stringWithFormat:@"Share: "];
    if (policy.type != SPTypeEqaulShare) {
        shareTxt = [NSString stringWithFormat:@"Share*: "];
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

-(void) setPaidText:(double)paid andCurrencySign:(NSString *)currencySign{
   
  
    
    NSString *amountTxt = [NSString stringWithFormat:@"%@",[CurrencyFormatterUtility 
                                                              formateCurrencyTypeFloat:paid 
                                                              withSign:currencySign]];
    
    UIColor *txtColor = [UIColor grayColor];
    UIColor *balanceColor    = [UIColor darkGreenColor];
    NSArray *txtWithColors = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Paid: ",txtColor, nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],
                              [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:amountTxt,balanceColor , nil]
                                                          forKeys:[NSArray arrayWithObjects:kTxt,kColor, nil]],nil];
    
    [self setTextForLabel:_paid withAttributes:txtWithColors];

}



#pragma mark - SET CONTENT STUFF
-(void) setExpensePayeeCellWith:(IOUser *)member
                          share:(Policy *)policy
                        andPaid:(NSNumber*)paid 
                   withCurrency:(Currency*)currency 
                    atIndexPath:(NSIndexPath *)indexPath {


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
    
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",member.fId]];

	[_imgView setImageWithURL:imgUrl placeholderImage:kIMG_User_PlaceHolder];
	[_title setText:member.name];

    [self setShareText:policy withCurrency:currency];
    [self setPaidText:[paid doubleValue] andCurrencySign:currency.sign];
    [self setBalanceText:[paid doubleValue]-policy.share withCurrency:currency forMember:policy];
    [_btn setTag:indexPath.row];
    
    CGSize maximumSize = CGSizeMake(145, 45);
//    CGSize myStringSize = [_title.text
//                           sizeWithFont:_title.font
//                           constrainedToSize:maximumSize
//                           lineBreakMode:NSLineBreakByWordWrapping];
    
    
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
