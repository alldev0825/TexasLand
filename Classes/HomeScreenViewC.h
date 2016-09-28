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
#import "KASlideShow.h"

@class MainAppDelegate;
@interface HomeScreenViewC : UIViewController <UITabBarControllerDelegate,ServerProtocol, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, KASlideShowDelegate>{
    MainAppDelegate *appDelegate;
    NSInteger rsquestCount;
    NSInteger showPopup;
    ServerRequestType currentRequestType;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *mainView;
    IBOutlet UILabel *homeLblContent;
    IBOutlet UIImageView *homeDefaultImg;
    IBOutlet KASlideShow *slideshow;
    IBOutlet UIActivityIndicatorView *indicatorView;
    
}
@end
