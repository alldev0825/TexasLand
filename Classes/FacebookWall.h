//
//  FacebookWall.h
//  
//
#import <UIKit/UIKit.h>
//#import "FBConnect.h"

@class MainAppDelegate;
@interface FacebookWall : UIViewController <UIApplicationDelegate, UINavigationControllerDelegate> {

	MainAppDelegate *appDelegate;
    IBOutlet UIActivityIndicatorView *indicatorView;
	IBOutlet UIWebView *webViewFB;
    IBOutlet UIWebView *webViewTwitter;
    IBOutlet UIWebView *webViewInstagram;
    
    IBOutlet UIButton *btFacebook;
    IBOutlet UIButton *btTwitter;
    IBOutlet UIButton *btInstagram;
    
}
@property(nonatomic, retain) UIWebView *webViewFB, *webViewTwitter, *webViewInstagram;
@property (retain, nonatomic) IBOutlet UIButton *forwordButton;
@property (retain, nonatomic) IBOutlet UIButton *backwordButton;
@property (nonatomic, retain) IBOutlet UIButton *btFacebook, *btTwitter, *btInstagram;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)reloadWebPage;
- (IBAction)goBackWebPage;
- (IBAction)goForwardWebPage;
- (IBAction)backBtn:(id)sender;

@end
