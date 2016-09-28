//
//  HomeScreenViewC.h
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class MainAppDelegate;
@interface shareController : UIViewController<UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,ServerProtocol,UITabBarControllerDelegate>{
    MainAppDelegate *appDelegate;
    ServerRequestType currentRequestType;
    IBOutlet UIActivityIndicatorView *loader;
}


- (IBAction)backBtnPressed:(id)sender;
- (IBAction)topBtnPressed:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *topBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;


- (IBAction)faceBookBtnPressed:(id)sender;
- (IBAction)twitterBtnPressed:(id)sender;

- (IBAction)InstagramBtnPressed:(id)sender;
- (IBAction)emailBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;
@property (strong, nonatomic) UIImage *tempImage;
@property (strong, nonatomic) IBOutlet UIView *imageVw;

@property (nonatomic, retain) NSMutableString *textBodyfb;
@property (nonatomic, retain) NSMutableString *textBodytwitter;
@property (nonatomic, retain) NSMutableString *textBodyinsta;
@property (nonatomic, retain) NSMutableString *textBodymail;


@end
