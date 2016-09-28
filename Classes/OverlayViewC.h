//
//  OverlayViewC.h
//  ZoesKitchen
//
//  Created by Ajay Kumar on 01/09/12.
//  Copyright (c) 2012 Mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraProtocol
- (void)helpButtonPressed;
- (void)cancelPress;
@end

@interface OverlayViewC : UIViewController {
    
    id<CameraProtocol> delegate;
    IBOutlet UILabel *titlePage;
    IBOutlet UIButton *cancelBtn;
}
@property(retain,nonatomic) id<CameraProtocol> delegate;


- (IBAction)TakePhotoHelpButtonClicked:(UIButton *)sender;

@end
