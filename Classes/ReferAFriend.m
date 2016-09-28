//
//  RewardClaim.m
//
//

#import "ReferAFriend.h"
#import "MainAppDelegate.h"
#import "RewardClaimedClass.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "JSON.h"
#import <Social/Social.h>
#import "MainLogin.h"
#import <Twitter/Twitter.h>
#include "REComposeViewController.h"
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>

@implementation ReferAFriend
@synthesize mailTitle,mailBody;


#pragma mark -
#pragma mark Back Button Clicked
-(IBAction) backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mailBtn:(id)sender {
    if (![MFMessageComposeViewController canSendText]) {
        [[[RMUIAlertView alloc] initWithTitle:@"Cannot Send Message" message:NSLocalizedString(@"Text messaging is not available",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.body = self.otherMediaTxt;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)msgBtn:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        [[[RMUIAlertView alloc] initWithTitle:@"Error!!!" message:NSLocalizedString(@"No Mail Account Configured",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        return;
    }
    
    appDelegate.checkInfo = FALSE;
    MFMailComposeViewController *mailCompoeser = [[MFMailComposeViewController alloc] init];
    [mailCompoeser setMailComposeDelegate:self];
    [mailCompoeser setDelegate:self];
    [mailCompoeser setSubject:mailTitle];
    [mailCompoeser setMessageBody:mailBody isHTML:NO];
    [mailCompoeser setToRecipients:[NSArray arrayWithObjects:@"", nil]];
    [self presentViewController:mailCompoeser animated:NO completion:nil];
}

- (IBAction)twitBtn:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:self.twitterTxt];
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been cancelled!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                }
                    break;
                case SLComposeViewControllerResultDone:{
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been posted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                        message:@"There are no Twitter accounts configured. You can add or create a Twitter accounts in Settings"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    }
}

- (IBAction)fbBtn:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:self.facebookTxt];
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your Post has been cancelled!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                }
                    break;
                case SLComposeViewControllerResultDone:{
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your Post has been posted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"No Facebook Accounts"
                                                        message:@"There are no Facebook accounts configured. You can add or create a Facebook accounts in Settings"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
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
    [self dismissViewControllerAnimated:NO completion:nil];
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate=(MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.checkRefer = TRUE;
    
    [self setNeedsStatusBarAppearanceUpdate]; 
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *login = [[MainLogin alloc]init];
        [self.navigationController pushViewController:login animated:NO];
        [login release];
	}else
        [self fetchReferral];
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [titlePage release];
    titlePage = nil;
    [spinningWheel release];
    spinningWheel = nil;
    [subTitlePage release];
    subTitlePage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [titlePage release];
    [spinningWheel release];
    [subTitlePage release];
    [super dealloc];
}

-(void) fetchReferral {
    [spinningWheel startAnimating];
    self.view.userInteractionEnabled = NO;
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",[NSNumber numberWithInt:kFetchReferralRequest], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kFetchReferralRequest;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
        self.view.userInteractionEnabled = YES;
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
                
//                [appDelegate.facebook logout];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authName"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"authData"];
                
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies])
                {
                    NSString* domainName = [cookie domain];
                    NSRange domainRange = [domainName rangeOfString:@"twitter"];
                    if(domainRange.length > 0)
                    {
                        [storage deleteCookie:cookie];
                    }
                }
                
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
                    self.mailTitle = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"email_title"]];
                    self.mailBody = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"email_body"]];
                    self.facebookTxt = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"facebook_text"]];
                    self.twitterTxt = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"twitter_text"]];
                    self.otherMediaTxt = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"other_media_text"]];
                }
            }
        }
    }
                    [spinningWheel stopAnimating];
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
        self.view.userInteractionEnabled = YES;
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
        self.view.userInteractionEnabled = YES;
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
    [alert release];
}

@end
