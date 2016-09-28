//
//  OptionList.m
//
//

#import "ContactUsViewController.h"
#import "MainAppDelegate.h"
//#import "FBConnect.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "ChangePassword.h"
#import "OptionPromo.h"
#import "Settings.h"
#import "MainLogin.h"
#import "OptionLocation.h"
#import "webView.h"
#import "FacebookWall.h"
#import "ReferAFriend.h"
#import "getSocial.h"

@implementation ContactUsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
}
-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self showContactUs];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *message = @"";
    switch (result) {
            
        case MFMailComposeResultCancelled:{
            message = @"Your message has been cancelled!";
            /*RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alertView1 dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alertView1 show];
            [alertView1 release];*/
        }
            break;
        case MFMailComposeResultSaved:{
            message = @"Your message has been saved!";
            /*RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alertView1 dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alertView1 show];
            [alertView1 release];*/
        }
            break;
        case MFMailComposeResultSent: {
            /*RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Mail Sent",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alertView1 dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alertView1 show];
            [alertView1 release];*/
        }
            break;
        case MFMailComposeResultFailed:
            message = @"Email Failed";
            break;
        default:
            message = @"Email Not Sent";
            break;
    }
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar selectTab:0];
    
//    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //    [self dismissModalViewControllerAnimated:NO];
}

- (void)showContactUs{
    if (![MFMailComposeViewController canSendMail]) {
        [[[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"No Mail Account Configured",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        
        RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
        [tabBar selectTab:0];
        
        return;
    }
    
    NSLog(@"-=-=-=-=-=-=-=-=-=-=- check");
    
    MFMailComposeViewController *mailCompoeser = [[MFMailComposeViewController alloc] init];
    [mailCompoeser setMailComposeDelegate:self];
    [mailCompoeser setDelegate:self];
    [mailCompoeser setSubject:@"Texas Land & Cattle"];
    NSString *emailBody  = nil;

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"])
    {
        emailBody = [NSString stringWithFormat:@"\n\n\n\n------------------------------------------------\n- %@ ios  %@\n- app version %@\n- email signed up with : %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]];
    }
    else
        emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n------------------------------------------------\n-%@ ios  %@\n-app version %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [mailCompoeser setMessageBody:emailBody isHTML:NO];
    
    [mailCompoeser setToRecipients:[NSArray arrayWithObjects:NSLocalizedString(@"Contact Email", @""), nil]];

    [self presentViewController:mailCompoeser animated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
