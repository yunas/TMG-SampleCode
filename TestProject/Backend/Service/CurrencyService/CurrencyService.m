//
//  CurrencyService.m
//  IOTab
//
//  Created by Yunas Qazi on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurrencyService.h"
#import "Currency.h"
#import "CurrencyConstants.h"
//#import "CurrencyUtility.h"

@implementation CurrencyService
@synthesize delegate;

//GETTER

//-(void) getCurrenciesFromServer{
//    
//    NSLog(@"%s ",__PRETTY_FUNCTION__);
//    
//    BOOL loadFromServer = NO; // Data is loading for file "currencyOffline.json", not from server
//
//    if (loadFromServer)
//    {
//        CurrencyFetcherCompletion CurrencyCompleteBlock = ^(NSArray *currenciesArr){
//            
//            //NOW I HAVE THE CURRENCIES MODEL IN THE ARRAY
//            NSLog(@"%s result ",__PRETTY_FUNCTION__);
//            [self setCurrenciesOnLocalDB:currenciesArr];
//            
//            
//        };
//        
//        CurrencyFetcherError CurrencyErrorBlock = ^(NSError *error){
//            NSLog(@"%s error %@",__PRETTY_FUNCTION__,error);
//            if ([delegate respondsToSelector:@selector(currencyFetchingFailedWithError:)]) {
//                [delegate currencyFetchingFailedWithError:error];
//            }
//        };
//        
//        CurrencyFetcher *fetcher = [[[CurrencyFetcher alloc]init]autorelease];
//        [fetcher fetchCurrenciesWithParams:nil completionBlock:CurrencyCompleteBlock errorBlock:CurrencyErrorBlock];
//    }
//	
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"currencyOffline" ofType:@"json"];
//    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
//    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
//    
////    NSArray *currenicesArr = [CurrencyUtility getCurrencyModelFrom:jsonObject withManagedObjectContext:self.managedObjectContext];
//
//    [self setCurrenciesOnLocalDB:currenicesArr];
//
//}


+ (Currency*) getDefaultCurrency{
    Currency *defaultCurrency = [[Currency alloc]initWithDict:@{kCurrency_id: @1,
                                                                kCurrency_rate:@1,
                                                                kCurrency_name:@"US DOLLAR",
                                                                kCurrency_code:@"USD",
                                                                kCurrency_sign:@"$"}];

    return defaultCurrency;
}

-(NSArray *) getCurrenciesFromLocalDB{


//    "code": "DZD",
//    "name": "Algerian Dinar",
//    "sign": "D",
//    "rate": 0.009999999776482582
    
//    [self setCid:[NSNumber numberWithDouble:[[currencyDict objectForKey:kCurrency_id]doubleValue]]];
//	[self setRate:[NSNumber numberWithDouble:[[currencyDict objectForKey:kCurrency_rate]doubleValue]]];
//	[self setName:[currencyDict objectForKey:kCurrency_name]];
//	[self setCode:[currencyDict objectForKey:kCurrency_code]];
//	[self setSign:[currencyDict objectForKey:kCurrency_sign]];

    Currency *cur1 = [[Currency alloc]initWithDict:@{kCurrency_id: @1,
                                                    kCurrency_rate:@1,
                                                    kCurrency_name:@"US DOLLAR",
                                                    kCurrency_code:@"USD",
                                                    kCurrency_sign:@"$"}];
    
    Currency *cur2 = [[Currency alloc]initWithDict:@{kCurrency_id: @2,
                                                     kCurrency_rate:@1.017199993133545,
                                                     kCurrency_name:@"Canadian Dollar",
                                                     kCurrency_code:@"CAD",
                                                     kCurrency_sign:@"$"}];
    
    Currency *cur3 = [[Currency alloc]initWithDict:@{kCurrency_id: @3,
                                                     kCurrency_rate:@0.7257999777793884,
                                                     kCurrency_name:@"Euro",
                                                     kCurrency_code:@"EUR",
                                                     kCurrency_sign:@"€"}];
    
    Currency *cur4 = [[Currency alloc]initWithDict:@{kCurrency_id: @4,
                                                     kCurrency_rate:@86,
                                                     kCurrency_name:@"Pakistani Rupee",
                                                     kCurrency_code:@"PKR",
                                                     kCurrency_sign:@"Rs"}];

    Currency *cur5 = [[Currency alloc]initWithDict:@{kCurrency_id: @5,
                                                     kCurrency_rate:@0.009999999776482582,
                                                     kCurrency_name:@"Moldovan Leu",
                                                     kCurrency_code:@"MDL",
                                                     kCurrency_sign:@"L"}];

    
    	NSArray *currenciesArr = @[cur1,cur2,cur3,cur4,cur5];
    
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:
//                                              @"Currency" inManagedObjectContext:self.managedObjectContext];
//    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//    [request setEntity:entityDescription];
//    
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"cid" ascending:NO];
//    NSArray *sds = [NSArray arrayWithObjects:sortDescriptor, nil];
//    [sortDescriptor release];
//    [request setSortDescriptors:sds];
//    
//    NSError *error=nil;
//    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
//    
//    if ([array count]) {
//        return [NSMutableArray arrayWithArray:array];
//    }
//    else{
//        return nil;
//    }
	return currenciesArr;
}


#pragma mark - PUBLIC GETTERS

-(void) getCurrencies{

	NSArray *currenciesArr = nil;
	currenciesArr = [self getCurrenciesFromLocalDB];
	if (currenciesArr) {
		if ([delegate respondsToSelector:@selector(allCurrencies:)])
		{
			[delegate allCurrencies:currenciesArr];
		}
	}
	else {
		// DOWNLOAD THE CURRENCIES FROM SERVER AND SAVE LOCALLY
//		[self getCurrenciesFromServer];
	}
}

//+(Currency*) getCurrencyAgainst:(NSNumber *)cid withContext:(NSManagedObjectContext*)moc{
//
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:
//                                              @"Currency" inManagedObjectContext:moc];
//
//    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//    [request setEntity:entityDescription];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"cid == %@",cid];
//    [request setPredicate:predicate];
//    
//    NSError *error=nil;
//    NSArray *array = [moc executeFetchRequest:request error:&error];
//    Currency *currentItem = nil;
//    for (Currency *item in array) {
//        currentItem = item;
//    }
//    return currentItem;
//
//}




#pragma mark - PUBLIC SETTERS
//SETTER

-(void) setCurrenciesOnLocalDB:(NSArray *)currenciesArr{
	
//	[self.managedObjectContext save:nil];
//	
//	NSArray *localCurrencyArr = nil;
//	localCurrencyArr = [self getCurrenciesFromLocalDB];
//	if (localCurrencyArr) {
//		if ([delegate respondsToSelector:@selector(allCurrencies:)])
//		{
//			[delegate allCurrencies:localCurrencyArr];
//		}
//	}
//	else {
//		NSLog(@"Problem saving the currency Locally ");
//	}
	
}


+(double) getCurrencyRateFor:(NSNumber *)forCid againstCurrency:(NSNumber *)againstCid{
    double val = 0;
    
//  val =   [Currency getCurrencyRateFor:forCid againstCurrency:againstCid inContext:[[CoreDataProvider instance]managedObjectContext]];
    return val;
}


@end
