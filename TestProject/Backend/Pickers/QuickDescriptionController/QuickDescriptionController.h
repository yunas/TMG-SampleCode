//
//  QuickDescriptionController.h
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QuickDescriptionDelegate;



@interface QuickDescriptionController : UIViewController
{
	IBOutlet UITableView *_tableView;
	NSArray *descriptorsArr;
	NSString *selectedDescription;
	
}

-(void) preselectDescription:(NSString*)description;
@property (nonatomic,assign) id<QuickDescriptionDelegate> delegate;
- (IBAction)closeQuickDescription:(id)sender;

@end


@protocol QuickDescriptionDelegate <NSObject>

-(void) descriptionSelected:(NSString *)description;
-(void) descriptionSelected:(NSString *)description
                  andTextId:(NSUInteger)_textId;

@end