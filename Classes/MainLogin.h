//
//  MainLogin.h
//  Raising Canes
//
//  Created by Devceloper on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect.h"

@class MainAppDelegate;
@protocol MainLoginDelegate;

@interface MainLogin : UIViewController{
    
    IBOutlet UILabel *lblReturningUsersTitle;
    IBOutlet UILabel *welcomeLbl;
    IBOutlet UILabel *signupLbl;
    IBOutlet UIButton *signupBtn;
    
    MainAppDelegate *appDelegate;
    
    IBOutlet UILabel *agreeLbl;
    NSString *username;
    NSDictionary *userInfoDict;
    
    IBOutlet UIActivityIndicatorView * indicatorView;
    IBOutlet UILabel *mellowkarmmaLbl;
    IBOutlet UILabel *forgotLbl;
    IBOutlet UILabel *the;
}
@property(nonatomic, retain) IBOutlet UILabel *lblWelcome, *lblTermsAndConditions;
@property (nonatomic, retain) NSString *username;
@property (retain, nonatomic) IBOutlet UILabel *firstLbl;
@property (retain, nonatomic) IBOutlet UILabel *secondLbl;
@property (retain, nonatomic) IBOutlet UILabel *thirdLbl;
@property (retain, nonatomic) IBOutlet UILabel *forthLbl;
@property (retain, nonatomic) IBOutlet UILabel *fifthLbl;
@property (retain, nonatomic) IBOutlet UILabel *titlelbl;
@property (retain, nonatomic) id<MainLoginDelegate> delegate;


-(void) facebookButtonPressed;
- (IBAction)buttonPressed:(UIButton *)sender;
- (IBAction)backButtonPressed;
- (IBAction)forgotPassButtonPress:(id)sender;

@end


@protocol MainLoginDelegate

- (void)loginOk;
- (void)registerOk;

@end

