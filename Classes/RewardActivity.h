//
//  RewardActivity.h
//  
//

#import <UIKit/UIKit.h>

@class MainAppDelegate;
@interface RewardActivity : UIViewController <ServerProtocol>{
	IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblTotalPointsTitle;
	
	IBOutlet UITableView * activityTable;
	NSMutableArray *mainArray;
    NSMutableArray *activityArray;
    NSMutableArray *claimedArray;
	MainAppDelegate *appDelegate;
	IBOutlet UILabel *pointsLabel;
    NSString *totPoints;
    ServerRequestType		currentRequestType;
    IBOutlet UIActivityIndicatorView *indicatorView;
    BOOL checkRew;
      NSInteger rsquestCount;
    IBOutlet UILabel *titlePage;
    IBOutlet UILabel *timelbl;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
}
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic,retain) IBOutlet UITableView *activityTable;
@property (nonatomic,retain) IBOutlet UILabel *pointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *lblTotalPointsTitle;
-(IBAction) backButtonAction;
-(IBAction) rewardClaimAction;
-(id) initWithDataArray:(NSMutableArray *)array totalPoint: (NSString *) totalPoint;
@property (retain, nonatomic) IBOutlet UIButton *activityBtn;
@property (retain, nonatomic) IBOutlet UIButton *claimedBtn;

- (IBAction)ClaimedButtonClicked:(UIButton *)sender;
- (IBAction)ActivityButtonClicked:(UIButton *)sender;
@end
