//
//  RewardActivity.m
//
//

#import "RewardActivity.h"
#import "RewardClaim.h"
#import "Activity.h"
#import "MainAppDelegate.h"
#import "User.h"
#import "MainLogin.h"

@implementation RewardActivity
@synthesize activityBtn;
@synthesize claimedBtn;
@synthesize activityTable, pointsLabel;

-(id) initWithDataArray:(NSMutableArray *)array totalPoint: (NSString *) totalPoint
{
    self = [super init];
    activityArray = [array mutableCopy];
    mainArray = [activityArray mutableCopy];
    NSLog(@" rewards array count is  : %d", [mainArray count]);
    totPoints = [totalPoint retain];
    NSLog(@" the   : %@",totalPoint);
    return self;
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(IBAction) backButtonAction{
    
    appDelegate.checkScreen = FALSE;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction) rewardClaimAction{
    RewardClaim *claim =[[RewardClaim alloc] init];
    [self.navigationController pushViewController:claim animated:YES];
    [claim release];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    Activity *activity;
    NSString *rid;
    if (indexPath.row < [mainArray count]) {
        activity = [mainArray objectAtIndex:indexPath.row];
        rid = [NSString stringWithFormat:@"cell%@",activity.receiptSubmitId];
    }else{
        rid=@"Identifier";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 25)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor orangeColor]];
        [label setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:13]];
        [label setTextColor:[Utils colorWithHexString:@"333333"]];
        
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 25)];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:13]];
        [label2 setTextColor:[Utils colorWithHexString:@"231f20"]];
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(195, 5, 80, 25)];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setTextColor:[Utils colorWithHexString:@"333333"]];
        label1.textAlignment=UITextAlignmentRight;
        label1.font=[UIFont fontWithName:@"RobotoCondensed-Regular" size:13];
        
        UIImageView *bgPic = [[[UIImageView alloc] initWithFrame:CGRectMake(15,40,270,1)]autorelease];
        bgPic.backgroundColor = [UIColor clearColor];
        [bgPic setImage:[UIImage imageNamed:@"line-info.png"]];
        
        NSString *dateStr=[NSString stringWithFormat:@"%@",activity.submitDate];
        
        if (![dateStr isEqualToString:@""]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            int sep = [dateStr rangeOfString:@"T"].location;
            dateStr = [dateStr substringToIndex:sep];
            NSLog(@"converted string character inddex is : %@" , dateStr);
            NSDate *date = [dateFormatter dateFromString:dateStr];
            [dateFormatter setDateFormat:@"MMM dd, yyy"];
            [label setText:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]]];
            if(checkRew == TRUE){
                [label2 setText:[NSString stringWithFormat:@"- %@",activity.receiptStatus]];
            }
            
            [cell.contentView addSubview:label2];
            
            [dateFormatter release];
        }else {
            [label setText:@""];
        }
        
        
        [cell.contentView addSubview:label];
        
        [label1 setFrame:CGRectMake(223, 6,60, 25)];
        [label1 setText:[NSString stringWithFormat:@"Purchase"]];

        [cell.contentView addSubview:bgPic];
        [label release];
        if(activityBtn.selected)
            [cell.contentView addSubview:label1];
        [label1 release];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"am"];
    [formatter setPMSymbol:@"pm"];
    [formatter setDateFormat:@"HH:mm a"];
    [formatter release];
    
    checkRew = FALSE;
    
    appDelegate=(MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkScreen = TRUE;
    
    [self resetAllButtonWithCurrentButton:activityBtn];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark -
#pragma mark  Restet all Buttons
-(void)resetAllButtonWithCurrentButton:(UIButton *)currentButton
{
    activityBtn.selected = NO;
    claimedBtn.selected = NO;
    currentButton.selected = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *signUp=[[MainLogin alloc] init];
        [self.navigationController pushViewController:signUp animated:NO];
        [signUp release];
    }else{
        [self activityWebCalled];
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setActivityBtn:nil];
    [self setClaimedBtn:nil];
    [titlePage release];
    titlePage = nil;
    [timelbl release];
    timelbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [activityBtn release];
    [claimedBtn release];
    [titlePage release];
    [timelbl release];
    [super dealloc];
}

#pragma mark -
#pragma mark Claimed Button Clicked
- (IBAction)ClaimedButtonClicked:(UIButton *)sender {
    checkRew = TRUE;
    [self resetAllButtonWithCurrentButton:claimedBtn];
    
    if([claimedArray count] <= 0) {
        
        [self activityViewCalled];
        
    }
    
    [mainArray removeAllObjects];
    mainArray = [claimedArray mutableCopy];
    [activityTable reloadData];
    
    
}
-(void) activityViewCalled {
    
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    //else
    //  autToken = @"";
    rsquestCount = 1;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kGetRewardsActivityRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kGetRewardsActivityRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    indicatorView.hidden = YES;
    NSLog(@"Rewards returnString = %@",returnString);
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            
        }else{
            if(rsquestCount == 3) {
                
                if ([returnString isEqualToString:@"401"]) {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else {
                    
                    //                    NSDictionary *response= [returnString JSONValue];
                    
                    NSDictionary *response =  [NSJSONSerialization JSONObjectWithData: [returnString dataUsingEncoding:NSUTF8StringEncoding]
                                                                              options: NSJSONReadingMutableContainers
                                                                                error: nil];
                    
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    
                    if (status){
                        //   NSLog(@"Response coming here is ::::: %@ ", [returnString JSONValue] );
                        NSMutableArray *receiptArray = [response objectForKey:@"receipts"];
                        [activityArray removeAllObjects];
                        if(activityArray)
                        {
                            [activityArray release];
                            activityArray = nil;
                        }
                        activityArray = [[NSMutableArray alloc] init];
                        for(int i = 0 ; i < [receiptArray count] ; i++){
                            
                            Activity *activity = [[Activity alloc] init];
                             NSDictionary *receiptDict= [receiptArray objectAtIndex:i];
                             activity.receiptSubmitId = [receiptDict objectForKey:@"id"];
                             receiptDict = [receiptDict objectForKey:@"last_transaction"];
                             
                             activity.pointsEarned = [receiptDict objectForKey:@"total_points_earned"]==[NSNull null]?@"":[receiptDict objectForKey:@"total_points_earned"];
                             
                             activity.receiptStatus = [receiptDict objectForKey:@"status"]==[NSNull null]?@"":[receiptDict objectForKey:@"status"];
                             
                             activity.submitDate = [receiptDict objectForKey:@"created_at"]==[NSNull null]?@"":[receiptDict objectForKey:@"created_at"];
                             
                             [activityArray addObject:activity];
                             [activity release];
                            
                          
                            
                        }
                        
                        [mainArray removeAllObjects];
                        mainArray = [activityArray mutableCopy];
                        
                        [activityTable reloadData];
                    }else{
                        NSString *msg = [response objectForKey:@"notice"];
                        if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                            msg = [response objectForKey:@"message"];
                        
                        if([msg length] == 0)
                            msg = SOMETHING_WENT_WRONG;
                        
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                            [alert dismissWithClickedButtonIndex:0 animated:NO];
                        }];
                        [alert release];
                    }
                }
            }
            
            else  if(rsquestCount == 1) {
                if ([returnString isEqualToString:@"401"]) {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else{
                    
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    if (status){
                        
                        //  NSLog(@"Response coming here is ::::: %@ ", [returnString JSONValue] );
                        NSMutableArray *receiptArray = [response objectForKey:@"activities"];
                        [claimedArray removeAllObjects];
                        claimedArray = [[NSMutableArray alloc] init];
                        for(int i = 0 ; i < [receiptArray count] ; i++){
                            Activity *activity = [[Activity alloc] init];
                            // NSLog(@"inside the main loop for resturanrts...");
                            NSDictionary *receiptDict= [receiptArray objectAtIndex:i];
                            if([receiptDict objectForKey:@"reward"]!=[NSNull null])
                            {
                                activity.pointsEarned = [[receiptDict objectForKey:@"reward"] objectForKey:@"points"]==[NSNull null]?@"":[[receiptDict objectForKey:@"reward"] objectForKey:@"points"];
                                
                                activity.receiptStatus = [[receiptDict objectForKey:@"reward"] objectForKey:@"name"]==[NSNull null]?@"":[[receiptDict objectForKey:@"reward"] objectForKey:@"name"];
                                
                                activity.submitDate = [receiptDict objectForKey:@"claim_date"]==[NSNull null]?@"":[receiptDict objectForKey:@"claim_date"];
                                
                                [claimedArray addObject:activity];
                                [activity release];
                            }
                        }
                        
                        [mainArray removeAllObjects];
                        mainArray = [claimedArray mutableCopy];
                        [activityTable reloadData];
                    }else{
                        NSString *msg = [response objectForKey:@"notice"];
                        if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                            msg = [response objectForKey:@"message"];
                        
                        if([msg length] == 0)
                            msg = SOMETHING_WENT_WRONG;
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                            [alert dismissWithClickedButtonIndex:0 animated:NO];
                        }];
                        [alert release];
                        
                    }
                }
            }
        }
    }
    else{
        
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
    }
    
    
}

- (void) requestError:(NSString * )returnString {
    
    //  NSLog(@"response coming with error %@" , returnString);
    indicatorView.hidden = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
    
}
- (void) requestNetworkError {
    
    indicatorView.hidden = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

#pragma mark -
#pragma mark Activity Button Clicked
- (IBAction)ActivityButtonClicked:(UIButton *)sender {
    checkRew = FALSE;
    [self resetAllButtonWithCurrentButton:activityBtn];
    [lblTitle setText:NSLocalizedString(@"Reward Activity Title", @"Reward")];
    
    if([activityArray count] <= 0)
    {
        [self activityWebCalled];
    }
    [mainArray removeAllObjects];
    mainArray = [activityArray mutableCopy];
    [activityTable reloadData];
}

-(void) activityWebCalled {
    
    indicatorView.hidden = NO;
    [indicatorView startAnimating];
    rsquestCount = 3;
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    //else
    //  autToken = @"";
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kGetUserActivityRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kGetUserActivityRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}


-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex ==0){
        [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
        MainLogin *login = [[MainLogin alloc] init];
        [self.navigationController pushViewController:login animated:NO];
        [login release];
    }
}

@end
