//
//  OptionLocation.h
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offers.h"
//#import "GAITrackedViewController.h"

@class MainAppDelegate;
@interface OptionLocationSignup : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource,ServerProtocol, UITextFieldDelegate> {
    NSMutableArray * offersArray;
    BOOL isSplashLoad;
    BOOL isGPSOn;
    BOOL isLocationOn;
    BOOL isNetworkOn;
    MainAppDelegate *appDelegate;
    ServerRequestType		currentRequestType;
    IBOutlet UIActivityIndicatorView *indicatorView;
    BOOL checkRefral;
    IBOutlet UIButton *goBtn;
    IBOutlet UITextField *searchField;
    IBOutlet UILabel *lbltitle;
    IBOutlet UILabel *subtiltLbl;
    IBOutlet UILabel *findlocation;
    IBOutlet UIImageView *backImg;
    IBOutlet UIButton *backBtn;
}
- (IBAction)goClick:(id)sender;

@property (retain, nonatomic) IBOutlet UITableViewCell *CallUsNowCustomCell;
@property (retain, nonatomic) IBOutlet UITableView *callUsNowTableView;
@property (retain, nonatomic) NSMutableArray *offersArray;
@property (retain, nonatomic) IBOutlet UILabel *headerTitleLbl;
-(IBAction) backButtonAction;
@end
