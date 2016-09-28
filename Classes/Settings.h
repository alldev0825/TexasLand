//
//  Settings.h
//  Raising Canes
//
//  Created by Devceloper on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainAppDelegate;
@interface Settings : UIViewController<UITableViewDelegate, UITableViewDataSource, ServerProtocol> {
    UILabel *label;
    
    IBOutlet UILabel *lblPush;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblResetPassword;
    IBOutlet UILabel *lblLoginStatus;
    
    IBOutlet UISwitch *stPush;
    IBOutlet UISwitch *stLocation;
        ServerRequestType		currentRequestType;
    IBOutlet UITableViewCell *pushNotificationCell;
    IBOutlet UITableViewCell *locationServicesCell;
    IBOutlet UITableViewCell *resetPasswordCell;
    IBOutlet UITableViewCell *accountStatusCell;
     IBOutlet UIActivityIndicatorView *indicatorView;
    MainAppDelegate *appDelegate;
    IBOutlet UITableView *settingsTbl;
    IBOutlet UILabel *titlePage;
}
@property (nonatomic, retain) IBOutlet UILabel *lblPush, *lblLocation, *lblResetPassword, *lblLoginStatus;
@property (nonatomic, retain) IBOutlet UITableViewCell *pushNotificationCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *locationServicesCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *resetPasswordCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *accountStatusCell;


- (IBAction)doneButtonPressed;

- (IBAction)toggleButton:(UISwitch *)sender;
@end
