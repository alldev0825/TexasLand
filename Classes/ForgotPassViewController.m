//
//  ForgotPassViewController.m
//
//

#import "ForgotPassViewController.h"
#import "MainAppDelegate.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "LocationSignUp.h"

@implementation ForgotPassViewController
@synthesize lblTitle;


-(IBAction) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) hideKeyboard{
    
}


- (IBAction)editingChanged {
    if(([emailField.text length] > 0))
    {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
}

#pragma mark -
#pragma mark textField delegate


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"here");
    [emailField resignFirstResponder];
    
}

#pragma mark -
#pragma mark Submit methods

-(IBAction) sendButtonPressed {
    
    [emailField resignFirstResponder];
    if ([emailField.text length] == 0 ) {
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Forget Password Enter Email",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    [indicatorView startAnimating];
    // [self performSelectorOnMainThread:@selector(sendEmailThread:) withObject:emailField.text waitUntilDone:NO];
    // [NSThread detachNewThreadSelector:@selector(sendEmailThread:) toTarget:self withObject:emailField.text];
    [self sendEmailThread:emailField.text];
}

-(void) sendEmailThread:(NSString *)emailId {
    self.view.userInteractionEnabled = NO;
    enterBtn.enabled = NO;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",emailId,@"email",@"1",@"register_type",[NSNumber numberWithInt:kForgotPasswordRequest],keyRequestType, nil];
    
    //  rsquestCount = 3;
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kForgotPasswordRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    /*
     */
    
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    enterBtn.enabled = YES;
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
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
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:NSLocalizedString(@"Success","") message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
                
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
    else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (void) requestError:(NSString * )returnString {
    
    //  NSLog(@"response coming with error %@" , returnString);
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) requestNetworkError {
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    [self setNeedsStatusBarAppearanceUpdate];
    enterBtn.enabled = FALSE;    
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload
{
    [enterBtn release];
    enterBtn = nil;
    [formFieldEmail release];
    formFieldEmail = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        return NO;
    }
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [enterBtn release];
    [formFieldEmail release];
    [super dealloc];
}

@end
