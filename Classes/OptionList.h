//
//  OptionList.h
//  
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "FBConnect.h"
//#import "GAITrackedViewController.h"

@class MainAppDelegate;
@interface OptionList : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate ,ServerProtocol> {
	MainAppDelegate *appDelegate;
	IBOutlet UITableView * OptionListTable;
	//UILabel *label;
	BOOL loginCheck;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UILabel *informationLbl;
    IBOutlet UIActivityIndicatorView *loader;
    
        NSString *ClientToken;
        UIWindow *window;
    
}

@property (nonatomic,retain) IBOutlet UITableView * OptionListTable;
@property (nonatomic, copy) NSString *nonce;

- (IBAction)settingsButtonPressed;

@end
