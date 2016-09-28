//
//  RewardMain.h
//  
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "GAITrackedViewController.h"

@class MainAppDelegate;
@interface RewardMain : UIViewController <ServerProtocol,MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>{
    
	MainAppDelegate *appDelegate;
	NSMutableArray *mainArray;
	NSMutableArray *userRewardsArray;
	IBOutlet UITableView *rewardsTable;
    IBOutlet UIButton *backBtn;
	IBOutlet UIActivityIndicatorView *indicatorView;
    NSMutableArray *activityArray;
    BOOL isActiveReward;
	UIImageView *expDelImage;
	float reloadCounter;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;
     NSInteger rewardIndex;

    NSUserDefaults* defaults;
    
}

- (IBAction)backBtnAction:(id)sender;
@end
