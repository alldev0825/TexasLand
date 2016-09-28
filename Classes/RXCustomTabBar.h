//
//  RumexCustomTabBar.h
//  
//
//  Created by Zeeshan Akhtar on 19/07/2012.
//  Copyright 2012 Zapine Technologies All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@class MainAppDelegate;
@interface RXCustomTabBar : UITabBarController<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate> {
	UIButton *btn0;
	UIButton *btn1;
	UIButton *btn2;
	UIButton *btn3;
	UIButton *btn4;
	MainAppDelegate *appDelegate;
    
	UINavigationController *navigationController1;
    UIView *mainView;
    
}
@property (nonatomic, retain) UIButton *btn0;
@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;
@property (nonatomic, retain) UIImageView *imgViewBackground;
@property (nonatomic, retain) UINavigationController *navigationController1;

-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;
-(void) initializeSliderView:(UIView *)view;
@end
