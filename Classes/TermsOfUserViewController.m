//
//  TermsOfUserViewController.m
//  
//
//  Created by User2 on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TermsOfUserViewController.h"
#import "Constants.h"
#import "RXCustomTabBar.h"

@implementation TermsOfUserViewController
@synthesize webViewTerm,urlAddress, titleTxt;

-(IBAction) backButtonPressed{
	[self.navigationController popViewControllerAnimated:NO];
    
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



#pragma mark - View lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    [indicatorView startAnimating];
    //NSString *urlAddress = TERMS_OF_USE;
        [self setNeedsStatusBarAppearanceUpdate];
    [webViewTerm loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]]];
    
    webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
    webViewTerm.opaque = NO;
    webViewTerm.backgroundColor = [UIColor clearColor];
    
    [lblTitle setText:titleTxt];
    btnBack.hidden = FALSE;
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView {
    webViewTerm.scrollView.scrollEnabled = NO;
    webViewTerm.scrollView.bounces = NO;
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
