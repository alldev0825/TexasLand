//
//  HomeScreenViewC.h
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainAppDelegate;
@interface previewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>{
    MainAppDelegate *appDelegate;
}

@property (nonatomic,strong) UIImage *capturedImage;

@property (nonatomic,strong) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImage;
@property (weak, nonatomic) IBOutlet UIImageView *pictureVw;
- (IBAction)backBtnPressed:(id)sender;

- (IBAction)topBtnPressed:(id)sender;

- (IBAction)nextBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *imageView;



@end
