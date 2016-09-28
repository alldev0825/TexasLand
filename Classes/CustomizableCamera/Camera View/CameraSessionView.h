//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

///Protocol Definition
@protocol CACameraSessionDelegate <NSObject, UINavigationControllerDelegate>

@optional - (void)didCaptureImage:(UIImage *)image;
@optional - (void)cancelCaptureImage:(UIImage *)image;
@optional - (void)didCaptureImageWithData:(NSData *)imageData;

@end

@interface CameraSessionView : UIView

//Delegate Property
@property (nonatomic, strong) id <CACameraSessionDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIView *topBarView;
@property (nonatomic, strong) IBOutlet UIView *bottomBarView;
@property (nonatomic, strong) IBOutlet UIView *middleView;

@property (nonatomic, strong) IBOutlet UIButton *crossBtn;
@property (nonatomic, strong) IBOutlet UIButton *captureBtn;
@property (nonatomic, strong) IBOutlet UIButton *toggleBtn;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *heightC;
-(void)InitialSetups;

//API Functions
- (void)setTopBarColor:(UIColor *)topBarColor;
- (void)hideFlashButton;
- (void)hideCameraToogleButton;
- (void)hideDismissButton;

@end
