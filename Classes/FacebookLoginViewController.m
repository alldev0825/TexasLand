//
//  FacebookLoginViewController.m
//  Raising Canes
//
//  Created by Ajay Kumar on 10/11/12.
//  Copyright (c) 2012 My company. All rights reserved.
//

#import "FacebookLoginViewController.h"
#import "RewardMain.h"
#import "MainAppDelegate.h"
#import "UICKeyChainStore.h"
#import "ChangePassword.h"
#import "OptionPromo.h"
#import "ReferAFriend.h"
#import "OptionLocationSignup.h"

@interface FacebookLoginViewController ()

@end

@implementation FacebookLoginViewController
#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

@synthesize descLbl;
@synthesize referCodeField;
@synthesize titleLbl,username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkFb = TRUE;
    checkBoxStatus = TRUE;
    checkBoxBtn.selected = YES;
    signUpButton.enabled = NO;
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    
    [self setNeedsStatusBarAppearanceUpdate]; // overrided instance to changes status bar that called preferredStatusBarStyle
    
    // Do any additional setup after loadting the view from its nib.
    
    dobPicker.backgroundColor = [UIColor whiteColor];
    dobPicker.hidden = TRUE;
    dobToolbar.hidden = TRUE;
    dobField.enabled = FALSE;
    
    referCodeField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"day"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"month"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"year"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"id_signup_location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    [singleTap release];

    
    [self placeDobPickerAtbottom];
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [firstnameField resignFirstResponder];
}

- (void) placeDobPickerAtbottom{
    int dobH = dobPicker.frame.size.height;
    int dobW = dobPicker.frame.size.width;

    int tbH = dobToolbar.frame.size.height;
    int tbW = dobToolbar.frame.size.width;

    dobToolbar.frame = CGRectMake(dobToolbar.frame.origin.x, (self.view.frame.size.height - (dobH + tbH)), tbW , tbH);
    dobPicker.frame = CGRectMake(0, (self.view.frame.size.height - (dobH)), dobW , dobH);
}

- (IBAction)checkBoxBtn:(id)sender {
    if (checkBoxStatus) {
        checkBoxStatus = FALSE;
        checkBoxBtn.selected = NO;
        NSLog(@"test %i", checkBoxStatus);
    } else {
        checkBoxStatus = TRUE;
        checkBoxBtn.selected = YES;
        NSLog(@"test %i", checkBoxStatus);
    }
}


- (IBAction)FaceBookButtonClicked:(UIButton *)sender {
            [self threadStartAnimating];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fbCheckTexas"];
    [[NSUserDefaults standardUserDefaults] setObject:@"fbSignup" forKey:@"facebookCheck"];
	
    [self.view endEditing:YES];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self FbrequestMe];
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 [indicatorView stopAnimating];
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 [indicatorView stopAnimating];
                 NSLog(@"Cancelled");
             } else {
                 [self FbrequestMe];
                 NSLog(@"Logged in");
             }
         }];
    }
}

- (void) FbrequestMe{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fbCheckTexas"];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (error) {
             [indicatorView stopAnimating];
         }else{
             userInfoDict = [[NSDictionary alloc] initWithDictionary:result];
             username= [userInfoDict objectForKey:@"email"];
             
             if([username length]==0){
                 [indicatorView stopAnimating];
                 RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:SOMETHING_WENT_WRONG delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                 [alert setTag:2];
                 [alert show];
                 [alert release];
             }else{
                 [self submitSignUpData:@"2"];
             }
         }
     }];
}


-(void)viewWillAppear:(BOOL)animated{
    [scrollView setContentSize:CGSizeMake(256, 650)];
    [scrollView setScrollEnabled:YES];
    
    [dobPicker setDate:[NSDate date]];
    [dobPicker setMaximumDate:[NSDate date]];

    if(!([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1)){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    NSString *locationFlag = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"location_signup_flag"];
    NSString *nameoflocation = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"name_signup_location"];
    NSString *idoflocation = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"id_signup_location"];
    
    NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %@", idoflocation);
    
    if([locationFlag isEqualToString:@"1"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id_signup_location"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name_signup_location"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_signup_flag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        favLocationField.text = [NSString stringWithFormat:@"%@", nameoflocation];
        locationId.text = [NSString stringWithFormat:@"%@", idoflocation];
        
        
    }

}

- (void) threadStartAnimating {
    [indicatorView startAnimating];
}

-(void) submitSignUpData : (NSString *)registerType {
    [self threadStartAnimating];
    checkFb = FALSE;
        self.view.userInteractionEnabled = NO;
    NSString *deviceToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"])
    {
        deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"];
    }
    else
        deviceToken = @"";
    
    NSString *referralCode  = nil;
    if(referCodeField.text.length > 0)
    {
        referralCode = referCodeField.text;
    }
    else
        referralCode = @"";
    
    year = [[NSUserDefaults standardUserDefaults] objectForKey:@"year"];
    month = [[NSUserDefaults standardUserDefaults] objectForKey:@"month"];
    day = [[NSUserDefaults standardUserDefaults] objectForKey:@"day"];
    
    if(month == NULL){
        month = @"";
    }
    
    if(day == NULL){
        day = @"";
    }
    
    if(year == NULL){
        year = @"";
    }
    
    NSString *marketing_option = nil;
    if (checkBoxStatus)
        marketing_option = @"true";
    else
        marketing_option = @"false";
    
    NSString *password = @"";
    NSString *keychain = [UICKeyChainStore stringForKey:@"TexasUniqueID"];
    
    
    NSString *location_id  = nil;
    if(locationId.text.length > 0)
    {
        location_id = locationId.text;
    }
    else
        location_id = @"";
    
    NSLog(@"atest ==================== %@", marketing_option);
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"email",password,@"password",@"0",@"latitude",@"0",@"longitude",@"iphone",@"register_device_type",registerType,@"register_type",APPKEY,@"appkey",@"iphone",@"sign_in_device_type",deviceToken,@"device_token",firstnameField.text,@"first_name",[Utils checkDevice],@"phone_model",[[UIDevice currentDevice] systemVersion],@"os",keychain,@"keychain", day,@"dob_day",month,@"dob_month",year,@"dob_year", referralCode,@"referral_code", location_id, @"favorite_location", marketing_option,@"marketing_optin",[NSNumber numberWithInt:kSignUpRequest], keyRequestType, nil];
    rsquestCount = 1;
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kSignUpRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}


#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString1 {
    self.view.userInteractionEnabled = NO;
    [indicatorView stopAnimating];
    NSLog(@"Rewards returnString = %@",returnString1);
    if( returnString1!= nil && ![returnString1 isEqualToString:@""]){
		if([returnString1 isEqualToString:TIME_OUT] || [returnString1 isEqualToString:CONNECTION_FAILURE]){
			RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString1 delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}else{
			
			NSDictionary *response= [returnString1 JSONValue];
			BOOL status= [[response objectForKey:@"status"] boolValue];
			if (status){
                NSString *userId= [response objectForKey:@"auth_token"];
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"userEmail"];
				NSLog (@"auth_token is : %@ ", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
                appDelegate.checkScreen = TRUE;
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if ([msg isKindOfClass:[NSNull class]]){
                    msg = @"Signup Successful";
                }

                if(!msg){
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:SOMETHING_WENT_WRONG delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }else{
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                
                
			}else{
				NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
				RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
    }
}

- (void) requestError:(NSString * )returnString {
    
    //  NSLog(@"response coming with error %@" , returnString);
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];;
}
- (void) requestNetworkError {
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
		
      /*
       if(self.navigationController.viewControllers.count > 1) {
            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[OptionPromo class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }
        }
        
        if(self.navigationController.viewControllers.count > 2) {
            if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[ChangePassword class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                return;
            }
        }
        
        if(self.navigationController.viewControllers.count > 1) {
            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[ReferAFriend class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"home"];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }
        }
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
       
       */
        
        NSArray *vcs = self.navigationController.viewControllers;
        if(vcs.count > 1) {
            int idx = (int)vcs.count - 3;
            [self.navigationController popToViewController:[vcs objectAtIndex:idx] animated:YES];
            return;
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(alertView.tag == 2){
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"/me/permissions" parameters:nil HTTPMethod:@"DELETE"]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         }];
        [[[FBSDKLoginManager alloc]init]logOut];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"authData"];
        [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(IBAction) backButtonAction{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark textField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
    
    dobPicker.hidden = YES;
    dobToolbar.hidden = YES;
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    dobPicker.hidden = YES;
    dobToolbar.hidden = YES;
    
    if(textField.tag == 1){
        [scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"here");
    [referCodeField resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setReferCodeField:nil];
    [self setTitleLbl:nil];
    [self setDescLbl:nil];
    [dobToolbar release];
    dobToolbar = nil;
    [dobPicker release];
    dobPicker = nil;
    [dobField release];
    dobField = nil;
    [formFieldRefer release];
    formFieldRefer = nil;
    [formFieldBirthday release];
    formFieldBirthday = nil;
    [titleLbl release];
    titleLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)editingChanged {
    [self validateForm];
}

-(void)validateForm{
    if ([firstnameField.text length] != 0){
        signUpButton.enabled = YES;
    } else {
        signUpButton.enabled = NO;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        return NO;
    }
    
    
    if (textField.tag == 3) {
        NSCharacterSet *unacceptedInput = nil;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }else{
        return true;
    }

    
    if (textField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

- (void)dealloc {
    [referCodeField release];
    [titleLbl release];
    [username release];
    [descLbl release];
    [dobToolbar release];
    [dobPicker release];
    [dobField release];
    [formFieldRefer release];
    [formFieldBirthday release];
    [checkBoxBtn release];
    [scrollView release];
    [super dealloc];
}

- (IBAction)dobBtn:(id)sender {
    [firstnameField resignFirstResponder];
    [referCodeField resignFirstResponder];
    dobPicker.hidden = FALSE;
    dobToolbar.hidden = FALSE;
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //    formFieldBirthday.image=[UIImage imageNamed:@"formfield_1.png"];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]init];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                  style:UIBarButtonItemStyleDone target:self
                                                 action:@selector(getpick)];
    
    [dobToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,doneButton, nil]];

}

-(void) getpick{
    dobPicker.hidden = TRUE;
    dobToolbar.hidden = TRUE;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    dobField.text = [NSString stringWithFormat:@"%@",
                     [df stringFromDate:dobPicker.date]];
    
    NSDate *dateFromPicker = [dobPicker date];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [calendar components: unitFlags fromDate: dateFromPicker];
    
    int intyear = [components year];
    int intmonth = [components month];
    int intday = [components day];
    
    year = [NSString stringWithFormat:@"%i", intyear];
    month = [NSString stringWithFormat:@"%i",intmonth];
    day = [NSString stringWithFormat:@"%i",intday];
    
    [[NSUserDefaults standardUserDefaults] setObject:day forKey: @"day"];
    [[NSUserDefaults standardUserDefaults] setObject:month forKey: @"month"];
    [[NSUserDefaults standardUserDefaults] setObject:year forKey: @"year"];
    
    [calendar release];
}


- (IBAction)favLocationClick:(id)sender {
    dobPicker.hidden = TRUE;
    dobToolbar.hidden = TRUE;
    [firstnameField resignFirstResponder];
    [referCodeField resignFirstResponder];

    
    [self.view endEditing:YES];
    
    OptionLocationSignup *locationlist = [[OptionLocationSignup alloc]init];
    [self.navigationController pushViewController:locationlist animated:NO];
    [locationlist release];
    
}



@end