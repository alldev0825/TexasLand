//
//  LocationLogin.m
//
//

#import "LocationLogin.h"
#import "LocationSignUp.h"
#import "MainAppDelegate.h"
#import "User.h"
#import "ForgotPassViewController.h"
#import "RewardMain.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "UICKeyChainStore.h"
#import "OptionPromo.h"
#import "ChangePassword.h"
#import "ReferAFriend.h"
#import "getSocial.h"
#import "DataAccessLayer.h"
#import "scan.h"
#import "Settings.h"
#import "RewardActivity.h"

@implementation LocationLogin

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC
@synthesize loginButton;

@synthesize twitterId,emailId,city,firstName,lastName , username , password;

- (IBAction)editingChanged {
    if ([usernameField.text length] != 0 && [passwordField.text length] != 0) {
        loginButton.enabled = YES;
    } else {
        loginButton.enabled = NO;
    }
}

-(IBAction) forgotPassButtonPress{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    ForgotPassViewController *forgot=[[ForgotPassViewController alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:forgot animated:YES];
    [forgot autorelease];
}

- (void)setAccessibility:(BOOL ) value{
    usernameField.enabled = value;
    passwordField.enabled = value;
    loginButton.enabled = value;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Login Button Clicked
-(IBAction) logInButtonPressed {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    if ([usernameField.text length] > 0 && [passwordField.text length] > 0) {
        [scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
        username = [usernameField.text length] == 0 ? @"" : [usernameField.text retain];
        password = [passwordField.text length] == 0 ? @"" : [passwordField.text retain];
        success=YES;
        loginButton.enabled = NO;
        
        [indicatorView startAnimating];
        [self setAccessibility:NO];
        [self submitLogInData:@"1"];
    }
    else {
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"") message:NSLocalizedString(@"Empty Field Error",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        return;
    }
}

#pragma mark Submit Login Data
-(void) submitLogInData : (NSString *) registerType{
    self.view.userInteractionEnabled = NO;
    NSString *deviceToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"])
    {
        deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"];
    }
    else
        deviceToken = @"";
    
    NSString *keychain = [UICKeyChainStore stringForKey:@"TexasUniqueID"];
    
    NSLog(@"keychain %@", keychain);
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"email",[self escapeurl:passwordField.text],@"password",registerType,@"register_type",APPKEY,@"appkey",@"iphone",@"sign_in_device_type",deviceToken,@"device_token",[Utils checkDevice],@"phone_model",[[UIDevice currentDevice] systemVersion],@"os",keychain,@"keychain",[NSNumber numberWithInt:kLoginRequest], keyRequestType, @"0", @"latitude", @"0", @"longitude", nil];
    
    NSLog(@"adic -=-=-=-=-=-=-=-=-= device token %@", aDic);
    
    rsquestCount = 0;
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kLoginRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    loginButton.enabled = YES;
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
            
            if ([returnString isEqualToString:@"401"]) {
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }];
                [alert release];
                
            }else{
                NSLog(@"rsquestCount is : %ld", (long)rsquestCount);
                NSLog(@"self.navigationController.viewControllers.count :%@", self.navigationController.viewControllers);
                if(rsquestCount == 0){
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    NSLog(@"user id -------------- %@", response);
                    NSString *msg = [response objectForKey:@"notice"];
                    if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                        msg = [response objectForKey:@"message"];
                    
                    if([msg length] == 0)
                        msg = SOMETHING_WENT_WRONG;
                    
                    if (status){
                        NSString *userId = [response objectForKey:@"auth_token"];
                        NSString *customer_id = [response objectForKey:@"customer_id"];
                        NSString *card_number = [response objectForKey:@"card_number"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:customer_id forKey:@"customer_id"];
                        [[NSUserDefaults standardUserDefaults] setObject:card_number forKey:@"card_number"];
                        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"userEmail"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        appDelegate.checkReward = TRUE;
                        
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        alert.tag = 101;
                        alert.delegate = self;
                        [alert show];
                        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                            [alert dismissWithClickedButtonIndex:0 animated:NO];
                        }];
                        [alert release];
                        
                    }else{
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
    
    [self setAccessibility:YES];
}

- (void) FbrequestMe{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fbCheckTexas"];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         NSLog(@"result :%@", result);
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
                 [self submitLogInData:@"2"];
             }
         }
     }];
}



- (IBAction)fbBtnAction:(id)sender{
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



-(NSString *)escapeurl:(NSString *)returnstring{
    
    NSString *apiKey = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)returnstring, NULL, (CFStringRef)@"!*'();:@&=+-$,/?%#[]", kCFStringEncodingUTF8));
    
    NSLog(@"api key -=-=-=-=-=-=-=-=- %@", apiKey);
    
    return apiKey;
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
    self.view.userInteractionEnabled = YES;
    //  NSLog(@"response coming with error %@" , returnString);
    [indicatorView stopAnimating];
    [self setAccessibility:YES];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];;
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    [self setAccessibility:YES];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}


-(IBAction) backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) hideKeyboard {
    
}
#pragma mark -
#pragma mark textField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField.tag == 1){
        [scrollView setContentOffset:CGPointMake(0, 104) animated:YES];
    }else if(textField.tag == 2){
        [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"here");
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void) threadStartAnimating {
    [indicatorView startAnimating];
    [self setAccessibility:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        return NO;
    }
    /*if (textField.tag==2) {
        NSCharacterSet *unacceptedInput = nil;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }else{
        return true;
    }*/
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    checkAlert = FALSE;
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    loginButton.enabled = NO;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    [singleTap release];
    [self setNeedsStatusBarAppearanceUpdate]; 
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [scrollView setContentSize:CGSizeMake(256, 850)];
    [scrollView setScrollEnabled:YES];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]!=-1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [formFieldEmail release];
    formFieldEmail = nil;
    [formFieldPwd release];
    formFieldPwd = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [loginButton release];
    [formFieldEmail release];
    [formFieldPwd release];
    [super dealloc];
}


-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
        // ADDED 03/18/2015 Ibrahim B
        // Delegate so referring UI know about login
        if ( _delegate != nil ) {
            [_delegate loginOk];
            return;
        }
        
        NSLog(@"self.navigationController.viewControllers.count : %@", self.navigationController.viewControllers);
        /*
        if(self.navigationController.viewControllers.count > 1) {
            if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[RewardActivity class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                return;
            }
            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[Settings class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }

            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[Settings class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }

            if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[RewardMain class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                return;
            }
            if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[scan class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                return;
            }
            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[ReferAFriend class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }
            
        }
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
    }
}

@end
