//
//  CurrencyFormatterUtility.m
//  IOTab
//
//  Created by Yunas Qazi on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurrencyFormatterUtility.h"

@implementation CurrencyFormatterUtility

+(NSString *) formatCurrency: (NSDecimalNumber *)val {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromNumber:val];
    
}

+(NSString *) formatCurrencyTypeFloat: (float )val {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]]; 
    NSLog(@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:val]]);
    return [formatter stringFromNumber:[NSNumber numberWithFloat:val]];
    
}

+(NSString *) formateCurrencyTypeFloat:(float)val withSign:(NSString *)currencySign{

    NSNumberFormatter * fmt = [[ NSNumberFormatter alloc ] init ];
    NSNumber          * n   = [ NSNumber numberWithFloat: val];
    [ fmt setFormatterBehavior: NSNumberFormatterBehavior10_4 ];
    [fmt setCurrencySymbol:currencySign];
    [ fmt setNumberStyle: NSNumberFormatterCurrencyStyle ];
    

    return [ fmt stringFromNumber:n];
}
@end
