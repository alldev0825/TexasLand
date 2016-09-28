//
//  RewardMain.m
//
//

#import "RewardMain.h"
#import "RewardActivity.h"
#import "MainAppDelegate.h"
#import "User.h"
#import "Reward.h"
#import "RewardClaim.h"
#import "Activity.h"
#import "LocationLogin.h"
#import "LocationSignUp.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "LocationLogin.h"
#import "MainLogin.h"
//#import "GAI.h"
//#import "GAIFields.h"
//#import "GAIDictionaryBuilder.h"
#import "ReferAFriend.h"
#import "HomeScreenViewC.h"
#import "NKDBarcodeFramework.h"


@implementation RewardMain

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)backBtnAction:(id)sender {
    appDelegate.checkPay = TRUE;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Activity Button Method
-(void) activityViewCalled {
    RewardActivity *activityView=[[RewardActivity alloc] init];
    [self.navigationController pushViewController:activityView animated:YES];
    [activityView release];
}

-(void)viewWillDisappear:(BOOL)animated{
    //        [UIScreen mainScreen].brightness = 0.6;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
    [rewardsTable reloadData];
    appDelegate.checkScreen = FALSE;
    [self.navigationController setNavigationBarHidden:YES];
    [self appWillEnterForegroundNotification];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    appDelegate=(MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkScreen = FALSE;
    
	expDelImage = [[UIImageView alloc] initWithFrame:CGRectMake(213, 15,75,35)];
    activityArray = [[NSMutableArray alloc] init ];
    userRewardsArray = [[NSMutableArray alloc] init ];
 
    
	reloadCounter = 0.00;

    if (self.navigationController.viewControllers.count == 2 && [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[HomeScreenViewC class]]) {
        backBtn.hidden = NO;
    }else{
        RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
        [tabBar initializeSliderView:self.view];
        backBtn.hidden = YES;
    }

    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark -
#pragma mark Application Back from Background
- (void) appWillEnterForegroundNotification{
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *signUp=[[MainLogin alloc] init];
        [self.navigationController pushViewController:signUp animated:NO];
        [signUp release];
        NSLog(@"UserId == -1 not making rewards request");
    }else {
		// Else case because if there is no userId or userId==-1
		// There is no need to send rewards request to server.
		reloadCounter+=0.01;
        [rewardsTable reloadData];
		[indicatorView startAnimating];
		[rewardsTable setHidden:YES];
        [self fetchRewardsList];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	[tableView setBackgroundColor:[UIColor clearColor]];
	[tableView setSeparatorColor:[UIColor clearColor]];
	return [userRewardsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Reward *reward;
	NSString *rid;
	if (indexPath.row < [userRewardsArray count]) {
		reward = [userRewardsArray objectAtIndex:indexPath.row];
		rid = [NSString stringWithFormat:@"cell%@%@%@%@%@%@%@%@%f",reward.rewardId,reward.rewardPoints,reward.rewardName,reward.rewardURL, reward.rewardExpired, reward.POSCode, [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"], reward.totalPoints,reloadCounter];
	}else{
		rid=@"Identifier";
	}
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
	[tableView setBackgroundColor:[UIColor clearColor]];
    
	if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		UIImageView *bgImage;
		bgImage = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 1, 295,50)];
        
        if ( ![reward.rewardExpired boolValue] && [reward.rewardPoints intValue] <= [reward.totalPoints intValue] ) {
            isActiveReward = YES;
            [bgImage setImage: [UIImage imageNamed:@"rewards-field.png"]];
        } else {
            isActiveReward = NO;
            [bgImage setImage: [UIImage imageNamed:@"rewards-field-inactive.png"]];
        }
        
		[cell.contentView addSubview:bgImage];
		[bgImage autorelease];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, -5, 190, 55)];
        [label setNumberOfLines:2];
        [label setFont:[UIFont fontWithName:@"UnitedSansCond-Bold" size:17]];
        
        
        UILabel *expired=[[UILabel alloc] initWithFrame:CGRectMake(30, 15, 145, 35)];
        [expired setBackgroundColor:[UIColor clearColor]];
        expired.textAlignment=UITextAlignmentLeft;
        [expired setFont:[UIFont fontWithName:@"UnitedSansCond-Medium" size:12]];
        
        [label setText:reward.rewardName];
        
        NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
        [rfc3339TimestampFormatterWithTimeZone setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        
        [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *theDate = nil;
        NSError *error = nil;
        
        [rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:reward.expiryDate range:nil error:&error];
        [rfc3339TimestampFormatterWithTimeZone release];
        NSDateFormatter* userFormatter = [[NSDateFormatter alloc] init];
        [userFormatter setDateFormat:@"MM/dd/yy"];
        [userFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
        
        NSString *getDa = [userFormatter stringFromDate:theDate];
        
        [cell.contentView addSubview:label];
        
        if (isActiveReward) {
            [label setTextColor:[UIColor whiteColor]];
            [expired setTextColor: [Utils colorWithHexString:@"9b8c7a"]];
            
            if ([reward.rewardPoints intValue] !=0 ) {
                [label setFrame:CGRectMake(30, -1, 190, 55)];
            }else{
                NSUInteger length = [label.text length];
                
                if(length >= 24)
                    [expired setFrame:CGRectMake(30, 23, 145, 35)];
                else
                    [expired setFrame:CGRectMake(30, 20, 145, 35)];
                [expired setText:[NSString stringWithFormat:@"Expires %@",getDa]];
            }
            [cell.contentView addSubview:expired];
        }else{
            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(170, -1, 190, 55)];
            [label1 setBackgroundColor:[UIColor clearColor]];
            
            label1.textAlignment=UITextAlignmentCenter;
            [label1 setFont:[UIFont fontWithName:@"UnitedSansCond-Medium" size:19]];
            
            [label setTextColor: [Utils colorWithHexString:@"9b8c7a"]];
            [label1 setTextColor: [Utils colorWithHexString:@"9b8c7a"]];
            
            if (![reward.rewardExpired boolValue] && [reward.rewardPoints intValue] > [reward.totalPoints intValue] ) {
                [label setFrame:CGRectMake(30, -1, 190, 55)];

			}else if([reward.rewardExpired boolValue]){
                [bgImage setImage: [UIImage imageNamed:@"rewards-field-inactive.png"]];
                label1.textAlignment=UITextAlignmentCenter;
                [label1 setFont:[UIFont fontWithName:@"UnitedSansCond-Bold" size:15]];
                [label1 setText:[NSString stringWithFormat:@"EXPIRED"]];
                label1.tag = 2;
                
                appDelegate.checklistReward = TRUE;
				[cell.contentView addSubview:label1];
            }
            [label1 release];
        }
        [label release];
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Reward *reward = [userRewardsArray objectAtIndex:indexPath.row];
    rewardIndex = indexPath.row;
    
    if( ![reward.rewardExpired boolValue] && [reward.rewardPoints intValue] <= [reward.totalPoints intValue] ) {
        
        RewardClaim *TorewardClaim=[[RewardClaim alloc] initWithReward:reward];
        
        [self.navigationController pushViewController:TorewardClaim animated:NO];
        
    }else if([reward.rewardExpired boolValue]){
        
        UITableViewCell *cell =(UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        UILabel *exp = (UILabel *)[cell viewWithTag:2];
        
        NSLog(@"========= test %@", exp );
        
        if([exp.text isEqualToString:@"EXPIRED"]){
            [exp setText:[NSString stringWithFormat:@"DELETE"]];
        }else{
            [indicatorView startAnimating];
            [self deleteRewardCall:reward];
        }
    }
}

//Delete Expired reward
-(void) deleteRewardCall:(Reward *)reward {
    
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    else
        autToken = @"";
    rsquestCount = 2;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:reward.rewardId,@"rewardId", APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kDeleteRewardsRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kDeleteRewardsRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    
}

///////////////// Fetch Rewards //////////////////
#pragma mark -
#pragma mark Fetch Rewards List
-(void) fetchRewardsList {
    
    [indicatorView startAnimating];
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    else
        autToken = @"";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY hh:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    rsquestCount = 1;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",dateString,@"device_timestamp",[NSNumber numberWithInt:kGetRewardsRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kGetRewardsRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    // NSLog(@"Rewards returnString = %@",returnString);
    if( returnString!= nil && ![returnString isEqualToString:@""]){
		if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
			RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}else{
			if(rsquestCount == 1) {
                if ([returnString isEqualToString:@"401"]) {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    if (status){
                        
                        NSDictionary *balDict = [response objectForKey:@"balance"];
                        NSString * Points = [balDict objectForKey:@"points"];
                        
                        NSString *rewardNotification = [response objectForKey:@"new_reward_notification"];
                        
                        if(rewardNotification){
                            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:rewardNotification delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }
                        
                        NSMutableArray *rewardsArray = [response objectForKey:@"rewards"];
                        
                        [userRewardsArray removeAllObjects];
                        if(rewardsArray.count){
                            [userRewardsArray removeAllObjects];
                            NSDictionary *additional_fields;
                            
                            for(int i = 0 ; i < [rewardsArray count] ; i++){
                                NSDictionary *rewDict= [rewardsArray objectAtIndex:i];
                                Reward *reward = [[Reward alloc] init];
                                
                                additional_fields = [[rewardsArray objectAtIndex:i] objectForKey:@"additional_fields" ];
                                
                                reward.rewardId = [rewDict objectForKey:@"id"]==[NSNull null]?@"":[rewDict objectForKey:@"id"];
                                
                                reward.rewardName = [rewDict objectForKey:@"name"]==[NSNull null]?@"":[rewDict objectForKey:@"name"];
                                
                                reward.rewardURL = [rewDict objectForKey:@"image_url"]==[NSNull null]?@"":[rewDict objectForKey:@"image_url"];
                                
                                reward.rewardPoints = [rewDict objectForKey:@"points"]==[NSNull null]?@"":[rewDict objectForKey:@"points"];
                                
                                reward.POSCode = [rewDict objectForKey:@"POSCode"]==[NSNull null]?@"":[rewDict objectForKey:@"POSCode"];
                                
                                reward.rewardSurveyId = [rewDict objectForKey:@"survey_id"]==[NSNull null]?@"":[rewDict objectForKey:@"survey_id"];
                                
                                reward.chainId = [rewDict objectForKey:@"chain_id"]==[NSNull null]?@"":[rewDict objectForKey:@"chain_id"];
                                
                                reward.rewardExpired = [rewDict objectForKey:@"expired"]==[NSNull null]?@"":[rewDict objectForKey:@"expired"];
                                
                                reward.sortId = [rewDict objectForKey:@"sort_by_id"]==[NSNull null]?@"":[rewDict objectForKey:@"sort_by_id"];
                                
                                reward.expiryDate = [rewDict objectForKey:@"expiryDate"]==[NSNull null]?@"":[rewDict objectForKey:@"expiryDate"];
                                
                                reward.totalPoints = Points;
                                [userRewardsArray addObject:reward];
                                [reward release];
                                
                            }
                            
                            NSSortDescriptor * sortById = [NSSortDescriptor sortDescriptorWithKey:@"sortId" ascending:YES];
                            [userRewardsArray sortUsingDescriptors:[NSArray arrayWithObject:sortById]];
                            
                            for(Reward *rwd in userRewardsArray){
                                NSLog(@" reward id is : %@" , rwd.rewardId);
                            }
                            
                            
                            [rewardsTable reloadData];
                            [rewardsTable setHidden:NO];
                            [indicatorView stopAnimating];
                        }else{
                            // if no rewards earned
                        }
                    }else{
                        NSString *msg = [response objectForKey:@"notice"];
                        if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                            msg = [response objectForKey:@"message"];
                        
                        if([msg length] == 0)
                            msg = SOMETHING_WENT_WRONG;
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }}
            }
            else if(rsquestCount == 2) {
                if ([returnString isEqualToString:@"401"]) {
                   RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    if (status){
                        NSString *msg = [response objectForKey:@"notice"];
                        if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                            msg = [response objectForKey:@"message"];
                        
                        if([msg length] == 0)
                            msg = SOMETHING_WENT_WRONG;
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        
                        [userRewardsArray removeObject:[userRewardsArray objectAtIndex:rewardIndex]];
                        [rewardsTable reloadData];
                        [self appWillEnterForegroundNotification];
                        
                    }else{
                        
                        NSString *msg = [response objectForKey:@"notice"];
                        if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                            msg = [response objectForKey:@"message"];
                        
                        if([msg length] == 0)
                            msg = SOMETHING_WENT_WRONG;
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                }
           
            }
        }
    }else{
        
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)getUserInfo{
    rsquestCount = 4;
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kGetUserInfok],keyRequestType, nil];
    NSLog(@"adic %@", aDic);
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kGetUserInfok;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) viewDidAppear:(BOOL)animated{
	
	[expDelImage setImage:[UIImage imageNamed:@"expired_reward.png"]];
}

#pragma mark -
#pragma mark Fetch Reward List

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex ==0){
		[[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
		MainLogin *login = [[MainLogin alloc] init];
		[self.navigationController pushViewController:login animated:NO];
		[login release];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	expDelImage = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification
												  object:nil];  
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[expDelImage release];
    [super dealloc];
}

@end
