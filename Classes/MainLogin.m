//
//  MainLogin.m
//  Raising Canes
//
//  Created by Zeeshan Akhtar on 7/28/12.
//  Copyright (c) 2012 Zapine Technologies. All rights reserved.
//

#import "MainLogin.h"
#import "LocationSignUp.h"
#import "LocationLogin.h"
#import "TermsOfUserViewController.h"
#import "MainAppDelegate.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "OptionPromo.h"
#import "ChangePassword.h"
#import "ReferAFriend.h"
#import "RXCustomTabBar.h"
#import "ForgotPassViewController.h"
#import "FacebookLoginViewController.h"

@implementation MainLogin
@synthesize firstLbl;
@synthesize secondLbl;
@synthesize thirdLbl;
@synthesize forthLbl;
@synthesize fifthLbl;
@synthesize titlelbl;

-(void)viewWillAppear:(BOOL)animated{
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        if(self.navigationController.viewControllers.count > 1) {
            if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[OptionPromo class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
        // Reset Password in Settings - Back Case Handling
        if(self.navigationController.viewControllers.count > 2) {
            if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[ChangePassword class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }
        }
        
        if(self.navigationController.viewControllers.count > 2) {
            if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[ReferAFriend class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                return;
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    
    // initalize slider view
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
}

- (void)viewDidUnload
{
    [self setFirstLbl:nil];
    [self setSecondLbl:nil];
    [self setThirdLbl:nil];
    [self setForthLbl:nil];
    [self setFifthLbl:nil];
    [self setTitlelbl:nil];
    [agreeLbl release];
    agreeLbl = nil;
    [mellowkarmmaLbl release];
    mellowkarmmaLbl = nil;
    [welcomeLbl release];
    welcomeLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if(sender.tag == 100) {
        [self facebookButtonPressed];
    } else if(sender.tag == 200) {
        LocationSignUp *signUpView= [[LocationSignUp alloc] init];
        signUpView.delegate = _delegate;
        [self.navigationController pushViewController:signUpView animated:NO];
        [signUpView release];
    } else if(sender.tag == 300) {
        LocationLogin *loginView = [[LocationLogin alloc] init];
        loginView.delegate = _delegate;
        [self.navigationController pushViewController:loginView animated:NO];
        [loginView release];
    } else if(sender.tag == 400) {
        TermsOfUserViewController *term= [[TermsOfUserViewController alloc] init];
        term.urlAddress = [TERMS_OF_USE stringByAppendingString:APPKEY];;
        term.titleTxt =@"TERMS OF USE";
        [self.navigationController pushViewController:term animated:NO];
        [term release];
    } else if(sender.tag == 500) {
        TermsOfUserViewController *term= [[TermsOfUserViewController alloc] init];
        term.urlAddress = [PRIVACY_POLICY stringByAppendingString:APPKEY];;
        term.titleTxt =@"PRIVACY POLICY";
        [self.navigationController pushViewController:term animated:NO];
        [term release];
    }
}

-(void) facebookButtonPressed {
        FacebookLoginViewController *loginView = [[FacebookLoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
        [loginView release];
}

- (void) threadStartAnimating {
    [indicatorView startAnimating];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
        NSLog(@" coming here sir for u !!!!!!");
        //[self.navigationController.tabBarController setSelectedIndex:2];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (IBAction)backButtonPressed {
    
    if(self.navigationController.viewControllers.count > 1) {
        if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[OptionPromo class]]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
    }
    
    if(self.navigationController.viewControllers.count > 2) {
        if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[ChangePassword class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
            return;
        }
    }
    
    if(self.navigationController.viewControllers.count > 2) {
        if([[self.navigationController.viewControllers objectAtIndex:2] isKindOfClass:[ReferAFriend class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
            return;
        }
    }
    
    if(self.navigationController.viewControllers.count > 1) {
        if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[ReferAFriend class]]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            return;
        }
    }
    
    /*if(self.navigationController.viewControllers.count > 1) {
     if([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[getSocial class]]) {
     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
     return;
     }
     }*/
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginback"] isEqualToString:@"1"]){
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]!=-1){
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(IBAction) forgotPassButtonPress:(id)sender{
    
    ForgotPassViewController *forgot=[[ForgotPassViewController alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:forgot animated:NO];
    [forgot autorelease];
}

- (void)dealloc {
    [firstLbl release];
    [secondLbl release];
    [thirdLbl release];
    [forthLbl release];
    [fifthLbl release];
    [titlelbl release];
    [agreeLbl release];
    [mellowkarmmaLbl release];
    [welcomeLbl release];
    [forgotLbl release];
    [super dealloc];
}
@end
