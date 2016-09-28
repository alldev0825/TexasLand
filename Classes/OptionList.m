//
//  OptionList.m
//
//

#import "OptionList.h"
#import "MainAppDelegate.h"
#import "DataAccessLayer.h"
#import "Constants.h"
#import "OptionPromo.h"
#import "Settings.h"
#import "MainLogin.h"
#import "OptionLocation.h"
#import "webView.h"
#import "FacebookWall.h"
#import "ReferAFriend.h"
#import "RewardActivity.h"
#import "SurveyFormController.h"
#import "RXCustomTabBar.h"
#import "webFaq.h"

@interface OptionList ()

@end

@implementation OptionList

const int PROMO_CODE = 0;
const int FAQ = 1;
const int ACTIVIY = 2;
const int CONTACTUS = 3;

@synthesize OptionListTable;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void) viewWillAppear:(BOOL)animated{
    [scrollview setContentSize:CGSizeMake(256, 690)];
    [scrollview setScrollEnabled:YES];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowId;
    rowId = [NSString stringWithFormat:@"cell%ld%@",(long)indexPath.row,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rowId];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *txtLabel=[[[UILabel alloc] initWithFrame:CGRectMake(15, 0,290, 40)] autorelease];
        
        [txtLabel setFont:[UIFont fontWithName:@"UnitedSansCond-Bold" size:20]];
        [txtLabel setTextColor: [Utils colorWithHexString:@"4b3829"]];
        [txtLabel setBackgroundColor:[UIColor clearColor]];
        
        switch (indexPath.row) {
                
            case FAQ:
                [txtLabel setText:@"FAQ"];
                break;
                
            case PROMO_CODE:
                [txtLabel setText:@"PROMO CODE"];
                break;
                
            case ACTIVIY:
                [txtLabel setText:@"ACTIVITY"];
                break;
                
            case CONTACTUS:
                [txtLabel setText:@"CONTACT US"];
                break;
                
            default:
                break;
        }
        
        UIImageView *bgPic = [[[UIImageView alloc] initWithFrame:CGRectMake(15,41,290,1)]autorelease];
        bgPic.backgroundColor = [UIColor lightGrayColor];
        [bgPic setImage:[UIImage imageNamed:@"line-info.png"]];
        UIImageView *arrowPic = [[[UIImageView alloc] initWithFrame:CGRectMake(295,13,9,12)]autorelease];
        [arrowPic setImage:[UIImage imageNamed:@"arrow-sm.png"]];
        [cell.contentView addSubview:arrowPic];
        [cell addSubview:bgPic];
        [cell addSubview:txtLabel];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case FAQ:{
            appDelegate.checkInfo = TRUE;
            webFaq *faq=[[webFaq alloc] init];
            faq.urlAddress = FAQ_URL;
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:faq animated:YES];
            [faq autorelease];
            break;
        }
            
        case PROMO_CODE:
        {
            appDelegate.checkInfo = TRUE;
            OptionPromo *promo=[[OptionPromo alloc] init];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:promo animated:NO];
            [promo autorelease];
            break;
        }
            
        case ACTIVIY:
        {
            appDelegate.checkInfo = TRUE;
            RewardActivity *activity = [[RewardActivity alloc] init];
            [self.navigationController pushViewController:activity animated:NO];
            [activity release];
            break;
        }
     
        case CONTACTUS:
        {
            [self openMail];
            break;
        }
            
        default:
            break;
    }
}

-(void)openMail{
    if (![MFMailComposeViewController canSendMail]) {
        [[[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"No Mail Account Configured",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        return;
    }
    
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
    [self presentViewController:mailCompoeser animated:YES completion:nil];
}

- (IBAction)settingsButtonPressed{
    appDelegate.checkInfo = TRUE;
    Settings *settingsView = [[Settings alloc] init];
    [self.navigationController pushViewController:settingsView animated:NO];
    [settingsView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    appDelegate.checkInfo = TRUE;
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    [loader stopAnimating];

    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
     
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *message = @"";
    switch (result) {
            
        case MFMailComposeResultCancelled:{
            message = @"Your message has been cancelled!";
            RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alertView1 show];
            [alertView1 release];
        }
            break;
        case MFMailComposeResultSaved:
            message = @"Your message has been saved!";
            break;
        case MFMailComposeResultSent: {
            RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Mail Sent",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alertView1 show];
            [alertView1 release];
        }
            break;
        case MFMailComposeResultFailed:
            message = @"Email Failed";
            break;
        default:
            message = @"Email Not Sent";
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    //    [self dismissModalViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [scrollview release];
    scrollview = nil;
    [informationLbl release];
    informationLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [scrollview release];
    [informationLbl release];
    [loader release];
    [super dealloc];
}

@end
