//
//  LocationSubmit.m
//  Raising Canes
//
//  Created by Zeeshan Akhtar on 7/24/12.
//  Copyright (c) 2012 Zapine Technologies. All rights reserved.
//

#import "successSubmit.h"
#import "Constants.h"
#import "LocationLogin.h"
#import "SurveyFormController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MainAppDelegate.h"
#import "MainLogin.h"
#import "RXCustomTabBar.h"
//#import "GAI.h"
//#import "GAIFields.h"
//#import "GAIDictionaryBuilder.h"
#import "RewardMain.h"

@implementation successSubmit

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    appDelegate =(MainAppDelegate *) [[UIApplication sharedApplication] delegate];
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
}

- (void)viewDidUnload
{
    [titleLbl release];
    titleLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
    [titleLbl release];
    [lblTitlePage release];
    [super dealloc];
}

-(IBAction)cancelButtonPressed{
    appDelegate.tabIndex = 4;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
    cancelled = YES;
}

-(IBAction)myRewardsButtonPressed{
//    appDelegate.tabIndex = 1;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
    
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar selectTab:4];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) updateProgressView {
    
    //  progressView.progressImage = [UIImage imageNamed:@""];
}


@end
