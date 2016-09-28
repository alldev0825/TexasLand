//
//  ViewController.m
//  ImageCapture
//
//  Created by APPLE on 28/02/2015.
//  Copyright (c) 2015 APPLE. All rights reserved.
//

#import "ViewController.h"
#import "previewController.h"
#import "CameraSessionView.h"
#import "RXCustomTabBar.h"
#import "RMUIAlertView.h"

@interface ViewController ()<CACameraSessionDelegate>

@property (nonatomic, strong) CameraSessionView *cameraView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
            [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidAppear:(BOOL)animated
{
     [self launchCamera:nil];
    // [self gotoNextViewWithImage:[UIImage imageNamed:@"123.png"]];
}
- (void)launchCamera:(id)sender {
    
    //Set white status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Instantiate the camera view & assign its frame
    // _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    _cameraView = [[[NSBundle mainBundle] loadNibNamed:@"OverlayViewCam" owner:self options:nil] objectAtIndex:0];
    _cameraView.frame = self.view.frame;
    [_cameraView InitialSetups];
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [self.view addSubview:_cameraView];
    
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    // UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.cameraView removeFromSuperview];
    [self gotoNextViewWithImage:image];
}

-(void)cancelCaptureImage:(UIImage *)image {
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar selectTab:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    //UIImage *image = [[UIImage alloc] initWithData:imageData];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //[self.cameraView removeFromSuperview];
}
-(void)showAlert
{
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"Error" message:@"Sorry Device has no camera" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];

}
-(void)gotoNextViewWithImage:(UIImage *)image
{
    previewController *previewVC = [[previewController alloc]init];
    previewVC.capturedImage = image;
    [self.navigationController pushViewController:previewVC animated:NO];
    [previewVC release];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
