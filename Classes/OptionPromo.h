//
//  OptionProfile.h
//  VivaLaCrepe
//
//  Created by mac book on 10/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class MainAppDelegate;
@interface OptionPromo : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate,ServerProtocol> {
	IBOutlet UITextField *txtPromoCode;
	IBOutlet UIActivityIndicatorView *indicatorView;
	
	IBOutlet UILabel *lblPromoTitle;
	IBOutlet UILabel *lblPromoSubTitle;
	IBOutlet UILabel *lblNotWorking;
    IBOutlet UILabel *lbltitlepage;
    IBOutlet UILabel *contactlbl;
	
	NSString *promoCode;
	BOOL forceValue;
	MainAppDelegate *appDelegate;
    ServerRequestType		currentRequestType;
    NSInteger rsquestCount;

    IBOutlet UIButton *enterbtn;
    IBOutlet UIImageView *formFieldCode;
    IBOutlet UILabel *lblPromoEnter;
}

- (IBAction)editingChanged;
-(IBAction) backButtonAction;
-(IBAction) sendButtonPressed;
-(IBAction) hideKeyboard;
-(IBAction) showContactUsView;

@end
