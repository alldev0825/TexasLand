//
//  ChangePassword.h
//  
//

#import <UIKit/UIKit.h>

@class MainAppDelegate;
@interface ChangePassword : UIViewController <ServerProtocol>{
IBOutlet UITextField *firstNameField, *lastNameField, *passwordField, *repeatField,*oldPassword;
IBOutlet UIActivityIndicatorView *indicatorView;
	IBOutlet UILabel *lblTitle;
	NSString *password;
	MainAppDelegate *appDelegate;
	IBOutlet UIScrollView *scrollView;
    ServerRequestType		currentRequestType;
    IBOutlet UIButton *enterBtn;
    IBOutlet UIImageView *formField1;
    IBOutlet UIImageView *formField2;
    IBOutlet UIImageView *formField3;
}
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
-(IBAction) backButtonAction;
-(IBAction) updateButtonPressed;
-(IBAction) hideKeyboard;

@end
