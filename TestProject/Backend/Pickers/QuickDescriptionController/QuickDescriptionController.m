//
//  QuickDescriptionController.m
//  IOTab
//
//  Created by Yunas Qazi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickDescriptionController.h"

@interface QuickDescriptionController ()

@end

@implementation QuickDescriptionController
@synthesize delegate;

#pragma mark - PUBLIC METHODS

-(void) preselectDescription:(NSString*)description{
	selectedDescription = [[NSString alloc]initWithFormat:@"%@",description];
}

#pragma mark- XCODE STANDARD METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}

-(void) initContent{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    v.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:v];

    descriptorsArr = [[NSArray alloc]initWithObjects:
                      @"Lunch",
                      @"Dinner",
                      @"Movie",
                      @"Gas",
                      @"Lodging", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initContent];
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


#pragma mark - CALL BACK DELEGATE METHODS 
- (IBAction)closeQuickDescription:(id)sender {
	UIBarItem *item = (UIBarItem *)sender;
	if (item.tag) {
		if (selectedDescription.length) {
			if ([delegate respondsToSelector:@selector(descriptionSelected:)]) {
				[delegate descriptionSelected:selectedDescription];
			}
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - TABLEVIEW DATASOURCE & DELEGATES


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView : (UITableView *)tableView numberOfRowsInSection : (NSInteger)section{
	int numberOfRows  = 0;	
	
	if (descriptorsArr.count){

		numberOfRows = descriptorsArr.count;
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
	
	if ([selectedDescription isEqualToString:[descriptorsArr objectAtIndex:indexPath.row]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[cell.textLabel setText:[descriptorsArr objectAtIndex:indexPath.row]];	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
//	if (selectedDescription) {
//		[selectedDescription release];
//	}
//	selectedDescription = [[NSString alloc]initWithFormat:@"%@",[descriptorsArr objectAtIndex:indexPath.row]];
//	[tableView reloadData];

    if ([delegate respondsToSelector:@selector(descriptionSelected:andTextId:)]) {
        [delegate descriptionSelected:[descriptorsArr objectAtIndex:indexPath.row] andTextId:indexPath.row+1];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    

	
}


@end
