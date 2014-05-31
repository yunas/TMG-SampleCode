//
//  DropDownController.m
//  IOTab
//
//  Created by Yunas Qazi on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropDownController.h"

@interface DropDownController ()

@end

@implementation DropDownController
@synthesize dataArr,actionSheet,delegate;

#pragma mark - 

-(IBAction)dismissActionSheet :(UIBarButtonItem *)btn{
    if (btn.tag == 0) {
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    else{
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
		if(dataArr.count)
        {
            if (delegate) {
                if ([delegate respondsToSelector:@selector(itemSelectedWithText:atIndex:)]) {
                    [delegate itemSelectedWithText:
                     [dataArr  objectAtIndex:[_picker selectedRowInComponent:0]] 
                                           atIndex:[_picker selectedRowInComponent:0]];
                }
            }
            
        }
//		[save what ever]	
    }
//	[self dealloc];
}


-(void) setPickerSelectedValue{
			NSLog(@"%@",selectedOption);
	if (selectedOption.length) {
		for (int i = 0 ; i < dataArr.count; i++) {
			NSString *optionVal = [dataArr objectAtIndex:i];
			NSLog(@"%@",optionVal);
			if ([optionVal isEqualToString:selectedOption] ) {
				[_picker selectRow:i inComponent:0 animated:YES];
				break;
			}
		}
	}
}

-(void) setSelectedText:(NSString *)selectedStr{
	selectedOption = [[NSString alloc]initWithFormat:@"%@",selectedStr];
	NSLog(@"%@",selectedOption);
}

-(void) presentDropDownInView :(UIView *)parentView{

	actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
											  delegate:self
									 cancelButtonTitle:nil
								destructiveButtonTitle:nil
									 otherButtonTitles:nil];
	
	[actionSheet addSubview:self.view];
	[actionSheet showInView:parentView];
	[actionSheet setFrame:CGRectMake(0, parentView.frame.size.height-self.view.frame.size.height,320, self.view.frame.size.height)];
	[self setPickerSelectedValue];	
}


#pragma mark - XCODE STANDARD METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)dealloc
//{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    [super dealloc];
//}

#pragma mark Picker Data Source Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView1
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (dataArr) {
		return dataArr.count;
	}
	return 0;
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[dataArr objectAtIndex:row]];
}


@end
