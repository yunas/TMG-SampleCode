//
//  CurrencyFormatterUtility.h
//  IOTab
//
//  Created by Yunas Qazi on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyFormatterUtility : NSObject

+(NSString *) formatCurrencyTypeFloat: (float )val;
+(NSString *) formatCurrency: (NSDecimalNumber *)val;
+(NSString *) formateCurrencyTypeFloat:(float)val withSign:(NSString *)currencySign;
@end
