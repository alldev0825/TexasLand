//
//  LocationSubmit.h
//  Raising Canes
//
//  Created by Devceloper on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offers.h"
@class MainAppDelegate;
@interface skipSurvey : UIViewController {
    	MainAppDelegate *appDelegate;
        BOOL cancelled;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *lblpagetitle;
}

- (id) initWithOffer: (Offers *) offerObj filename: (NSString *) timestamp image: (UIImage *)imageObj;
- (IBAction)cancelButtonPressed;
- (IBAction)myRewardsButtonPressed;
-(void) updateProgressView;
- (void) startSubmitThread;

@end
