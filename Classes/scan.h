//
//  LocationSubmit.h
//  Raising Canes
//
//  Created by Devceloper on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offers.h"
#import "ZBarSDK.h"
#import "OverlayViewC.h"

@class MainAppDelegate;

@interface scan : UIViewController <ZBarReaderDelegate,UITextFieldDelegate,ServerProtocol,CameraProtocol,UINavigationControllerDelegate> {
    
    MainAppDelegate *appDelegate;
    ServerRequestType currentRequestType;
    ZBarReaderViewController *reader;
    
    NSString *code;
    
    IBOutlet UITextField *barcodeField;
    IBOutlet UIButton *snapBtn, *enterBtn, *btnBack;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIActivityIndicatorView *laoder;
}

- (IBAction)snapBtnAction:(id)sender;
- (IBAction)enterBtnAction:(id)sender;
- (IBAction)backBtn:(id)sender;

-(void)cancelPress;

- (IBAction)editingChanged;

@end
