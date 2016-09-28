//
//  LauchScreenViewController.h
//  Raising Canes
//
//  Created by Ajay Kumar on 06/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainAppDelegate;
@interface LauchScreenViewController : UIViewController <UITabBarControllerDelegate>{
    
    NSTimer *autoTimer;
    IBOutlet UIImageView *splashImage;
     NSMutableArray *offersArray;
    BOOL didUpdate;
	int checkInt;
    MainAppDelegate *appDelegate;

}
-(void) navigate:(int) index ;
-(void) loadMainPage;
-(void) timerMainMenu : (id) sender;

@end
