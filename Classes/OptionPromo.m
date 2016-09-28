//
//  OptionProfile.m
//  VivaLaCrepe
//
//  Created by mac book on 10/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionPromo.h"
#import "MainAppDelegate.h"
#import "User.h"
#import "LocationLogin.h"
#import "LocationSignUp.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "MainLogin.h"

@implementation OptionPromo


-(IBAction) backButtonAction{
	[self.navigationController popViewControllerAnimated:YES];
}


-(IBAction) showContactUsView{
    if (![MFMailComposeViewController canSendMail]) {
        [[[RMUIAlertView alloc] initWithTitle:@"Error!!!" message:NSLocalizedString(@"No Mail Account Configured",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        return;
    }
    
    MFMailComposeViewController *mailCompoeser = [[MFMailComposeViewController alloc] init];
    [mailCompoeser setMailComposeDelegate:self];
    [mailCompoeser setDelegate:self];
    [mailCompoeser setSubject:@"Texas Land & Cattle - Promo code assistance"];
    NSString *emailBody  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"])
    {
        emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n------------------------------------------------\n- %@ ios  %@\n- app version %@\n- email signed up with : %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]];
    }
    else
        emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n------------------------------------------------\n-%@ ios  %@\n-app version %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    appDelegate.checkInfo = FALSE;
    [mailCompoeser setMessageBody:emailBody isHTML:NO];
    [mailCompoeser setToRecipients:[NSArray arrayWithObjects:NSLocalizedString(@"Contact Email", @""), nil]];
    [self presentModalViewController:mailCompoeser animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *message = @"";
    switch (result) {
            
        case MFMailComposeResultCancelled:{
            message = @"Your message has been cancelled!";
        }
            break;
        case MFMailComposeResultSaved:
            message = @"Your message has been saved!";
            break;
        case MFMailComposeResultSent: {
            message = @"Your message has been sent!";
        }
            break;
        case MFMailComposeResultFailed:
            message = @"Email Failed";
            break;
        default:
            message = @"Email Not Sent";
            break;
    }
    RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alertView1 dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alertView1 show];
    [alertView1 release];

    [controller dismissViewControllerAnimated:YES completion:nil];
    appDelegate.checkInfo = TRUE;
}

#pragma mark -
#pragma mark textField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
    
}

- (IBAction)editingChanged {
    if ([txtPromoCode.text length] != 0) {
        enterbtn.enabled = YES;
    } else {
        enterbtn.enabled = NO;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"here");
	[txtPromoCode resignFirstResponder];
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
	for (int i = 0; i < [string length]; i++) {
		unichar c = [string characterAtIndex:i];
		if ([myCharSet characterIsMember:c]) {
			return NO;
		}
	}
    
    if (theTextField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
	
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
	return YES;
}


-(IBAction) sendButtonPressed {
	//if ([txtPromoCode.text length] > 0) {
    promoCode = [txtPromoCode.text retain];
    [txtPromoCode resignFirstResponder];
    [indicatorView startAnimating];
    forceValue =NO;
    [self submitPromoThread];
}

-(void) submitPromoThread {
    self.view.userInteractionEnabled = NO;
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"auth_token",promoCode,@"code",forceValue?@"true":@"",@"force",[NSNumber numberWithInt:kSubmitPromoRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kSubmitPromoRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    
}

- (void)alertView:(RMUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==106) {
        
        if(buttonIndex>0)
        {
            //[Utils startActivityIndicatorInView:self.view withMessage:@"Sending promo code...."];
            [indicatorView startAnimating];
            [self submitPromoThread];
            //[NSThread detachNewThreadSelector:@selector(submitPromoThread) toTarget:self withObject:nil];
        }else {
            [self.view removeFromSuperview];;
        }
    }
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
        self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    if( returnString!= nil && ![returnString isEqualToString:@""]){
		if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
			RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
			[alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
			[alert release];
		}
        else {
			if ([returnString isEqualToString:@"401"]) {
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                [alert release];
            }
            else{
                NSDictionary *response= [returnString JSONValue];
                BOOL status= [[response objectForKey:@"status"] boolValue];
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
                
                if (!status){
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                    [alert release];
                    
                }else {
                    BOOL stackable = [[response objectForKey:@"stackable"] boolValue];
                    if(stackable){
                        
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                        [alert release];
                    }else{
                        forceValue = YES;
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm" , nil];
                        alert.tag = 106;
                        [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                        [alert release];
                    }
                }
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
    
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
}

- (void) requestNetworkError {
    self.view.userInteractionEnabled = YES;
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate=(MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setNeedsStatusBarAppearanceUpdate];
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
		MainLogin *login=[[MainLogin alloc] init];
		[self.navigationController pushViewController:login animated:YES];
		[login release];
	}
    
    [txtPromoCode setAutocorrectionType:UITextAutocorrectionTypeNo];
    enterbtn.enabled = FALSE;
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload{
    [lbltitlepage release];
    lbltitlepage = nil;
    [contactlbl release];
    contactlbl = nil;
    [enterbtn release];
    enterbtn = nil;
    [formFieldCode release];
    formFieldCode = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[promoCode release];
    [lbltitlepage release];
    [contactlbl release];
    [enterbtn release];
    [formFieldCode release];
    [lblPromoEnter release];
    [super dealloc];
}


@end
