//
//  LauchScreenViewController.m
//  Raising Canes
//
//  Created by Ajay Kumar on 06/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LauchScreenViewController.h"
#import "MainAppDelegate.h"
#import "RewardMain.h" 
#import "Constants.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "Offers.h"
#import "FacebookWall.h"
#import "RXCustomTabBar.h"
#import "MainLogin.h"
#import "HomeScreenViewC.h"
#import "scan.h"
#import "OptionLocation.h"
#import "Settings.h"
#import "TermsOfUserViewController.h"
#import "ContactUsViewController.h"
#import "ReferAFriend.h"
#import "webView.h"
#import "webFaq.h"
#import "OptionList.h"
#import "ViewController.h"

// @ADDED July 10, 2015 - Ibrahim
// Order History
// @END OF ADDED

@interface LauchScreenViewController ()

@end

@implementation LauchScreenViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    offersArray = [[NSMutableArray alloc] init];
    
    didUpdate = NO;
    checkInt = 0;
    // Do any additional setup after loading the view from its nib.
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerMainMenu:) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigate:) name:@"reward" object:nil];
   
}


#pragma mark -
#pragma mark Timer method
- (void) timerMainMenu : (id)sender{
    
    [self loadMainPage];
    
}	
#pragma mark -
#pragma mark Touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    [self loadMainPage];
}

#pragma mark -
#pragma mark Load main screen

-(void) loadMainPage {
    [autoTimer invalidate];
    autoTimer = nil;
   [self navigate:appDelegate.tabIndex];
}

-(void) navigate:(int) index {
    UINavigationController * homeNavigationController=[[UINavigationController alloc] init];
    UINavigationController * locationNavController=[[UINavigationController alloc] init];
    UINavigationController * scanNavController=[[UINavigationController alloc] init];
    UINavigationController * rewardNavController=[[UINavigationController alloc] init];
    UINavigationController * texasNavController=[[UINavigationController alloc] init];
    UINavigationController * socializeNavController=[[UINavigationController alloc] init];
    UINavigationController * menuNavController=[[UINavigationController alloc] init];
    UINavigationController * referfriendNavController=[[UINavigationController alloc] init];
    UINavigationController * infoNavController=[[UINavigationController alloc] init];
    
    RXCustomTabBar * tabBar=[[RXCustomTabBar alloc] init];
    
        HomeScreenViewC *home=[[HomeScreenViewC alloc] init];
        [homeNavigationController setNavigationBarHidden:YES];
        [homeNavigationController pushViewController:home animated:NO];
        [home release];
    
    ViewController *texas=[[ViewController alloc] init];
    [texasNavController setNavigationBarHidden:YES];
    [texasNavController pushViewController:texas animated:NO];
    [texas release];
    
    
    
    RewardMain *rewards =[[RewardMain alloc] init];
    [rewardNavController setNavigationBarHidden:YES];
    [rewardNavController pushViewController:rewards animated:NO];
    [rewards release];
   
    
    FacebookWall *fb =[[FacebookWall alloc] init];
    [socializeNavController setNavigationBarHidden:YES];
    [socializeNavController pushViewController:fb animated:NO];
    [fb release];
    
    scan *scan2 = [[scan alloc]init];
    [scanNavController setNavigationBarHidden:YES];
    [scanNavController pushViewController:scan2 animated:NO];
    [scan2 release];
    
    OptionLocation *optlocation = [[OptionLocation alloc]init];
    [locationNavController setNavigationBarHidden:YES];
    [locationNavController pushViewController:optlocation animated:NO];
    [optlocation release];
   
    
    ReferAFriend *refer = [[ReferAFriend alloc]init];
    [referfriendNavController setNavigationBarHidden:YES];
    [referfriendNavController pushViewController:refer animated:NO];
    [refer release];
    
    OptionList *info = [[OptionList alloc]init];
    [infoNavController setNavigationBarHidden:YES];
    [infoNavController pushViewController:info animated:NO];
    [info release];
    
    webView *web = [[webView alloc]init];
    web.urlAddress = [NSString stringWithFormat:@"%@", MENU_URL];
    web.titleTxt = @"MENU";
    [menuNavController setNavigationBarHidden:YES];
    [menuNavController pushViewController:web animated:NO];
    [web release];
    
    tabBar.selectedIndex = appDelegate.tabIndex;
    tabBar.viewControllers=[NSArray arrayWithObjects:homeNavigationController, locationNavController, scanNavController,texasNavController, rewardNavController,
                            socializeNavController, menuNavController, referfriendNavController, infoNavController, nil ];
    
    //    [fbWall release];    
    [tabBar setDelegate:self];
    [tabBar setNavigationController1:self.navigationController];	
    
    [self.navigationController pushViewController:tabBar animated:NO];
    
    if(index == 9) {
        index = 0;
    }
    [tabBar setDelegate:self];
    [tabBar setSelectedIndex: appDelegate.tabIndex];
    
}
-(void)tabBarController:(UITabBarController *) tabBarController didSelectViewController : (UIViewController *)viewController
{   NSLog(@"coming in Did Select View Controller ");
    if([tabBarController selectedIndex]==1){
        //[[tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        self = [super initWithNibName:@"LauchScreenViewController3-5Inch" bundle:nibBundleOrNil];
    }
    else
    {
        self = [super initWithNibName:@"LauchScreenViewController" bundle:nibBundleOrNil];

    }
    return self;
}


@end
