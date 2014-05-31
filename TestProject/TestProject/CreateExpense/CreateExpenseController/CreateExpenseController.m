	//
//  CreateExpenseController.m
//  IOTab
//
//  Created by Yunas Qazi on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateExpenseController.h"

#import "DateUtility.h"

#import "CreateExpenseTableCell.h"
#import "CreateExpenseFeaturedCell.h"
#import "CreateExpensePayeeCell.h"
#import "CreatePayeeFeaturedCell.h"

#import "IOUser.h"
#import "Policy.h"
#import "Currency.h"
#import "CurrencyService.h"

#import "PolicyConstants.h"
#import "IOUserService.h"
#import "UIColor+CustomColor.h"



@interface CreateExpenseController ()

@end

@implementation CreateExpenseController
@synthesize groupId;
@synthesize delegate;




#pragma mark - CUSTOM INIT

-(NSString *) getCurrencyConversions{
    
    
    NSNumber *expCid = [curConverter getCurrencyId];
    if(expCid){
    headerHeight = 0;
    NSString *headerTitle = [[NSString alloc]initWithFormat:@""];
    NSMutableDictionary *conversionDict = [NSMutableDictionary new];
    
    
        double rate =  1;//[CurrencyService getCurrencyRateFor:grp.currency.cid againstCurrency:expCid];
        NSString *rateStr = [NSString stringWithFormat:@" x %.4f = %.2f \n",rate,[[curConverter getAmountEntered]doubleValue] * rate];

        if (rate != 1) {
            if (expCid) {
                [conversionDict setValue:rateStr forKey:[expCid stringValue]];
            }

        }

    headerHeight = 20 *conversionDict.count;
    NSArray *allKeys = [conversionDict allKeys];
    for (NSString *key in allKeys) {
        headerTitle = [headerTitle stringByAppendingFormat:@"%@",[conversionDict objectForKey:key]];
    }
    
    return headerTitle;
    }else
        return @"";
}

-(void) addCurrencyPicker{
    
	curConverter = [CurrencyConverter new];
    [curConverter setDelegate:self];
    Currency *defaultCur = [CurrencyService getDefaultCurrency];
    [curConverter setCurrencyForGroup:defaultCur];
	[_selectorView addSubview:curConverter.view];
	
	CGRect _frame = CGRectMake(0, 90, 320, 35);
	[curConverter.view setFrame:_frame];
	[curConverter.view setCenter:CGPointMake(self.view.center.x, curConverter.view.center.y)];
	[curConverter setParentView:self.view];
	
}


-(void) initContentView{

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    v.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:v];
    
    //UISTUFF
    [self addCurrencyPicker];

    
}

-(void)setPolicyForContributors
{
    
    double totalAmount = [((NSString*)[curConverter getAmountEntered]) doubleValue];
    float individualShare = totalAmount/contributorsArr.count ;
    
    for (IOUser *user in contributorsArr) {
        Policy *p = [Policy new];
        
        [p setIsMember:YES];
        [p setUser:user];
        [p setShare:individualShare];
        [p setFeaturedShare:individualShare];
        [p setFixedPrice:0];
        [p setType:SPTypeEqaulShare];
        [p.user setCurrency:[CurrencyService getDefaultCurrency]];
        [policyArr addObject:p];
    }

    policyContributorCount = contributorsArr.count;


}

-(void) setMembersOrder{

    
        if (contributorsArr) {
            [contributorsArr removeAllObjects];
            contributorsArr = nil;
        }
        IOUserService *service = [IOUserService new];
        [service getAllUsersWithSuccess:^(NSArray *usersArr) {
          contributorsArr = [[NSMutableArray alloc]initWithArray:usersArr];
        } andError:^(NSError *error) {
            
        }];

        if (policyArr) {
            [policyArr removeAllObjects];
            policyArr = nil;
        }
        
        policyArr = [NSMutableArray new];
        
        [self setPolicyForContributors];
        [_tableView reloadData];
    
}
-(void) initContent{

    payeeMemberId = @1;
    headerHeight = 0;
    
	[self initContentView];
//WEB-STUFF
    
    [self setMembersOrder];
    [self getCurrencyConversions];
}

#pragma mark - XCODE STANDARD METHODS

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContent];
}

#pragma mark - ACTIONS

- (IBAction)quickDescriprtion:(id)sender {
    [_tfDescription resignFirstResponder];
    [self performSegueWithIdentifier:@"quickDescription" sender:self];
}


#pragma mark - QUICK DESCRIPTION DELEGATES
-(void) descriptionSelected:(NSString *)description
                  andTextId:(NSUInteger)_textId{
	
    [_tfDescription setText:description];
    
}


#pragma mark - TEXTFIELD DELEGATES

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - SHARING POLICY DELEGATES


-(double) getPreciseValue :(double)val{

    NSNumber *number = [NSNumber numberWithFloat: val];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setMaximumFractionDigits:2];
    
    return [[formatter stringFromNumber:number] doubleValue];
}

-(void)refreshWithRule1:(double)totalAmount{
    //Rule 1

//=====> CALCULATE Total Number of Policy Contributors
    
    policyContributorCount = 0;
    double totalContributionAmount = 0;
    for (Policy *policy in policyArr) {
        
        if (policy.type == SPTypeEqaulShare){
            policyContributorCount +=1;
        }
        else if (policy.type == SPType1Guest){
            policyContributorCount +=2;
        }
        else if (policy.type == SPType2Guest){
            policyContributorCount +=3;
        }
        else if (policy.type == SPType3Guest){
            policyContributorCount +=4;
        }
        else if (policy.type == SPTypeFixedAmount){
            totalAmount = totalAmount - [self getPreciseValue:policy.fixedPrice];
        }
    }    

    
    //SPECIAL CHECK

    float totalFixedPercentageAmount = 0;
    for (Policy *policy in policyArr) {
        if (policy.type == SPTypeFixedPercentage){
            policy.share =  totalAmount*((policy.fixedPercentage)/100.0);            
            totalFixedPercentageAmount += [self getPreciseValue:policy.share];
        }
    }    

    totalAmount = totalAmount - totalFixedPercentageAmount;

    float individualShare;
    @try {
            individualShare = totalAmount/policyContributorCount;

    }
    @catch (NSException *exception) {
        individualShare = totalAmount;
    }
    @finally {
   //     individualShare = totalAmount;
    }


    
    for (Policy *policy in policyArr) {
        
        if (policy.type == SPTypeNotIncluded) {
            policy.share = 0;
        }
        else if (policy.type == SPTypeZeroShare){
            policy.share = 0;
        }
        else if (policy.type == SPTypeEqaulShare){
            policy.share = [self getPreciseValue:individualShare];
        }
        else if (policy.type == SPType1Guest){
            policy.share = [self getPreciseValue:individualShare*2];
        }
        else if (policy.type == SPType2Guest){
            policy.share = [self getPreciseValue:individualShare*3];
        }
        else if (policy.type == SPType3Guest){
            policy.share = [self getPreciseValue:individualShare*4];
        }
        else if (policy.type == SPTypeFixedAmount){
            policy.share = [self getPreciseValue:policy.fixedPrice];
        }
        else if (policy.type == SPTypeFixedPercentage){
            //            policy.share = individualShare*((policy.fixedPercentage)/100.0);
        }
        
            totalContributionAmount += [self getPreciseValue:(policy.share)];
    }
    
}


-(void) refreshPolicy:(NSString *)amount{

    double totalAmount = 0;
    
    if (amount) {
        totalAmount = [amount doubleValue];
    }
    else {
        totalAmount  = [((NSString*)[curConverter getAmountEntered]) doubleValue];        
    }
    
    //====> RULE 1 => precedence of Fixed Price is more than fixed percentage (3 loops)
    [self refreshWithRule1:totalAmount];
    
}

-(void) sharingPolicySelected:(SPType )policyType{
    
    
    
    if (policyType == SPType1Guest) {
        policyContributorCount +=1;
    }
    else if (policyType == SPType2Guest){
        policyContributorCount +=2;
    }
    else if (policyType == SPType3Guest){
        policyContributorCount +=3;
    }
    else if ((policyType == SPTypeZeroShare) ||
             (policyType == SPTypeNotIncluded)||
             (policyType == SPTypeFixedAmount)||
             (policyType == SPTypeFixedPercentage)){
    
        policyContributorCount -=1;
    }
    
    [self refreshPolicy:nil];
    [_tableView reloadData];   

    
}



#pragma mark - TABLEVIEW ACTIONS
-(void) payeeSelected:(UIButton*)btn{
    
    IOUser *user = [contributorsArr objectAtIndex:btn.tag];
    
    if (payeeMemberId) {
        payeeMemberId = nil;
    }
    
    payeeMemberId = user.uid;
    [_tableView reloadData];
    
}


#pragma mark - Segue Stuff
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"quickDescription"]) {
        QuickDescriptionController* quickDescController = (QuickDescriptionController*)[segue destinationViewController];
        [quickDescController setDelegate:self];
        [quickDescController preselectDescription:[_tfDescription text]];

    }
    else if ([[segue identifier] isEqualToString:@"sharePolicy"]) {
        
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        SharingPolicyController *policyController = (SharingPolicyController*)[segue destinationViewController];
        [policyController setDelegate:self];
        [policyController preselectPolicy:[_tfDescription text]];
        [policyController setPolicy:[policyArr objectAtIndex:indexPath.row]];
        [policyController setAllPoliciesArr:policyArr];
        [policyController setTotalAmount:[[curConverter getAmountEntered]doubleValue]];

    }
}

#pragma mark - TABLEVIEW CUSTOM MODIFICATIONS

-(UITableViewCell *) cellExpensePayeeForIndexPath:(NSIndexPath *)indexPath{
	
    NSString *identifier		= @"CreateExpensePayeeCell";
    
    UITableViewCell *genericCell = nil;
    
    Policy *p = [policyArr objectAtIndex:indexPath.row];
    if ((p.type == SPType1Guest) ||
        (p.type == SPType2Guest) ||
        (p.type == SPType3Guest) || 
        (p.type == SPTypeFixedPercentage)) {
        
        identifier		= @"CreatePayeeFeaturedCell";
        CreatePayeeFeaturedCell * cell;
        cell = (CreatePayeeFeaturedCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
        
        if(cell == nil)
        {    
            NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"CreatePayeeFeaturedCell" owner:nil options:nil];
            for(id currObject in nibObjects)
            {
                if([currObject isKindOfClass:[CreatePayeeFeaturedCell class]])
                {
                    cell = (CreatePayeeFeaturedCell *)currObject;
                    
                }
            }
            [cell applyFormatting];
            [cell._btn addTarget:self action:@selector(payeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        }	
        genericCell = cell;
    }
    else {
        
        CreateExpensePayeeCell * cell;
        cell = (CreateExpensePayeeCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
        
        if(cell == nil)
        {    
            NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"CreateExpensePayeeCell" owner:nil options:nil];
            for(id currObject in nibObjects)
            {
                if([currObject isKindOfClass:[CreateExpensePayeeCell class]])
                {
                    cell = (CreateExpensePayeeCell *)currObject;
                    
                }
            }
            [cell applyFormatting];
            //SET ACTIONS    
            [cell._btn addTarget:self action:@selector(payeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        }	
        genericCell = cell;
        
    }
	return genericCell;
}

-(UITableViewCell *) cellExpenseForIndexPath:(NSIndexPath *)indexPath{
	
    NSString *identifier		= @"CreateExpenseTableCell";
    
    UITableViewCell *genericCell = nil;
    
    Policy *p = [policyArr objectAtIndex:indexPath.row];
    if ((p.type == SPType1Guest) ||
        (p.type == SPType2Guest) ||
        (p.type == SPType3Guest)){
        
        identifier		= @"CreateExpenseFeaturedCell";
        CreateExpenseFeaturedCell * cell = (CreateExpenseFeaturedCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {    
            NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"CreateExpenseFeaturedCell" owner:nil options:nil];
            for(id currObject in nibObjects)
            {
                if([currObject isKindOfClass:[CreateExpenseFeaturedCell class]])
                {
                    cell = (CreateExpenseFeaturedCell *)currObject;
                }
            }
            [cell applyFormatting];
            //SET ACTIONS    
            [cell._btn addTarget:self action:@selector(payeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        }	
        
        genericCell = cell;
        
    }
    
    else {
        
        CreateExpenseTableCell * cell = (CreateExpenseTableCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {    
            NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"CreateExpenseTableCell" owner:nil options:nil];
            for(id currObject in nibObjects)
            {
                if([currObject isKindOfClass:[CreateExpenseTableCell class]])
                {
                    cell = (CreateExpenseTableCell *)currObject;
                }
            }
            [cell applyFormatting];
            [cell._btn addTarget:self action:@selector(payeeSelected:) forControlEvents:UIControlEventTouchUpInside];
        }	
        genericCell = cell;
    }
    

	return genericCell;
}

#pragma mark - TABLEVIEW DATASOURCE & DELEGATES

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if(!selectedCurrency)
        selectedCurrency = [curConverter selectedCurrency];

    return 2;
}

-(NSInteger)tableView : (UITableView *)tableView numberOfRowsInSection : (NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
	int numberOfRows  = 0;	
	if (contributorsArr.count != 0) {
		numberOfRows = contributorsArr.count;
	}
	return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0){
        return headerHeight;
    }
    
    CGFloat height=70.0;
    if(policyArr.count){
	Policy *p  = [policyArr objectAtIndex:indexPath.row];
    if ((p.type == SPType1Guest) ||
        (p.type == SPType2Guest) ||
        (p.type == SPType3Guest) || 
        (p.type == SPTypeFixedPercentage)) {
        IOUser *user = [contributorsArr objectAtIndex:indexPath.row];    
        if ([user.uid isEqualToNumber:payeeMemberId]) {
            height = 90.0;
        }
    }
    }
	return  height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell=nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ConversionView"];   
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConversionView"];
            [cell.textLabel setNumberOfLines:0];
            [cell.textLabel setFont:[UIFont fontWithName:@"System" size:11.0]];
        }
        [cell.textLabel setTextAlignment: NSTextAlignmentRight];
        [cell.textLabel setText:[self getCurrencyConversions]];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    
    UITableViewCell *cell=nil;
	IOUser *user = [contributorsArr objectAtIndex:indexPath.row];

    //==== GET  CELL
    if (payeeMemberId) {
        if ([user.uid isEqualToNumber:payeeMemberId]) {
            
            cell = [self cellExpensePayeeForIndexPath:indexPath];
        }
        else {
            
            cell = [self cellExpenseForIndexPath:indexPath];
        }

    }
    else{
        cell = [self cellExpenseForIndexPath:indexPath];
    }

//====SET DATA TO CELL
    double totalAmount = [((NSString*)[curConverter getAmountEntered]) doubleValue];
    
    if (payeeMemberId) {
        if ([user.uid isEqualToNumber:payeeMemberId]) {
            
            if ([cell isKindOfClass:[CreateExpensePayeeCell class]]) {
                
                [(CreateExpensePayeeCell*)cell setExpensePayeeCellWith:user
                                                                 share:[policyArr objectAtIndex:indexPath.row]
                                                               andPaid:[NSNumber numberWithDouble:totalAmount]
                                                          withCurrency:selectedCurrency
                                                           atIndexPath:indexPath];
            }
            else {
                [(CreatePayeeFeaturedCell*)cell setExpensePayeeCellWith:user
                                                                  share:[policyArr objectAtIndex:indexPath.row]
                                                                andPaid:[NSNumber numberWithDouble:totalAmount]
                                                           withCurrency:selectedCurrency
                                                            atIndexPath:indexPath];
            }
        }
        else {
            
            if ([cell isKindOfClass:[CreateExpenseTableCell class]]) {
                [(CreateExpenseTableCell*)cell setExpenseCellWith:user
                                                            share:[policyArr objectAtIndex:indexPath.row]
                                                     withCurrency:selectedCurrency
                                                      atIndexPath:indexPath];
                
            }
            else {
                [(CreateExpenseFeaturedCell*)cell setExpenseCellWith:user
                                                               share:[policyArr objectAtIndex:indexPath.row]
                                                        withCurrency:selectedCurrency
                                                         atIndexPath:indexPath];	
            }
            
        }
        
    }
    else {
        
        if ([cell isKindOfClass:[CreateExpenseTableCell class]]) {
            [(CreateExpenseTableCell*)cell setExpenseCellWith:user
                                                        share:[policyArr objectAtIndex:indexPath.row]
                                                 withCurrency:selectedCurrency
                                                  atIndexPath:indexPath];
            
        }
        else {
            [(CreateExpenseFeaturedCell*)cell setExpenseCellWith:user
                                                           share:[policyArr objectAtIndex:indexPath.row]
                                                    withCurrency:selectedCurrency
                                                     atIndexPath:indexPath];
        }
        
    }
    
    [cell.contentView setBackgroundColor:[UIColor lightGreenColor]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self performSegueWithIdentifier:@"sharePolicy" sender:self];
}

#pragma mark - CURRENCY CONVERTER DELEGATES
-(void)currencyChanged:(NSNumber *)currencyId{
    
    [self getCurrencyConversions];
     selectedCurrency = [curConverter selectedCurrency];
    [_tableView reloadData];
}

-(void)AmountChanged:(NSString *)amount{
    
    [self refreshPolicy:amount];
    [_tableView reloadData];
}

@end