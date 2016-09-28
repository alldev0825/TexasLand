//
//  LocationLogin.h
//  
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "SBJSON.h"
//#import "FBConnect.h"
#import "RMUIAlertView.h"
// ADDED 03/18/2015 Ibrahim B
// Delegate so referring UI know about login
@protocol MainLoginDelegate;

@class MainAppDelegate;
@class Facebook;
@interface LocationLogin : UIViewController <ServerProtocol,UIAlertViewDelegate, UIGestureRecognizerDelegate>{
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblForgetPassword;
    
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
    IBOutlet UIActivityIndicatorView * indicatorView;
	NSString *username;
	NSString *password;
	NSDictionary *userInfoDict;
	BOOL success;
	MainAppDelegate *appDelegate;
	Facebook *facebook;
    
	NSString *twitterUserName;
    NSString *twitterId, *emailId,*city,*firstName,*lastName;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
    IBOutlet UIImageView *formFieldEmail;
    IBOutlet UIImageView *formFieldPwd;
    IBOutlet UIButton *fbBtn;
    BOOL checkAlert;
    BOOL checkFblogin;
    IBOutlet UIScrollView *scrollView;
}

-(IBAction)fbBtnAction:(id)sender;

// ADDED 03/18/2015 Ibrahim B
// Delegate so referring UI know about login
@property(assign, nonatomic) id<MainLoginDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property(nonatomic,retain) NSString *twitterId, *emailId,*city,*firstName,*lastName , *username , *password;
@property(nonatomic, retain) IBOutlet UILabel *lblTitle, *lblForgetPassword;

-(IBAction) logInButtonPressed;
-(IBAction) backButtonAction;
-(IBAction) hideKeyboard;
-(IBAction) forgotPassButtonPress;

-(void) updateStream:(id)sender;
-(void) submitLogInData : (NSString *) registerType;

- (IBAction)editingChanged;

@end

@protocol LocationLoginDelegate

- (void) loginOk;
- (void) loginFailWithError:(NSError*)error;

@end
