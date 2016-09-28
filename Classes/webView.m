//
//  TermsOfUserViewController.m
//  
//
//  Created by User2 on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "webView.h"
#import "Constants.h"
#import "HomeScreenViewC.h"

@implementation webView
@synthesize webViewTerm,urlAddress, titleTxt, showBackBtn;

-(IBAction) backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    appDelegate=(MainAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setNeedsStatusBarAppearanceUpdate];
    [indicatorView startAnimating];
    NSLog(@"showBackBtn :%@", showBackBtn);
    if ([showBackBtn isEqualToString:@"TRUE"]) {
        showBackBtn = @"";
        btnBack.hidden = FALSE;
    }else{
        btnBack.hidden = TRUE;
        RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
        [tabBar initializeSliderView:self.view];
    }
    //NSString *urlAddress = TERMS_OF_USE;
    [webViewTerm loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]]];
    
    webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
    webViewTerm.opaque = NO;
    webViewTerm.backgroundColor = [UIColor clearColor];
    
    [lblTitle setText:titleTxt];
    
   
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
        [indicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicatorView stopAnimating];
    webViewTerm.scrollView.scrollEnabled = YES;
    webViewTerm.scrollView.bounces = NO;
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
