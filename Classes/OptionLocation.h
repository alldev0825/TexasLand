//
//  OptionLocation.h
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offers.h"

@class MainAppDelegate;
@interface OptionLocation : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource,ServerProtocol, UITextFieldDelegate> {
    NSMutableArray * offersArray;
    BOOL isSplashLoad;
    BOOL isGPSOn;
    BOOL isLocationOn;
    BOOL isNetworkOn;
    MainAppDelegate *appDelegate;
    ServerRequestType currentRequestType;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *titlePage;
    IBOutlet UILabel *headerTitleLbl;
    BOOL checkRefral;
    IBOutlet UITextField *searchTxt;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *findLocationNearby;
    IBOutlet UIButton *goBtn;
    IBOutlet UIImageView *searchImage;

}

@property (retain, nonatomic) IBOutlet UITableViewCell *CallUsNowCustomCell;
@property (retain, nonatomic) IBOutlet UITableView *callUsNowTableView;
@property (retain, nonatomic) NSMutableArray *offersArray;

@property (nonatomic) BOOL redirectToOrderSummary;

-(IBAction) backButtonAction;
@end
