//
//  RumexCustomTabBar.m
//
//
//  Created by Zeeshan Akhtar on 19/07/2012.
//  Copyright 2012 Zapine Technologies All rights reserved.
//

#import "RXCustomTabBar.h"
#import "Constants.h"
#import "MainAppDelegate.h"
#import "RewardMain.h"
#import "LauchScreenViewController.h"
#import "Settings.h"
#import "OptionLocation.h"
#import "webView.h"
#import "ContactUsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation RXCustomTabBar

@synthesize btn1, btn2, btn3, btn4, btn0;
@synthesize navigationController1;
@synthesize imgViewBackground;

- (void)viewDidAppear:(BOOL)animated {
    [self hideTabBar];
    //[super viewWillAppear:animated];
    //	[self addCustomElements];
    [self selectTab: self.selectedIndex];
}

- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

- (void)selectTab:(int)tabID
{
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    NSLog(@"accessed here: %i", tabID);
    switch(tabID)
    {
        case 0:
            appDelegate.selectedSliderTab = 0;
            if(appDelegate.checkHome == TRUE){
                appDelegate.checkHome = FALSE;
                appDelegate.tabIndex = tabID;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
            }else
                self.selectedIndex = tabID;
            break;
        case 1:
//            if(appDelegate.checkReward == TRUE){
//                appDelegate.checkReward = FALSE;
//                appDelegate.tabIndex = tabID;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
//            }else
//                self.selectedIndex = tabID;
                appDelegate.checkLocation = TRUE;
                self.selectedIndex = tabID;
            break;
            
        case 2:
            if(appDelegate.checkPay == TRUE){
                appDelegate.checkPay = FALSE;
                appDelegate.tabIndex = tabID;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
            }else
                
                self.selectedIndex = tabID;
            break;
        case 4:
            NSLog(@"eaeaa");
            
            if(appDelegate.checkReward == TRUE){
                appDelegate.checkReward = FALSE;
                appDelegate.tabIndex = tabID;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
            }else
                self.selectedIndex = tabID;
            break;
        case 5:
        case 6:
        case 3:
        case 7:
        case 8:
            self.selectedIndex = tabID;
            break;
        

    }
}

-(void)tabBarController:(UITabBarController *) tabBarController didSelectViewController : (UIViewController *)viewController
{   NSLog(@"coming in Did Select View Controller ");
    if([tabBarController selectedIndex]==1){
        //[[tabBarController.viewControllers objectAtIndex:1] popToRootViewControllerAnimated:YES];
    }
    
}
- (void)dealloc {
    [btn0 release];
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [btn4 release];
    [imgViewBackground release];
    [super dealloc];
}


// start slider functions

- (void) sliderPressed : (UIButton *) sender {
    UIView *sliderView = [sender.superview viewWithTag:66666];
    if(sliderView.frame.origin.x == 0)
        [self hideMenu:sliderView];
    else
        [self showMenu:sliderView];
    
}

#pragma mark - animations -
-(void)showMenu: (UIView *) sliderView{
    //        [slideView setHidden:NO];
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.50f
                     animations:^{
                         [sliderView setFrame:CGRectMake(0, sliderView.frame.origin.y, sliderView.frame.size.width, sliderView.frame.size.height)];
                     }
     ];
    
}
-(void)hideMenu: (UIView *) sliderView{
    [UIView animateWithDuration:0.50f
                     animations:^{
                         [sliderView setFrame:CGRectMake(-400, sliderView.frame.origin.y, sliderView.frame.size.width, sliderView.frame.size.height)];
                     }
     
     ];
}


-(void) sliderItemPressed : (UIButton *) sender {
    [self.view endEditing:YES];
    UIView *sliderView = sender.superview.superview;
    appDelegate.selectedSliderTab = (int)sender.tag;
    
    NSLog(@"ea ea ea : %i", (int)sender.tag);
    switch((int)sender.tag){
        case 800:
            [self selectTab:0];
            break;
        
        case 801:
            [self selectTab:1];
            break;
        
        case 802:
            [self selectTab:2];
            break;
        case 803:
            [self selectTab:4];
            break;
        
        case 804:{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if(authStatus == AVAuthorizationStatusAuthorized) {
                    // do your logic
                    [self selectTab:3];
                } else if(authStatus == AVAuthorizationStatusDenied){
                    // denied
//                    [self selectTab:0];
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                    [alert show];
                    
                } else if(authStatus == AVAuthorizationStatusRestricted){
                    // restricted, normally won't happen
//                    [self selectTab:0];
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                    [alert show];
                    
                } else if(authStatus == AVAuthorizationStatusNotDetermined){
                    // not determined?!
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if(granted){
                            [self selectTab:3];
                            NSLog(@"Granted access to %@", AVMediaTypeVideo);
                        } else {
//                            [self selectTab:0];
                            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                            [alert show];
                            NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                        }
                    }];
                } else {
                    // impossible, unknown authorization status
                }
            }else{
                [self selectTab:3];
            }

            break;
        }
        case 805:{
            [self selectTab:5];
            break;
        }
        case 806:{
            [self selectTab:6];
            break;
        }
        case 807:{
            [self selectTab:7];
            break;
        }
        case 808:{
            [self selectTab:8];
            break;
        }
    }
    
    [self hideMenu:sliderView];
}
- (void) initializeSliderView:(UIView *)view{
    
    UIView *sliderView = [[[NSBundle mainBundle] loadNibNamed:@"SlideMenu" owner:self options:nil] lastObject];

    UIButton *sliderBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    
    NSString *menuType = (int)(view.tag == 111) ? @"menu" : @"menu-white";
    [sliderBtn setImage:[UIImage imageNamed:menuType] forState:UIControlStateNormal];
    [sliderBtn addTarget:self action:@selector(sliderPressed:) forControlEvents:UIControlEventTouchUpInside];
    sliderBtn.tag = 66667;
    sliderView.tag = 66666;
    
    
    for(int i=800;i<=808;i++){
        UIButton *buttonSliderMenu = (UIButton *)[sliderView viewWithTag:i];
        [buttonSliderMenu addTarget:self action:@selector(sliderItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    [sliderView setFrame:CGRectMake(-400, 0, screenWidth, screenHeight)];
    
    [view addSubview:sliderView];
    [view addSubview:sliderBtn];
    [self hideMenu:sliderView];
}

// end slider functions

@end
