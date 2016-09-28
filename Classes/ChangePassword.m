//
//  ChangePassword.m
//
//

#import "ChangePassword.h"
#import "MainAppDelegate.h"
#import "User.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "Constants.h"
#import "MainLogin.h"
#import "RMUIAlertView.h"

@implementation ChangePassword

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC
@synthesize myScrollView;

-(IBAction) backButtonAction{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) hideKeyboard {
	[scrollView scrollRectToVisible:CGRectMake(0, 0, 256, 89) animated:NO];
	[scrollView setContentSize:CGSizeMake(256, 89)];
}
- (void)setAccessibility:(BOOL ) value{
    oldPassword.enabled = value;
    passwordField.enabled = value;
    repeatField.enabled = value;
    enterBtn.enabled = value;
    
}

#pragma mark -
#pragma mark textField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
    
    enterBtn.enabled = NO;
    if(([oldPassword.text length] > 0) && ([passwordField.text length] > 0) && ([repeatField.text length] > 0))
    {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"here");
    
    [oldPassword resignFirstResponder];
    [passwordField resignFirstResponder];
    [repeatField resignFirstResponder];
    
    enterBtn.enabled = NO;
    if(([oldPassword.text length] > 0) && ([passwordField.text length] > 0) && ([repeatField.text length] > 0))
    {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
}

-(IBAction) updateButtonPressed {
    [passwordField resignFirstResponder];
    [repeatField resignFirstResponder];
    [oldPassword resignFirstResponder];
    password=[passwordField.text retain];
    [indicatorView startAnimating];
    [myScrollView setContentSize:CGSizeMake(0, 0)];
    [self setAccessibility:NO];
    [self updatePasswordThread];
}

-(void) updatePasswordThread {
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"auth_token",passwordField.text,@"password",oldPassword.text,@"current_password",repeatField.text,@"password_confirmation",[NSNumber numberWithInt:kUpdatePasswordRequest], keyRequestType, nil];
    
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kUpdatePasswordRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    
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
                alert.tag=1;
				[alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                [alert release];
            }else{
                
                NSDictionary *response= [returnString JSONValue];
                BOOL status= [[response objectForKey:@"status"] boolValue];
                
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
                
                if (status){
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                    
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

- (void) requestError:(NSString * )returnString {
    
    //  NSLog(@"response coming with error %@" , returnString);
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
        [self setAccessibility:YES];
}
- (void) requestNetworkError {
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
            [self setAccessibility:YES];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(alertView.tag==1){
		[[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
		MainLogin *login = [[MainLogin alloc] init];
		[self.navigationController pushViewController:login animated:YES];
		[login release];
		
	}else if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
		[self.navigationController popViewControllerAnimated:YES];
        
	}
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    enterBtn.enabled = NO;
    if(([oldPassword.text length] > 0) && ([passwordField.text length] > 0) && ([repeatField.text length] > 0))
    {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
    
    NSCharacterSet *unacceptedInput = nil;
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet];
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    enterBtn.enabled = NO;
    if(([oldPassword.text length] > 0) && ([passwordField.text length] > 0) && ([repeatField.text length] > 0))
    {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        rect.origin.y -= kOFFSET_FOR_KEYBOARD-40;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD-40;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *login = [[MainLogin alloc]init];
        [self.navigationController pushViewController:login animated:NO];
        [login release];
	}
    
	appDelegate=(MainAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myScrollView setContentSize:CGSizeMake(256, 450)];
    enterBtn.enabled = FALSE;    
 
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[myScrollView setContentSize:CGSizeMake(256, 450)];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(void) viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[scrollView release];
    [self setMyScrollView:nil];
    [enterBtn release];
    enterBtn = nil;
    [formField1 release];
    formField1 = nil;
    [formField2 release];
    formField2 = nil;
    [formField3 release];
    formField3 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [myScrollView release];
    [enterBtn release];
    [formField1 release];
    [formField2 release];
    [formField3 release];
    [super dealloc];
}

@end
