//
//  RewardClaim.h
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UILabel+FormattedText.h"

@class MainAppDelegate;
@class Reward;
@interface RewardClaim : UIViewController <MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,ServerProtocol,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIDocumentInteractionControllerDelegate> {
    IBOutlet UIButton *btBack;
    Reward *reward;
    MainAppDelegate *appDelegate;
    IBOutlet UIButton *claimButton;
    IBOutlet UIActivityIndicatorView *indicatorView;
    IBOutlet UILabel *titleReward, *titleReward2;
    
    NSString *restId;
    NSTimer *timer;
    int timerCounter;
    BOOL timerStart;
    BOOL gifted;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
    NSInteger claimBtnAction;
    BOOL rewardClaimBool;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UILabel *contentText;
    IBOutlet UILabel *purchaseText;
    IBOutlet UILabel *fintText;
    IBOutlet UILabel *codeTxt;
    IBOutlet UILabel *pageTitle, *btmContentText;
    IBOutlet UIImageView *barcodeImage;
    IBOutlet UIImageView *redeemWhiteBg, *redeemBg;
    IBOutlet UIButton *redeemedbtn;
    
    IBOutlet UIView *redeemView, *redeemedView;
    
    NSMutableString *textBodytwitter;
    NSMutableString *otherMediaTxt;
    NSMutableString *textBodyInstagram;
}
@property (retain, nonatomic) IBOutlet UIImageView *imgView;

-(IBAction) rewardClaimedAction;
-(IBAction) backButtonAction;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareMail:(id)sender;
- (IBAction)shareInstagram:(id)sender;

-(id) initWithReward:(Reward *) r;
- (IBAction)redeemedbtnAction:(id)sender;
@property (nonatomic, retain) NSMutableString *textBodyfb;
@property (nonatomic, retain) NSMutableString *otherMediaTxt;
@property (nonatomic, retain) NSMutableString *textBodytwitter;
@property (nonatomic, retain) NSMutableString *textBodyInstagram;
@property (nonatomic, strong) ACAccountStore *accountStore;

@property (assign, nonatomic) BOOL gifted;
@end