//
//  ForgotPassViewController.h
//
//
#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"

@class MainAppDelegate;
@interface ForgotPassViewController : UIViewController <ServerProtocol>{
    IBOutlet UILabel *lblTitle;
    IBOutlet UITextField *emailField;
    IBOutlet UIActivityIndicatorView *indicatorView;
    MainAppDelegate *appDelegate;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
    IBOutlet UIButton *enterBtn;
    IBOutlet UIImageView *formFieldEmail;
}

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
-(IBAction) hideKeyboard;
-(IBAction) backButtonPressed;
-(IBAction) sendButtonPressed;
- (IBAction)editingChanged;

@end
