//
//  CurrencyConverter.h
//  IOTab
//
//  Created by Yunas Qazi on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownController.h"
#import "CurrencyService.h"

@protocol CurrencyConverterDelegate;

@interface CurrencyConverter : UIViewController<DropDownDelegate,CurrencyServiceDelegate>{
	NSArray *currencyArr;
	IBOutlet UITextField *tfCurrency;
	IBOutlet UITextField *tfAmount;
	IBOutlet UIButton *btnCurrency;
	IBOutlet UILabel *lblConverter;
    IBOutlet UIToolbar *barAccessory;
    Currency *_selectedCurrency;
    DropDownController *dropDownController;
	
}

@property (nonatomic,retain) UIView *parentView;
@property (nonatomic,assign) id<CurrencyConverterDelegate> delegate;
@property (nonatomic,retain) Currency *currencyForGroup;

-(void) setPlaceHolder:(NSString *)txt;
- (void) setConverterSelectedCurrency:(Currency *)_currency;
//-(NSString *) selectedCurrency;
-(Currency *) selectedCurrency;
-(NSNumber *) getCurrencyId;
-(NSString *) getCurrencySign;
-(Currency*) getSelectedCurrency;
-(NSString*) getAmountEntered;
- (void) setAmount;
-(void) setSelectedGroupCurrecyWithId:(NSNumber *)cid;
- (IBAction)doneButton:(id)sender;

@end


@protocol CurrencyConverterDelegate <NSObject>

@optional
-(void)currencyChanged:(NSNumber *)currencyId;
-(void)AmountChanged:(NSString *)amount;
-(void)donePressed:(NSString*)amount;
-(void)currencyViewIsPresented;

@end