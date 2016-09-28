//
//  OptionHowTo.h
//
//
#import <UIKit/UIKit.h>

@class MainAppDelegate;
@interface getSocial : UIViewController<ServerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate> {
    
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *subtitleLbl;
    
    NSMutableString *textBodyfb;
    NSMutableString *textBodytwitter;
    NSMutableString *textBodyinsta;
    
    NSInteger rsquestCount;
    
    ServerRequestType currentRequestType;
    MainAppDelegate *appDelegate;
    IBOutlet UIActivityIndicatorView *indicator;
    
}

- (IBAction)getSocialBtn:(id)sender;
- (IBAction)sharefacebookBtn:(id)sender;
- (IBAction)tweetItBtn:(id)sender;
- (IBAction)instalBtn:(id)sender;

- (void)myMethod;
- (void)myMethod:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, retain) NSMutableString *textBodyfb;
@property (nonatomic, retain) NSMutableString *textBodytwitter;
@property (nonatomic, retain) NSMutableString *textBodyinsta;

@end
