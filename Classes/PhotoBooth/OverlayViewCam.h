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
@end

@interface OverlayViewCam : UIViewController {
    
    id<CameraProtocol> delegate;
}
@property(retain,nonatomic) id<CameraProtocol> delegate;


- (IBAction)TakePhotoHelpButtonClicked:(UIButton *)sender;

@end
