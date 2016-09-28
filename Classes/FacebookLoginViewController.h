//
//  FacebookLoginViewController.h
//  Raising Canes
//
//  Created by Ajay Kumar on 10/11/12.
//  Copyright (c) 2012 My company. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
 
@class MainAppDelegate;
@interface FacebookLoginViewController : UIViewController <ServerProtocol,UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>{
    
    MainAppDelegate *appDelegate;
    NSString *username;
	NSDictionary *userInfoDict;
    IBOutlet UIActivityIndicatorView * indicatorView;
    ServerRequestType currentRequestType;
    NSInteger rsquestCount;
  
    UIPickerView *myPickerView;
    UIToolbar *toolbar;
    NSString *birthday;
    IBOutlet UITextField * firstnameField;

    NSString *day;
    NSString *month;
    NSString *year;
    IBOutlet UIButton *signUpButton;
    
    IBOutlet UITextField *locationId;
    IBOutlet UITextField *favLocationField;
    
    IBOutlet UIToolbar *dobToolbar;
    IBOutlet UIDatePicker *dobPicker;
    IBOutlet UITextField *dobField;
    
    IBOutlet UIImageView *formFieldRefer;
    IBOutlet UIImageView *formFieldBirthday;
    
    IBOutlet UILabel *titleLbl;
    IBOutlet UIButton *checkBoxBtn;
    IBOutlet UILabel *descLbl;
    
    BOOL checkBoxStatus;
    BOOL checkFb;
    IBOutlet UIScrollView *scrollView;
}

- (IBAction)dobBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *descLbl;
@property (retain, nonatomic) IBOutlet UITextField *referCodeField;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) NSString *username;

- (IBAction)editingChanged;
- (IBAction)checkBoxBtn:(id)sender;
- (IBAction)favLocationClick:(id)sender;

- (IBAction)FaceBookButtonClicked:(UIButton *)sender;
-(IBAction) backButtonAction;
@end