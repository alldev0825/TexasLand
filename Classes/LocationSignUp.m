//
//  LocationSignUp.m
//
//
#import "LocationSignUp.h"
#import "MainAppDelegate.h"
//#import "FBConnect.h"
#import "RewardMain.h"
#import "User.h"
#import "LocationLogin.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "TermsOfUserViewController.h"
#import "UICKeyChainStore.h"
#import "ChangePassword.h"
#import "OptionPromo.h"
#import "ReferAFriend.h"
#import "getSocial.h"
#import "scan.h"
#import "Settings.h"
#import "RewardActivity.h"
#import "OptionLocationSignup.h"

@implementation LocationSignUp

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC
@synthesize myScrollView;
@synthesize signUpButton;
@synthesize phoneNum;

@synthesize username , password;




- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"$1-$2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"$1-$2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}


- (IBAction)editingChanged {
        [self validateForm];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    array_from = [[NSMutableArray alloc] init];
    array_from_id = [[NSMutableArray alloc] init];
    tempDropId = [[NSString alloc] init];
    tempDropName = [[NSString alloc] init];
    
    [myScrollView setContentSize:CGSizeMake(256, 850)];
    [myScrollView setScrollEnabled:YES];
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



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    tempDropId = [array_from_id objectAtIndex:row];
    tempDropName = [array_from objectAtIndex:row];
    
    locationId.text = [NSString stringWithFormat:@"%@", tempDropId];
    
    NSLog(@"id -=-=-=-=-= %@", tempDropId);
    /*Survey *survey;
     survey = [surveyArray objectAtIndex:tagButton];
     array_from = survey.qlabel;*/
    
    /*[arrayDrop replaceObjectAtIndex:fooIndex withObject:[survey.dropIdArray objectAtIndex:row]];
     [dropdowntemp replaceObjectAtIndex:fooIndex withObject:[NSNumber numberWithInt:row]];*/
}

- (IBAction)favLocationClick:(id)sender {
    dobPicker.hidden = TRUE;
    dobToolbar.hidden = TRUE;
    
    [self.view endEditing:YES];
    
    OptionLocationSignup *locationlist = [[OptionLocationSignup alloc]init];
    [self.navigationController pushViewController:locationlist animated:NO];
    [locationlist release];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    dobPicker.hidden = YES;
    dobToolbar.hidden = YES;
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark Sign Up Button Pressed
-(IBAction) signUpButtonPressed {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    [self.view endEditing:YES];
    
    if([usernameField.text length] > 0 && [passwordField.text length] > 0 ) {
        username = [usernameField.text length] == 0 ? @"" : [usernameField.text retain];
        password = [passwordField.text length] == 0 ? @"" : [passwordField.text retain];
        phoneNum = [phonenumberField.text length] == 0 ? @"" : [phonenumberField.text retain];
        success=YES;
    }
    
    RMUIAlertView *alert=[[RMUIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat: NSLocalizedString(@"Confirm Email Address",@"")
                                                                       //@"Please confirm your email : \"%@\""
                                                                       ,username] delegate:self cancelButtonTitle:NSLocalizedString(@"Confirm",@"") otherButtonTitles:NSLocalizedString(@"Cancel",@""), nil];
    alert.tag=1;
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
    
}

- (void)alertView:(RMUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
    {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:NSLocalizedString(@"Confirm",@"")]) {
            password = [passwordField.text retain];
            [indicatorView startAnimating];
            [myScrollView setContentOffset:CGPointMake(0, 20) animated:YES];
            [self setAccessibility:NO];
            signUpButton.enabled = FALSE;
            [self submitSignUpData:@"1"];
        }
    }
}

#pragma mark -
#pragma mark Signup Method
-(void) submitSignUpData : (NSString *)registerType {
    self.view.userInteractionEnabled = NO;
    NSString *deviceToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"])
    {
        deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"PNToken"];
    }
    else
        deviceToken = @"";
    
    
    NSString *marketing_option = nil;
    if (checkBoxStatus)
        marketing_option = @"true";
    else
        marketing_option = @"false";
    
    NSString *referralCode  = nil;
    if(referField.text.length > 0)
    {
        referralCode = referField.text;
    }
    else
        referralCode = @"";

    NSString *location_id  = nil;
    if(locationId.text.length > 0)
    {
        location_id = locationId.text;
    }
    else
        location_id = @"";
    
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
    
    
    NSLog(@"merketing %@", marketing_option);
    
    NSLog(@"location ID %@", location_id);
    
    NSString *keychain = [UICKeyChainStore stringForKey:@"TexasUniqueID"];
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"email",[self escapeurl:passwordField.text],@"password",@"0",@"latitude",@"0",@"longitude",@"iphone",@"register_device_type",registerType,@"register_type",APPKEY,@"appkey",@"iphone",@"sign_in_device_type",deviceToken,@"device_token",firstnameField.text,@"first_name",[Utils checkDevice],@"phone_model",[[UIDevice currentDevice] systemVersion],@"os",keychain,@"keychain", day,@"dob_day",month,@"dob_month",year,@"dob_year", referralCode,@"referral_code", location_id, @"favorite_location", marketing_option,@"marketing_optin",[NSNumber numberWithInt:kSignUpRequest], keyRequestType, nil];

    
    NSLog(@"adic -=-=-=-=-=-=-=-=-=-=-=-=-=-= %@", aDic);
    
    rsquestCount = 1;
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kSignUpRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString1 {
    NSLog(@"Rewards returnString = %@",returnString1);
    if( returnString1!= nil && ![returnString1 isEqualToString:@""]){
        if([returnString1 isEqualToString:TIME_OUT] || [returnString1 isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString1 delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            
        }else{
            
            NSDictionary *response= [returnString1 JSONValue];
            NSLog(@"response ----------- %@", response);
            BOOL status= [[response objectForKey:@"status"] boolValue];
            NSString *msg = [response objectForKey:@"notice"];
            if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                msg = [response objectForKey:@"message"];
            
            
            if (status){
                NSString *customer_id = [response objectForKey:@"customer_id"];
                NSString *card_number = [response objectForKey:@"card_number"];
                NSString *userId= [response objectForKey:@"auth_token"];
                
                [[NSUserDefaults standardUserDefaults] setObject:customer_id forKey:@"customer_id"];
                [[NSUserDefaults standardUserDefaults] setObject:card_number forKey:@"card_number"];
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"userEmail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                appDelegate.checkReward = TRUE;
                NSLog (@"auth_token is : %@ ", [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
                RMUIAlertView *alert;
                if ([msg isKindOfClass:[NSNull class]]){
                    msg = @"Signup Successful";
                }

                if(!msg){
                    alert = [[RMUIAlertView alloc] initWithTitle:@"" message:SOMETHING_WENT_WRONG delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];

                }else{
                    alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    alert.delegate = self;

                    alert.tag = 101;
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];

                }
                

                
                
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
    self.signUpButton.enabled = TRUE;
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    [self setAccessibility:YES];
    
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
    self.view.userInteractionEnabled = YES;
    //  NSLog(@"response coming with error %@" , returnString);
    [indicatorView stopAnimating];
    [self setAccessibility:YES];
    signUpButton.enabled = TRUE;
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];;
}

-(NSString *)escapeurl:(NSString *)returnstring{
    
    NSString *apiKey = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)returnstring, NULL, (CFStringRef)@"!*'();:@&=+-$,/?%#[]", kCFStringEncodingUTF8));
    
    NSLog(@"api key -=-=-=-=-=-=-=-=- %@", apiKey);
    
    return apiKey;
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
    self.view.userInteractionEnabled = YES;
    self.signUpButton.enabled = TRUE;
    [indicatorView stopAnimating];
    [self setAccessibility:YES];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
        
        // @ADDED notify order page if this page comes from order page
        if( alertView.tag == 101 && _delegate ) {
            
            [_delegate registerOk];
            
            return;
        }
        // @END OF ADDED
        
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
            if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[Settings class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
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
            if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[ReferAFriend class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
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
    }
}


-(void)DoneLocation{
    
    [myPickerView removeFromSuperview];
    [toolbar removeFromSuperview];
    
    favLocationField.text = [NSString stringWithFormat:@"%@", tempDropName];
    
}

- (IBAction)birthdayClick:(id)sender {
    [self.view endEditing:YES];
    [myScrollView setContentOffset:CGPointMake(0, 170) animated:YES];
    
    dobPicker.hidden = FALSE;
    dobToolbar.hidden = FALSE;
    
    [myPickerView removeFromSuperview];
    [toolbar removeFromSuperview];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]init];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                  style:UIBarButtonItemStyleDone target:self
                                                 action:@selector(getpick)];
    
    [dobToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,doneButton, nil]];
}


-(void)validateForm{
    if ([usernameField.text length] != 0 && [passwordField.text length] != 0 && [firstnameField.text length] != 0 ) {
        if([passwordField.text length] >= 7)
            signUpButton.enabled = YES;
        else
            signUpButton.enabled = NO;
    } else {
        signUpButton.enabled = NO;
    }
}


-(void) getpick{
    dobPicker.hidden = TRUE;
    dobToolbar.hidden = TRUE;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    dobField.text = [NSString stringWithFormat:@"%@",
                        [df stringFromDate:dobPicker.date]];
    
    [self validateForm];
    
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



-(IBAction) backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction) hideKeyboard {
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    checkBoxStatus = TRUE;
    checkBox.selected = TRUE;
    appDelegate =(MainAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self setNeedsStatusBarAppearanceUpdate]; // overrided instance to changes status bar that called preferredStatusBarStyle

    [usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [firstnameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [referField setAutocorrectionType:UITextAutocorrectionTypeNo];
    firstnameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [myScrollView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    [singleTap release];
    signUpButton.enabled = NO;
    dobPicker.backgroundColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"day"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"month"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"year"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"id_signup_location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self placeDobPickerAtbottom];
    
}

- (void) placeDobPickerAtbottom{
    int dobH = dobPicker.frame.size.height;
    int dobW = dobPicker.frame.size.width;
    
    int tbH = dobToolbar.frame.size.height;
    int tbW = dobToolbar.frame.size.width;
    
    dobToolbar.frame = CGRectMake(dobToolbar.frame.origin.x, (self.view.frame.size.height - (dobH + tbH)), tbW , tbH);
    dobPicker.frame = CGRectMake(0, (self.view.frame.size.height - (dobH)), dobW , dobH);
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [firstnameField resignFirstResponder];
    [lastnameField resignFirstResponder];
    [phonenumberField resignFirstResponder];
    [referField resignFirstResponder];
    [securityField resignFirstResponder];
    [answerField resignFirstResponder];
}

#pragma mark -
#pragma mark textField delegate
-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)setAccessibility:(BOOL ) value{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [referField resignFirstResponder];
    [firstnameField resignFirstResponder];
    [lastnameField resignFirstResponder];
    [phonenumberField resignFirstResponder];
    [securityField resignFirstResponder];
    [answerField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [myPickerView removeFromSuperview];
    [toolbar removeFromSuperview];
    
    dobPicker.hidden = YES;
    dobToolbar.hidden = YES;
    
    if(textField.tag == 3){
        [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if(textField.tag == 4){
        [myScrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }else if(textField.tag == 5){
        [myScrollView setContentOffset:CGPointMake(0, 70) animated:YES];
    }else if(textField.tag == 8){
        [myScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"here");
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [firstnameField resignFirstResponder];
    [lastnameField resignFirstResponder];
    [phonenumberField resignFirstResponder];
    [referField resignFirstResponder];
    [securityField resignFirstResponder];
    [answerField resignFirstResponder];
    
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


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setSignUpButton:nil];
    [self setMyScrollView:nil];
    [formFieldEmail release];
    formFieldEmail = nil;
    [formFieldPwd release];
    formFieldPwd = nil;
    [referField release];
    referField = nil;
    [referField release];
    referField = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)callSignupMethod:(NSNotification *)note
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    
    NSLog(@"inside pop this view");
    username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    password = @"";
    
    //[self submitSignUpData:@"2"];
    [self submitSignUpData:@"2"];
    
    // NSString *status = [[note userInfo] valueForKey:@"status"];
    //do rest
    
}
#pragma mark --
#pragma mark keyboard
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)dealloc {
    [referField release];
    [signUpButton release];
    [myScrollView release];
    [formFieldEmail release];
    [formFieldPwd release];
    [checkBox release];
    [lbldesc release];
    [super dealloc];
}

- (IBAction)checkBoxBtn:(id)sender {
    if (checkBoxStatus) {
        checkBoxStatus = FALSE;
        checkBox.selected = NO;
        NSLog(@"test %i", checkBoxStatus);
    } else {
        checkBoxStatus = TRUE;
        checkBox.selected = YES;
        NSLog(@"test %i", checkBoxStatus);
    }
}

@end
