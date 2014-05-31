//
//  SharingPolicyController.m
//  IOTab
//
//  Created by Yunas Qazi on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharingPolicyController.h"
#import "BlockTextPromptAlertView.h"

#define kTagFixedPercentage 4200
#define kTagFixedAmount     9211

@interface SharingPolicyController ()

@end

@implementation SharingPolicyController
@synthesize delegate;
@synthesize policy;
@synthesize allPoliciesArr;
@synthesize totalAmount;

#pragma mark - PUBLIC METHODS

-(void) preselectPolicy:(NSString*)_policy{

	selectedPolicy = [[NSString alloc]initWithFormat:@"%@",_policy];
    
}


#pragma mark - PRESET POLICIES

-(void) initPolicySettings{
    
    totalFixedAmount = 0;
    totalPercentage = 0;
    remainingPercentage = 100;
    remainingTotalAmount = totalAmount;
    for (Policy *p in allPoliciesArr) {
        
        if (![p.user.uid isEqualToNumber:policy.user.uid]) {
            if (p.type == SPTypeFixedAmount) {
                totalFixedAmount += p.share;
            }
            else if (p.type == SPTypeFixedPercentage){
                totalPercentage = totalPercentage + p.fixedPercentage;
            }
        }
    }

    remainingPercentage = remainingPercentage - totalPercentage;
    remainingTotalAmount = remainingTotalAmount - totalFixedAmount;
    previousPolicyType = policy.type;
}

#pragma mark- XCODE STANDARD METHODS

-(void) initContent{
    policyArr = [[NSArray alloc]initWithObjects:
                 @"Not Included",
                 @"Zero Share",
                 @"Equal Share",
                 @"+1 Guest",
                 @"+2 Guest",
                 @"+3 Guest",
                 @"Fixed Amount",
                 @"Fixed Percentage", nil];
    
    [_tableView reloadData];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    v.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:v];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initContent];
    [self initPolicySettings];

    
}

#pragma mark -


-(void) saveFixedPercentageWith:(double)fixedPercentage{

    policy.share = 0;
    policy.fixedPercentage = fixedPercentage;

}

-(void) getFixedPercentage{
    UITextField *_textField = [[UITextField alloc] init];
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView 
                                       promptWithTitle:@"Fixed Percentage" 
                                       message:@"" 
                                       textField:&_textField];
    
    
    [alert addButtonWithTitle:@"Save" block:^{
//        policy.fixedPercentage = [[_textField text]doubleValue];
//        policy.share      = 0;
        [self saveFixedPercentageWith:[[_textField text]doubleValue]];
        
        if ([delegate respondsToSelector:@selector(sharingPolicySelected:)]) {
            [delegate sharingPolicySelected:SPTypeFixedPercentage];                    
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
     NSLog(@"Policy share: %f \n fixedPercent: %f \n Amount: %f \n Type: %d \n ",policy.share,policy.fixedPercentage,policy.fixedPrice,policy.type);
        

    }];
    [alert setDestructiveButtonWithTitle:@"Cancel" block:^{
        policy.type = previousPolicyType;
        [_tableView reloadData];
    }];

    _textField.delegate = self;
    _textField.tag = kTagFixedPercentage;    
    [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
    [alert show];

}

-(void) getFixedAmount{
    
    UITextField *_textField = [[UITextField alloc] init];

    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView 
                                       promptWithTitle:@"Fixed Amount" 
                                       message:@"" 
                                       textField:&_textField];
    
    
    [alert addButtonWithTitle:@"Save" block:^{
        policy.fixedPrice = [[_textField text]doubleValue];
        policy.share      = 0;
        
        if ([delegate respondsToSelector:@selector(sharingPolicySelected:)]) {
            [delegate sharingPolicySelected:SPTypeFixedAmount];                    
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alert setDestructiveButtonWithTitle:@"Cancel" block:^{
        policy.type = previousPolicyType;
        [_tableView reloadData];        
    }];
    _textField.delegate = self;
    _textField.tag = kTagFixedAmount;
    [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
    [alert show];
    
}

#pragma mark - CALL BACK DELEGATE METHODS 


-(void) saveNewSettings{
    if ([delegate respondsToSelector:@selector(sharingPolicySelected:)]) {
        [delegate sharingPolicySelected:policy.type];                    
    }
    [self closeSharingPolicy:nil];
}


- (IBAction)closeSharingPolicy:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - TABLEVIEW DATASOURCE & DELEGATES


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView : (UITableView *)tableView numberOfRowsInSection : (NSInteger)section{
	int numberOfRows  = 0;	
	
	if (policyArr.count){
        
		numberOfRows = policyArr.count;
	}	
	
	return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat height=44.0;
	return  height; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	UITableViewCell *cell=nil;
	NSString *identifier = @"Description";
	cell = [tableView cellForRowAtIndexPath:indexPath];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	
    if (policy.type == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[cell.textLabel setText:[policyArr objectAtIndex:indexPath.row]];	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    [policy setType:indexPath.row];
	
    if (selectedPolicy) {
		selectedPolicy = nil;
	}
	selectedPolicy = [[NSString alloc]initWithFormat:@"%@",[policyArr objectAtIndex:indexPath.row]];
	[tableView reloadData];
    
    if ([policyArr indexOfObject:selectedPolicy] == SPTypeFixedAmount) {
        [self getFixedAmount];
    }
    else if ([policyArr indexOfObject:selectedPolicy] == SPTypeFixedPercentage){
        [self getFixedPercentage];
    }
    else {
        [self saveNewSettings];
    }

	
}

#pragma mark - TEXT FIELD DELEGATES

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == kTagFixedPercentage) {
        NSLog(@"substring,remainingPercentage %@ , %f",substring,remainingPercentage);
        if ([substring doubleValue]>remainingPercentage) {
            return NO;
        }
    }
    else if (textField.tag == kTagFixedAmount){
        NSLog(@"substring,remainingTotalAmount %@ , %f",substring,remainingTotalAmount);
        if ([substring doubleValue]>remainingTotalAmount) {
            return NO;
        }
    }
    
    
    return YES;
}

@end
