//
//  BaseCell.m
//  IOTab
//
//  Created by Yunas Qazi on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseCell.h"
#import "NSAttributedString+Attributes.h"

@implementation BaseCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - METHODS FOR ALL

-(void) setTextForLabel:(OHAttributedLabel*)label withAttributes:(NSArray *)txtWithColorsArr{
    
    NSString *txt = [NSString stringWithFormat:@""];
    for (NSDictionary *txtAndColorDict in txtWithColorsArr ){
        txt = [txt stringByAppendingFormat:@"%@",[txtAndColorDict valueForKey:kTxt]];
    }
    
    
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
	// for those calls we don't specify a range so it affects the whole string
	[attrStr setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
	[attrStr setTextColor:[UIColor blackColor]];
    
	// now we only change the color of "Share:"
    for (NSDictionary *txtAndColorDict in txtWithColorsArr ){
        [attrStr setTextColor:(UIColor*)[txtAndColorDict valueForKey:kColor] 
                        range:[txt rangeOfString:[txtAndColorDict valueForKey:kTxt]]];
        if ([txtAndColorDict valueForKey:kBold]) {
            [attrStr setTextBold:YES range:[txt rangeOfString:[txtAndColorDict valueForKey:kTxt]]];            
        }
        
    }
	
	/**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
	label.attributedText = attrStr;
	label.textAlignment = NSTextAlignmentRight;
}


@end
