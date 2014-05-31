//
//  Currency.h
//  IOTab
//
//  Created by Yunas Qazi on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Currency : NSObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * sign;

-(void) parseCurrencyWith :(NSDictionary *)currencyDict;
-(id) initWithDict:(NSDictionary *)userDict;

- (NSString *) formattedCurrency;

+(double) getCurrencyRateFor:(NSNumber *)forCid againstCurrency:(NSNumber *)againstCid;


@end
