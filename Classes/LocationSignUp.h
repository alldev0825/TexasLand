//
//  LocationSignUp.h
//  
//

#import <UIKit/UIKit.h>
//#import "FBConnect.h"

@class MainAppDelegate;
@protocol MainLoginDelegate;
@class Facebook;
@interface LocationSignUp : UIViewController <ServerProtocol,UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate,UIAlertViewDelegate>{
	IBOutlet UITextField * usernameField;
	IBOutlet UITextField * passwordField;
    IBOutlet UITextField * firstnameField;
	IBOutlet UITextField * lastnameField;
    IBOutlet UITextField * phonenumberField;
    IBOutlet UITextField * securityField;
    IBOutlet UITextField * answerField;
    IBOutlet UITextField * referField;
    
	IBOutlet UILabel *lblTitle;
	
	NSString *username;
	NSString *password;
	BOOL success;
    NSDictionary *userInfoDict;
    Facebook *facebook;
	IBOutlet UIActivityIndicatorView *indicatorView;
	MainAppDelegate *appDelegate;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
    NSString *birthday;
    NSString *day;
    NSString *month;
    NSString *year;
    
    IBOutlet UIButton *checkBox;
    BOOL checkBoxStatus;
    
    IBOutlet UILabel *lbldesc;
    IBOutlet UIToolbar *dobToolbar;
    IBOutlet UIDatePicker *dobPicker;
    IBOutlet UITextField *dobField;
    
    IBOutlet UIImageView *formFieldEmail;
    IBOutlet UIImageView *formFieldPwd;
    IBOutlet UITextField *locationId;
    UIPickerView *myPickerView;
    UIToolbar *toolbar;
    IBOutlet UITextField *favLocationField;
    
    NSMutableArray *array_from;
    NSMutableArray *array_from_id;
    NSMutableArray * offersArray;
    
    NSString *tempDropId;
    NSString *tempDropName;

    NSString *phoneNum;
}
- (IBAction)editingChanged;
- (IBAction)checkBoxBtn:(id)sender;
- (IBAction)favLocationClick:(id)sender;
- (IBAction)birthdayClick:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic , retain) NSString *username , *password, *phoneNum;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle,*lblTermsOfUse;
@property (nonatomic, assign) id<MainLoginDelegate>delegate;

-(IBAction) signUpButtonPressed;
-(IBAction) backButtonAction;
-(IBAction) hideKeyboard;
-(IBAction) facebookButtonPressed;
-(void) submitSignUpData : (NSString *)registerType;
@end
