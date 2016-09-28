//
//  Settings.m
//  Raising Canes
//
//  Created by Devceloper on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "ForgotPassViewController.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "MainLogin.h"
#import "MainAppDelegate.h"
#import "ChangePassword.h"
#import "RewardActivity.h"

const int CHANGE_PASSWORD = 0;
const int ACCOUNT_STATUS = 1;


@implementation Settings


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [settingsTbl reloadData];
    
    
    [self.view setNeedsDisplay];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    // Initializing App Delegate
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkSetting = TRUE;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (IBAction)doneButtonPressed{
    //
        [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark -
# pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row : %d", (int) indexPath.row);
    if((indexPath.row == 2) &&
       [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue] !=-1){
        return 59;
    }else{
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	loginCheck=NO;
    
    NSString *rowId;
    rowId=[NSString stringWithFormat:@"cell%ld%@",(long)indexPath.row,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowId];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *txtLabel=[[[UILabel alloc] initWithFrame:CGRectMake(15, 0,290, 40)] autorelease];
        
        [txtLabel setFont:[UIFont fontWithName:@"UnitedSansCond-Bold" size:20]];
        [txtLabel setTextColor: [Utils colorWithHexString:@"4b3829"]];
        
        UIImageView *bgPic = [[[UIImageView alloc] initWithFrame:CGRectMake(15,41,290,1)]autorelease];
        bgPic.backgroundColor = [UIColor lightGrayColor];
        [bgPic setImage:[UIImage imageNamed:@"line-info.png"]];
        UIImageView *arrowPic = [[[UIImageView alloc] initWithFrame:CGRectMake(295,13,9,12)]autorelease];
        [arrowPic setImage:[UIImage imageNamed:@"arrow-sm.png"]];

        switch (indexPath.row) {
                
            case ACCOUNT_STATUS:
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue] ==-1|| [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] == nil)
                {
                    [txtLabel setText:@"LOG IN"];
                    arrowPic.hidden = NO;
                }else{
                    [txtLabel setText:@"LOG OUT"];
                    txtLabel.frame = CGRectMake(15, 8,260, 30);
                    bgPic.frame = CGRectMake(15, 65,290, 1);
                    UILabel *txtLabel2=[[[UILabel alloc] initWithFrame:CGRectMake(15, 27,290, 30)] autorelease];
                    txtLabel2.numberOfLines = 1;
                    txtLabel2.minimumFontSize = 8.;
                    txtLabel2.adjustsFontSizeToFitWidth = YES;
                    [txtLabel2 setFont:[UIFont fontWithName:@"UnitedSansCond-Bold" size:17]];
                    [txtLabel2 setTextColor: [Utils colorWithHexString:@"4b3829"]];
                    
                    txtLabel2.text = [NSString stringWithFormat:@"Logged in as: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]];
                    [cell addSubview:txtLabel2];
                    arrowPic.hidden = YES;
                }
                break;
            case CHANGE_PASSWORD:
                [txtLabel setText:@"CHANGE PASSWORD"];

                break;
                
        }
        
        [cell.contentView addSubview:arrowPic];
        [cell addSubview:bgPic];
        [cell addSubview:txtLabel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.row : %d", (int)indexPath.row);
    switch (indexPath.row) {
            
        case CHANGE_PASSWORD:
        {
            ChangePassword *cp=[[ChangePassword alloc] init];
            [self.navigationController pushViewController:cp animated:NO];
            [cp autorelease];
            
            break;
        }
        case ACCOUNT_STATUS:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]!=-1){
                
                [indicatorView startAnimating];
                self.view.userInteractionEnabled = NO;
                
                NSString *autToken  = nil;
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
                {
                    autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                }
                else
                    autToken = @"";
                
                NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kLogoutRequest], keyRequestType, nil];
                Server *obj = [[[Server alloc] init] autorelease];
                currentRequestType = kLogoutRequest;
                obj.delegate = self;
                [obj sendRequestToServer:aDic];
            }else{
                MainLogin *loginView = [[MainLogin alloc] init];
                [self.navigationController pushViewController:loginView animated:NO];
                [loginView release];
            }
            
            break;
        }
     
    }
}


#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    [indicatorView stopAnimating];
    self.view.userInteractionEnabled = YES;
    
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            
        }else {
            NSDictionary *response= [returnString JSONValue];
            BOOL status= [[response objectForKey:@"status"] boolValue];
            if (status){
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
                
                [[[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                [lblLoginStatus setText:NSLocalizedString(@"Login",@"")];
                //                [tableView reloadData];
                
                [settingsTbl reloadData];
                [indicatorView stopAnimating];
                //               [OptionListTable reloadData];
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
        
    }else{
        
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
    }
    
}

- (void) requestError:(NSString * )returnString {
    
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

- (void) requestNetworkError {
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}



@end
