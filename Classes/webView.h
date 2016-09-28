//
//  TermsOfUserViewController.h
//  
//
//  Created by User2 on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAppDelegate.h"

@class MainAppDelegate;
@interface webView : UIViewController{
    MainAppDelegate *appDelegate;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UIWebView *webViewTerm;
    IBOutlet UIButton *btnBack;
    NSString *urlAddress ;
    NSString *showBackBtn;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *forwardBtn;
    IBOutlet UIButton *refreshBtn;
    
        NSString *titleTxt;
    
    IBOutlet UILabel *lblTitle;
}

@property(nonatomic, retain) UIWebView *webViewTerm;
@property(nonatomic, retain) NSString *urlAddress;
@property(nonatomic, retain) NSString *titleTxt;
@property(nonatomic, retain) NSString *showBackBtn;

-(IBAction) backButtonPressed;
@end
