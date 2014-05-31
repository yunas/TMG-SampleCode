//
//  CurrencyService.h
//  IOTab
//
//  Created by Yunas Qazi on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;
@protocol CurrencyServiceDelegate ;


@interface CurrencyService : NSObject

@property (nonatomic,assign) id<CurrencyServiceDelegate> delegate;

- (void) getCurrencies;
+ (Currency*) getDefaultCurrency;

//+(Currency*) getCurrencyAgainst:(NSNumber *)cid withContext:(NSManagedObjectContext*)moc;
+(double) getCurrencyRateFor:(NSNumber *)forCid againstCurrency:(NSNumber *)againstCid;
@end



@protocol CurrencyServiceDelegate <NSObject>

-(void) allCurrencies:(NSArray *)currenciesArr;

@optional
-(void) currencyFetchingFailedWithError:(NSError *)error;
@end