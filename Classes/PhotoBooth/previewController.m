//
//  HomeScreenViewC.m
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "previewController.h"
#import "RXCustomTabBar.h"
#import "Constants.h"
#import "MainAppDelegate.h"
#import "CustomCollectionViewCellZoes.h"
#import "shareController.h"


@interface previewController ()
{
    NSArray *frameArray;
    NSArray *topFrameArray;
}
@end

@implementation previewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)nextBtnPressed:(id)sender {
    
    shareController *sharingVC = [[shareController alloc]init];
    sharingVC.tempImage = [self getImageFromView:self.imageView];
    [self.navigationController pushViewController:sharingVC animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.pictureVw.image = [previewController squareImageWithImage:self.capturedImage scaledToSize:self.pictureVw.frame.size];
}

-(void) viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
    NSIndexPath *indexPth = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPth animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}



- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view from its nib.
    
    [self setNeedsStatusBarAppearanceUpdate];
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    
    frameArray = @[@"frame1.png",@"frame2.png",@"frame3.png",@"frame4.png"];
    topFrameArray = @[@"background-frame1.png",@"background-frame2.png",@"Background-frames.png",@"background-frame4.png"];
    self.frameImage.image = [UIImage imageNamed:@"Background-frames.png"];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
//        _imageView.frame = CGRectMake(10, 0, 240, 240);
        
        CGRect imageViewframe = _imageView.frame;
        imageViewframe.size.height = 230; // new y coordinate
        imageViewframe.size.width = 230; // new y coordinate
        imageViewframe.origin.x = 45; // new y coordinate
        _imageView.frame = imageViewframe;
        
        _frameImage.frame = CGRectMake(0, 0, 230, 230);
        _pictureVw.frame = CGRectMake(25, 20, 190, 210);
    }
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCellZoes"];
    
     [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCellZoes" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionViewCellZoes"];
    


}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark-UICOLLECTIONVIEW
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [frameArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CustomCollectionViewCellZoes *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCellZoes" forIndexPath:indexPath];
    
    NSString *name = [frameArray objectAtIndex:indexPath.item];
    
    cell.image.image = [UIImage imageNamed:name];;

    
    if (cell.selected) {
        //cell.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0];
        cell.backgroundColor = [Utils colorWithHexString:@"7C8724"];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCellZoes*cell = (CustomCollectionViewCellZoes*)[collectionView cellForItemAtIndexPath:indexPath];
    
    // cell.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0];
    cell.backgroundColor = [Utils colorWithHexString:@"7C8724"];
    self.frameImage.image = [UIImage imageNamed:[topFrameArray objectAtIndex:indexPath.row]];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionViewCellZoes*cell = (CustomCollectionViewCellZoes*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    
}

-(void)ShowAlertWithMessage:(NSString *)message
{
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

//    [super dealloc];
}

-(UIImage*)getImageFromView:(UIView*)view123
{
    UIGraphicsBeginImageContextWithOptions(view123.bounds.size, view123.opaque, 0.0);
    [view123.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    view123.backgroundColor=[UIColor whiteColor];
    
    return img;
    
}

+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
