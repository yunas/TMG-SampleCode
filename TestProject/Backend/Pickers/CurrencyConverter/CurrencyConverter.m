//
//  CurrencyConverter.m
//  IOTab
//
//  Created by Yunas Qazi on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurrencyConverter.h"
#import "CurrencyFormatterUtility.h"
#import "Currency.h"

@interface CurrencyConverter ()

@end

@implementation CurrencyConverter
@synthesize parentView;
@synthesize delegate;
@synthesize currencyForGroup;


-(BOOL) isValidInput{
    BOOL isValid = NO;
    NSString *matchphrase = @"[0-9]*.[0-9]*";
    NSPredicate *matchPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchphrase];
    isValid = [matchPred evaluateWithObject:tfAmount.text]; 
    
    return isValid;
}


-(IBAction)cancelButton:(id)sender{
    tfAmount.text=@"";
    [tfAmount resignFirstResponder];
}

- (IBAction)doneButton:(id)sender {
    
    if (![self isValidInput]) {
        return;
    }
    [tfAmount resignFirstResponder];
    
    if ([delegate respondsToSelector:@selector(donePressed:)]) {
        [delegate donePressed:tfAmount.text];
    }
}


#pragma mark - XCODE STANDARD METHODS

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self getCurrencies];
    tfAmount.inputAccessoryView = barAccessory;
    tfAmount.keyboardType = UIKeyboardTypeDecimalPad;
    
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark- SERVICE STUFF
-(void) getCurrencies{
	CurrencyService *curService = [[CurrencyService alloc]init];
	curService.delegate = self;
	[curService getCurrencies];
}

#pragma mark - CurrencyService Delegates
-(void) allCurrencies:(NSArray *)currenciesArr{

	currencyArr = [[NSArray alloc]initWithArray:currenciesArr];
	
    if (currencyForGroup) {
        _selectedCurrency = currencyForGroup;
        [tfCurrency setText:[_selectedCurrency formattedCurrency]];
    }
    else{
        if (currencyArr.count) {
            
            Currency *cur = [currencyArr objectAtIndex:0];
            _selectedCurrency = cur;
            [tfCurrency setText:[cur formattedCurrency]];
        }
    }
}

-(void)currencyFetchingFailedWithError:(NSError *)error{
    
//    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:nil title:@"ERROR" message:[error description]];
//    [notice show];

    
}




#pragma mark - DROPDOWN STUFF
- (IBAction)openCurrencyOptions:(UIButton *)sender {
	if(currencyArr.count)
    {
        dropDownController = [DropDownController new];
        {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (Currency *currency in currencyArr) {
                
                NSLog(@"Currency is %@",[currency formattedCurrency]);
                [tmpArr addObject:[currency formattedCurrency]];
                
            }
            [dropDownController setDataArr:tmpArr];
        }
        
        [dropDownController setSelectedText:[tfCurrency text]];
        [dropDownController setDelegate:self];
        [dropDownController presentDropDownInView:parentView];
        
        if ([self.delegate respondsToSelector:@selector(currencyViewIsPresented)]) {
            [self.delegate currencyViewIsPresented];
        }
        
    }
    else {
        [self getCurrencies];
    }
}


#pragma mark - DROPDOWN DELEGATE
- (void) setConverterSelectedCurrency:(Currency *)_currency{

    _selectedCurrency=_currency;
    
}
-(void) itemSelectedWithText:(NSString*)text atIndex:(int)index{
	NSLog(@"%s %@",__PRETTY_FUNCTION__,text);
	[tfCurrency setText:text];
    _selectedCurrency = [currencyArr objectAtIndex:index];
    if ([delegate respondsToSelector:@selector(currencyChanged:)]) {
        Currency * cur = [currencyArr objectAtIndex:index];
        [delegate  currencyChanged:cur.cid];
    }
}


#pragma mark - PUBLIC METHODS

-(void) setSelectedGroupCurrecyWithId:(NSNumber *)cid{
    for (Currency *cur in currencyArr) {
        if ([cur.cid isEqualToNumber:cid]){
            [self setCurrencyForGroup:cur];
            [tfCurrency setText:[cur formattedCurrency]];
			break;
		}
	}
}

-(void) setPlaceHolder:(NSString *)txt{
	[tfCurrency setPlaceholder:txt];
}


-(NSString*) getAmountEntered{
    
	return tfAmount.text;
}
- (void) setAmount{

    [tfAmount setText:@""];
}


-(NSNumber *) getCurrencyId{

	Currency* cur =[self selectedCurrency];
	NSNumber *currencyID = cur.cid;
	for (Currency *cur in currencyArr) {
        
		if ([[cur formattedCurrency] isEqualToString:tfCurrency.text]){
			currencyID = cur.cid;
			break;
		}
	}
    
	return currencyID ;
}

-(Currency *) selectedCurrency{
	return _selectedCurrency;
}



-(Currency*) getSelectedCurrency{
    Currency *currency = nil;
    for (Currency *cur in currencyArr) {
		if ([cur.code isEqualToString:tfCurrency.text]){
			currency = cur;
			break;
		}
	}
    return currency;
}

-(NSString *) getCurrencySign{
	
	NSString *currencySign = nil;
	for (Currency *cur in currencyArr) {
		if ([cur.code isEqualToString:tfCurrency.text]){
			currencySign = cur.sign;
			break;
		}
	}
	return currencySign;
}

#pragma mark - 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    if ([delegate respondsToSelector:@selector(AmountChanged:)]) {
        [textField setText:substring];
        [delegate AmountChanged:substring];
    }
    return NO;
}



@end
