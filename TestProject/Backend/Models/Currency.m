//
//  Currency.m
//  IOTab
//
//  Created by Yunas Qazi on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Currency.h"
#import "IOUser.h"

#import "CurrencyConstants.h"

@implementation Currency



+(double) getCurrencyRateFor:(NSNumber *)forCid againstCurrency:(NSNumber *)againstCid{
    
    
//    Currency *forCurrency = [Currency getCurrencyAgainst:forCid withContext:moc];
//    Currency *againstCurrency  = [Currency getCurrencyAgainst:againstCid withContext:moc];

    double rate = 1;
//    if (![forCurrency.cid isEqualToNumber:againstCurrency.cid]) {
//        rate = (1/[againstCurrency.rate doubleValue]) *[forCurrency.rate doubleValue];
//    }
    return rate;
}


#pragma mark - PARSER STUFF

-(id) initWithDict:(NSDictionary *)currencyDict{
    self = [super init];
    if (self) {
        [self parseCurrencyWith:currencyDict];
    }
    return self;
}


-(void) parseCurrencyWith :(NSDictionary *)currencyDict{
    
	[self setCid:[NSNumber numberWithDouble:[[currencyDict objectForKey:kCurrency_id]doubleValue]]];
	[self setRate:[NSNumber numberWithDouble:[[currencyDict objectForKey:kCurrency_rate]doubleValue]]];
	[self setName:[currencyDict objectForKey:kCurrency_name]];
	[self setCode:[currencyDict objectForKey:kCurrency_code]];
	[self setSign:[currencyDict objectForKey:kCurrency_sign]];
}


#pragma mark - GETTERS

- (NSString *) formattedCurrency{
    
    NSString *currencyName = [NSString stringWithFormat:@"%@ - %@ %@",[self name],[self code],[self sign]];
    
    return currencyName;
}
@end
