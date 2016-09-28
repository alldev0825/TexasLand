//
//  RewardClaim.h
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <messageUI/MFMessageComposeViewController.h>
#import <Accounts/Accounts.h>
#import "UILabel+FormattedText.h"

@class MainAppDelegate;

@interface ReferAFriend : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,ServerProtocol> {
    
    IBOutlet UILabel *headerPage;
    IBOutlet UILabel *titlePage;
    IBOutlet UILabel *subTitlePage;
    IBOutlet UILabel *dash1;
    IBOutlet UILabel *dash2;
    MainAppDelegate *appDelegate;
    NSMutableString *mailTitle;
    NSMutableString *mailBody;
    NSMutableString *facebookTxt;
    NSMutableString *twitterTxt;
    NSMutableString *otherMediaTxt;
    
    ServerRequestType currentRequestType;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIActivityIndicatorView *spinningWheel;
}
@property (nonatomic, retain) NSMutableString *mailTitle;
@property (nonatomic, retain) NSMutableString *mailBody;
@property (nonatomic, retain) NSMutableString *facebookTxt;
@property (nonatomic, retain) NSMutableString *twitterTxt;
@property (nonatomic, retain) NSMutableString *otherMediaTxt;
@property (nonatomic, strong) ACAccountStore *accountStore;

-(IBAction) backButtonAction;
- (IBAction)mailBtn:(id)sender;
- (IBAction)msgBtn:(id)sender;
- (IBAction)twitBtn:(id)sender;
- (IBAction)fbBtn:(id)sender;


@end
