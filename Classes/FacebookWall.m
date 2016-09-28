//
//  FacebookWall.m
//
//

#import "FacebookWall.h"
#import "MainAppDelegate.h"
#import "Constants.h"
#import "RXCustomTabBar.h"

@implementation FacebookWall
@synthesize forwordButton;
@synthesize backwordButton;
@synthesize webViewFB, webViewTwitter, webViewInstagram;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
	appDelegate = (MainAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *fbURLAddress = FB_PAGE_URL;
    NSString *twitterURLAdress = TWITTER_PAGE_URL;
    NSString *instagramURLAdress = INSTAGRAM_URL;
	
	//Create a URL object.
	NSURL *urlFB = [NSURL URLWithString:fbURLAddress];
    NSURL *urlTwitter = [NSURL URLWithString:twitterURLAdress];
    NSURL *urlInstagram = [NSURL URLWithString:instagramURLAdress];
	
	//URL Request Object
	NSURLRequest *fbRequestObj = [NSURLRequest requestWithURL:urlFB];
    NSURLRequest *twitterRequestObj = [NSURLRequest requestWithURL:urlTwitter];
    NSURLRequest *instagramRequestObj = [NSURLRequest requestWithURL:urlTwitter];
	
	[webViewFB loadRequest:fbRequestObj];
   
    self.btFacebook.selected = YES;
    self.webViewTwitter.hidden = YES;
    self.webViewInstagram.hidden = YES;
    self.backwordButton.selected = NO;
    self.forwordButton.selected = NO;
    
    webViewFB.scrollView.scrollEnabled = YES;
    webViewFB.scrollView.bounces = NO;
    [indicatorView startAnimating];
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	NSLog(@"url requested heer is %@",webView.request.mainDocumentURL);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if(![webViewTwitter isLoading])
    {
        [indicatorView stopAnimating];
        if([webViewTwitter canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewFB canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewInstagram canGoBack])
            self.backwordButton.selected = YES;
        else
            self.backwordButton.selected = NO;
        
        if ([webViewTwitter canGoForward])
            self.forwordButton.selected = YES;
        else if ([webViewFB canGoForward])
            self.forwordButton.selected = YES;
        else if([webViewInstagram canGoForward])
            self.backwordButton.selected = YES;
        else
            self.forwordButton.selected = NO;
    }
    else if(![webViewFB isLoading])
    {
        webViewFB.scrollView.scrollEnabled = YES;
        [indicatorView stopAnimating];
        if([webViewFB canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewTwitter canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewInstagram canGoBack])
            self.backwordButton.selected = YES;
        else
            self.backwordButton.selected = NO;
        
        if ([webViewFB canGoForward])
            self.forwordButton.selected = YES;
        else if ([webViewTwitter canGoForward])
            self.forwordButton.selected = YES;
        else if([webViewInstagram canGoForward])
            self.backwordButton.selected = YES;
        else
            self.forwordButton.selected = NO;
        
    }
    else if(![webViewInstagram isLoading])
    {
        [indicatorView stopAnimating];
        if([webViewInstagram canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewFB canGoBack])
            self.backwordButton.selected = YES;
        else if([webViewTwitter canGoBack])
            self.backwordButton.selected = YES;
        else
            self.backwordButton.selected = NO;
        
        if ([webViewInstagram canGoForward])
            self.forwordButton.selected = YES;
        else if ([webViewTwitter canGoForward])
            self.forwordButton.selected = YES;
        else if([webViewTwitter canGoForward])
            self.backwordButton.selected = YES;
        else
            self.forwordButton.selected = NO;
        
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(![webViewTwitter isLoading] && ![webViewFB isLoading] && ![webViewInstagram isLoading])
        [indicatorView stopAnimating];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:NO];
	
	
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)buttonPressed:(id)sender
{
    
    [indicatorView startAnimating];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    self.backwordButton.selected = NO;
    self.forwordButton.selected = NO;
    if([sender tag] == 10) {
        
        webViewFB.scrollView.scrollEnabled = YES;
        
        self.btFacebook.selected = YES;
        self.btTwitter.selected = NO;
        self.btInstagram.selected = NO;
        
        webViewFB.hidden = NO;
        webViewInstagram.hidden = YES;
        webViewTwitter.hidden = YES;
        
        NSString *fbURLAddress = FB_PAGE_URL;
        //Create a URL object.
        NSURL *urlFB = [NSURL URLWithString:fbURLAddress];
        //URL Request Object
        NSURLRequest *fbRequestObj = [NSURLRequest requestWithURL:urlFB];
        //Load the request in the UIWebView.
        [webViewFB loadRequest:fbRequestObj];
        
    } else if ([sender tag] == 20 ){
        
        self.btFacebook.selected = NO;
        self.btTwitter.selected = YES;
        self.btInstagram.selected = NO;
        
        webViewFB.hidden = YES;
        webViewTwitter.hidden = NO;
        webViewInstagram.hidden = YES;
        
        webViewTwitter.scrollView.bounces = NO;
        
        NSString *twitterURLAdress = TWITTER_PAGE_URL;
        NSURL *urlTwitter = [NSURL URLWithString:twitterURLAdress];
        NSURLRequest *twitterRequestObj = [NSURLRequest requestWithURL:urlTwitter];
        [webViewTwitter loadRequest:twitterRequestObj];
    } else if ([sender tag] == 30){
        
        self.btFacebook.selected = NO;
        self.btTwitter.selected = NO;
        self.btInstagram.selected = YES;
        
        webViewFB.hidden = YES;
        webViewTwitter.hidden = YES;
        webViewInstagram.hidden = NO;
        
        webViewInstagram.scrollView.bounces = NO;
        
        NSString *instagramURLAdress = INSTAGRAM_URL;
        NSURL *urlInstagram = [NSURL URLWithString:instagramURLAdress];
        NSURLRequest *instagramRequestObj = [NSURLRequest requestWithURL:urlInstagram];
        [webViewInstagram loadRequest:instagramRequestObj];
    }
}

- (IBAction)reloadWebPage{
    if(self.btFacebook.isSelected) {
        [indicatorView startAnimating];
        NSString *fbURLAddress = FB_PAGE_URL;
        
        NSURL *urlFB = [NSURL URLWithString:fbURLAddress];
        
        NSURLRequest *fbRequestObj = [NSURLRequest requestWithURL:urlFB];
        
        [webViewFB loadRequest:fbRequestObj];
    } else if([self.btTwitter isSelected]){
        [indicatorView startAnimating];
        NSString *fbURLAddress = TWITTER_PAGE_URL;
        
        NSURL *urlFB = [NSURL URLWithString:fbURLAddress];
        
        NSURLRequest *fbRequestObj = [NSURLRequest requestWithURL:urlFB];
        
        [webViewTwitter loadRequest:fbRequestObj];
    } else if([self.btInstagram isSelected]){
        [indicatorView startAnimating];
        NSString *fbURLAddress = INSTAGRAM_URL;
        
        NSURL *urlFB = [NSURL URLWithString:fbURLAddress];
        
        NSURLRequest *fbRequestObj = [NSURLRequest requestWithURL:urlFB];
        
        [webViewInstagram loadRequest:fbRequestObj];
    }
}

- (IBAction)goBackWebPage{
    if([self.btFacebook isSelected]) {
        
        if([webViewFB canGoBack]) {
            self.backwordButton.selected = YES;
            [webViewFB goBack];
        }
        else {
            self.backwordButton.selected = NO;
        }
    } else if([self.btTwitter isSelected]){
        
        if([webViewTwitter canGoBack])
        {
            [webViewTwitter goBack];
            self.backwordButton.selected = YES;
        }
        else {
            self.backwordButton.selected = NO;
        }
    } else if([self.btInstagram isSelected]){
        
        if([webViewInstagram canGoBack])
        {
            [webViewInstagram goBack];
            self.backwordButton.selected = YES;
        }
        else {
            self.backwordButton.selected = NO;
        }
    }
}

- (IBAction)goForwardWebPage{
    if([self.btFacebook isSelected]) {
        // [webViewFB goForward];
        
        if ([webViewFB canGoForward]){
            [webViewFB goForward];
            self.forwordButton.selected = YES;
        }
        else {
            self.forwordButton.selected = NO;
        }
    } else if([self.btTwitter isSelected]){
        
        if ([webViewTwitter canGoForward]){
            [webViewTwitter goForward];
            self.forwordButton.selected = YES;
        }
        else {
            self.forwordButton.selected = NO;
        }
        
    } else if([self.btInstagram isSelected]){
        
        if ([webViewInstagram canGoForward]){
            [webViewInstagram goForward];
            self.forwordButton.selected = YES;
        }
        else {
            self.forwordButton.selected = NO;
        }
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setBackwordButton:nil];
    [self setForwordButton:nil];
    [webViewInstagram release];
    webViewInstagram = nil;
    [btInstagram release];
    btInstagram = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [backwordButton release];
    [forwordButton release];
    [webViewInstagram release];
    [btInstagram release];
    [super dealloc];
}


@end
