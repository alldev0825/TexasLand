//
//  TermsOfUserViewController.m
//  
//
//  Created by User2 on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "webFaq.h"
#import "Constants.h"

@implementation webFaq
@synthesize webViewTerm,urlAddress, titleTxt;

-(IBAction) backButtonPressed{
	[self.navigationController popViewControllerAnimated:YES];
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    return [super initWithNibName:(([[UIScreen mainScreen] bounds].size.height == 480) ? @"webView" : @"webView4inch") bundle:nibBundleOrNil];

}*/

- (IBAction)backBtn:(id)sender {
    if ([webViewTerm canGoBack]){
        forwardBtn.selected = YES;
        [webViewTerm goBack];
    }else{
        forwardBtn.selected = NO;
    }
}

- (IBAction)forwardBtn:(id)sender {
    if ([webViewTerm canGoForward]){
        backBtn.selected = YES;
        [webViewTerm goForward];
    }else{
        backBtn.selected = NO;
    }
}

- (IBAction)refreshBtn:(id)sender {
    [indicatorView startAnimating];
    [webViewTerm loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]]];
}

#pragma mark - View lifecycle


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    appDelegate=(MainAppDelegate *)[[UIApplication sharedApplication] delegate];
        [self setNeedsStatusBarAppearanceUpdate];
    [indicatorView startAnimating];
    //NSString *urlAddress = TERMS_OF_USE;
    [webViewTerm loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]]];
    
    webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
    webViewTerm.opaque = NO;
    webViewTerm.backgroundColor = [UIColor clearColor];    
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
	 webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
}

- (IBAction)emailClick:(id)sender{
    if (![MFMailComposeViewController canSendMail]) {
        [[[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"No Mail Account Configured",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil] show];
        return;
    }
    
    MFMailComposeViewController *mailCompoeser = [[MFMailComposeViewController alloc] init];
    [mailCompoeser setMailComposeDelegate:self];
    [mailCompoeser setDelegate:self];
    [mailCompoeser setSubject:@"I'd like to know..."];
    NSString *emailBody  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"])
    {
        emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n------------------------------------------------\n- %@ ios  %@\n- app version %@\n- email signed up with : %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]];
    }
    else
        emailBody = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n------------------------------------------------\n-%@ ios  %@\n-app version %@", [Utils checkDevice], [[UIDevice currentDevice] systemVersion],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [mailCompoeser setMessageBody:emailBody isHTML:NO];
    [mailCompoeser setToRecipients:[NSArray arrayWithObjects:NSLocalizedString(@"Contact Email", @""), nil]];
    [self presentModalViewController:mailCompoeser animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *message = @"";
    switch (result) {
            
        case MFMailComposeResultCancelled:
            message = @"Your message has been cancelled!";
            break;
        case MFMailComposeResultSaved:
            message = @"Your message has been saved!";
            break;
        case MFMailComposeResultSent: {
            RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Mail Sent",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
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
    [self dismissModalViewControllerAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {
	[indicatorView stopAnimating];
    
    webViewTerm.scrollView.scrollEnabled = YES;
    webViewTerm.scrollView.bounces = NO;
    
    if(![webViewTerm isLoading])
    {
        
        if([webViewTerm canGoBack])
            backBtn.selected = YES;
        else
            backBtn.selected = NO;
        
        
        if ([webViewTerm canGoForward])
            forwardBtn.selected = YES;
        else
            forwardBtn.selected = NO;
        
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[indicatorView stopAnimating];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webViewTerm stopLoading];
    self.webViewTerm.delegate = nil;
}

- (void)viewDidUnload
{
    [backBtn release];
    backBtn = nil;
    [forwardBtn release];
    forwardBtn = nil;
    [refreshBtn release];
    refreshBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
