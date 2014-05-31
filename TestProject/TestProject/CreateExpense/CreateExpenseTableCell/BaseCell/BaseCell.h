//
//  BaseCell.h
//  IOTab
//
//  Created by Yunas Qazi on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTxt @"TXT"
#define kColor @"Color"
#define kBold  @"Bold"
#import "OHAttributedLabel.h"
#import "Currency.h"

@interface BaseCell : UITableViewCell

-(void) setTextForLabel:(OHAttributedLabel*)label withAttributes:(NSArray *)txtWithColorsArr;

@end
