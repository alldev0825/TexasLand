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
@interface webFaq : UIViewController{
    MainAppDelegate *appDelegate;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UIWebView *webViewTerm;
    NSString *urlAddress ;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *forwardBtn;
    IBOutlet UIButton *refreshBtn;
    
        NSString *titleTxt;
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblEmail;
}

@property(nonatomic, retain) UIWebView *webViewTerm;
@property(nonatomic, retain) NSString *urlAddress;
@property(nonatomic, retain) NSString *titleTxt;

-(IBAction) backButtonPressed;
- (IBAction)emailClick:(id)sender;

- (IBAction)backBtn:(id)sender;
- (IBAction)forwardBtn:(id)sender;
- (IBAction)refreshBtn:(id)sender;
@end
