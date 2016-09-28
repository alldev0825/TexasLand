//
//  HomeScreenViewC.m
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "shareController.h"
#import "RXCustomTabBar.h"
#import "Constants.h"
#import "MainAppDelegate.h"
#import "CustomCollectionViewCellZoes.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>

#import "MBProgressHUD.h"


#define APP ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface shareController (){
    ALAssetsLibrary *library;
}

@property(nonatomic, strong) UIDocumentInteractionController* docController;
@end

@implementation shareController

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

- (void)viewWillAppear:(BOOL)animated {
    [self getShareSocial];
}

-(void) viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
        [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        _pictureImage.frame = CGRectMake(45, 0, 230, 230);
    }
    
    self.pictureImage.image = self.tempImage;
    
    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
    [tabBar initializeSliderView:self.view];
    
    [self.navigationController setNavigationBarHidden:YES];
    

}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)twitterBtnPressed:(id)sender {
    
    if(self.pictureImage!=NULL)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [controller setInitialText:self.textBodytwitter];
            
            NSData* imageDataTest =  UIImagePNGRepresentation(self.pictureImage.image);     // get png representation
            UIImage* pngImage = [UIImage imageWithData:imageDataTest];
            
            [controller addImage:pngImage];
            [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                [self dismissViewControllerAnimated:YES completion:nil];
                switch (result) {
                    case SLComposeViewControllerResultCancelled:{
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been cancelled!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                        break;
                    case SLComposeViewControllerResultDone:{
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been posted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
            [self presentViewController:controller animated:YES completion:Nil];
        }else{
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                            message:@"There are no Twitter accounts configured. You can add or create a Twitter accounts in Settings"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    };
}

- (IBAction)InstagramBtnPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"instagramCheck"];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSData* imageData =  UIImagePNGRepresentation(self.pictureImage.image);     // get png representation
        UIImage* pngImage = [UIImage imageWithData:imageData];
        
        UIImage* instaImage = pngImage;
        NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        [UIImagePNGRepresentation(instaImage) writeToFile:imagePath atomically:YES];
        NSString* captionString = self.textBodyinsta;
        self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
        self.docController.delegate = self;
        self.docController.UTI = @"com.instagram.exclusivegram";
        self.docController.annotation = [NSDictionary dictionaryWithObject: captionString forKey:@"InstagramCaption"];
        [self.docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:NO];
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@""
                                                        message:@"This feature is not supported on this device. Please install the Instagram app to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
    self.view.userInteractionEnabled = YES;
    [loader setHidden:YES];
    [loader stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
        self.view.userInteractionEnabled = YES;
    [loader setHidden:YES];
    [loader stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)getShareSocial{
        self.view.userInteractionEnabled = NO;
    [loader setHidden:NO];
    [loader startAnimating];
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    //  autToken = @"";
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[NSNumber numberWithInt:kgetSocialShare], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kgetSocialShare;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

- (IBAction)nextBtnPressed:(id)sender {
    [self SaveImage:self.pictureImage.image];
}

-(void)ShowAlertWithMessage:(NSString *)message
{
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)SaveImage:(UIImage*)image
{
    NSData* imageData =  UIImagePNGRepresentation(image);     // get png representation
    UIImage* pngImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(pngImage,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        [self ShowAlertWithMessage:@"Image is Saved Successfully"];
    }
    else{
        NSLog(@"errrorrrrr --------- %@", error);
        [self ShowAlertWithMessage:@"To enable photo access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Photos' till it's green."];
    }
}

- (void) requestFinished:(NSString * )returnString {
        self.view.userInteractionEnabled = YES;
    [loader setHidden:YES];
    [loader stopAnimating];
    
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }else{
                NSDictionary *response= [returnString JSONValue];
                BOOL status= [[response objectForKey:@"status"] boolValue];
            NSLog(@"reponse of get share texts : %@", response);
                if (status){
                    self.textBodyfb = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"facebook_share_text"]];
                    self.textBodytwitter = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"twitter_share_text"]];
                    self.textBodyinsta = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"instagram_share_text"]];
                    self.textBodymail = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"program_description"]];
                    
                }
        }
    }
}


- (IBAction)faceBookBtnPressed:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *fb = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fb setInitialText:self.textBodyfb];
        
        NSData* imageData =  UIImagePNGRepresentation(self.pictureImage.image);     // get png representation
        UIImage* pngImage = [UIImage imageWithData:imageData];
        
        [fb addImage:pngImage];
        [self presentViewController:fb animated:NO completion:nil];
        [fb setCompletionHandler:^(SLComposeViewControllerResult result) {
            [fb dismissViewControllerAnimated:YES completion:nil];
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your Post has been cancelled!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                }
                case SLComposeViewControllerResultDone:
                {
                    if(result == SLComposeViewControllerResultDone) {
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"Your post has been shared!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"No Facebook Accounts"
                                                        message:@"There are no Facebook accounts configured. You can add or create a Facebook accounts in Settings"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)emailBtnPressed:(id)sender {
    
//    mail *composemail = [[mail alloc]init];
//    [self.navigationController pushViewController:composemail animated:NO];
//    [composemail release];
    
//    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
//    [tabBar showContactUs];

    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        //find atleast one email account is set up
        if([MFMailComposeViewController canSendMail])
        {
            
            MFMailComposeViewController *controller = [MFMailComposeViewController new];
            [controller setMessageBody:self.textBodymail isHTML:NO];
            [controller setSubject:self.textBodymail];
            //===Replace following (LINK) with app's store url of Dubblen App.
            [controller setMessageBody:self.description isHTML:YES];
            [controller setToRecipients:[NSArray arrayWithObjects:nil,nil]];
            
            NSData* imageDataTest =  UIImagePNGRepresentation(self.pictureImage.image);     // get png representation
            UIImage* pngImage = [UIImage imageWithData:imageDataTest];
            
            UIImage *imageToSend= pngImage;
            NSData *imageData=UIImagePNGRepresentation(imageToSend);
            [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"Texas Land & Cattle.png"];
            
//            NSArray *filepart = [@"image.png" componentsSeparatedByString:@"."];
//            NSString *filename = [filepart objectAtIndex:0];
//            NSString *extension = [filepart objectAtIndex:1];
//            
//            // Get the resource path and //read the file using NSData
//            //   NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
//            
//            NSData *imageData = UIImagePNGRepresentation(self.pictureImage.image);
//            
//            NSString *mimeType;
//            if ([extension isEqualToString:@"jpg"]) {
//                mimeType = @"image/jpeg";
//            } else if ([extension isEqualToString:@"png"]) {
//                mimeType = @"image/png";
//            } else if ([extension isEqualToString:@"doc"]) {
//                mimeType = @"application/msword";
//            } else if ([extension isEqualToString:@"ppt"]) {
//                mimeType = @"application/vnd.ms-powerpoint";
//            } else if ([extension isEqualToString:@"html"]) {
//                mimeType = @"text/html";
//            } else if ([extension isEqualToString:@"pdf"]) {
//                mimeType = @"application/pdf";
//            }
            
            // Add attachment
//            [controller addAttachmentData:imageData mimeType:mimeType fileName:filename];

            controller.navigationBar.tintColor = [UIColor grayColor];
            controller.delegate = self;
            [controller setMailComposeDelegate:self];
            controller.navigationBar.tintColor = [UIColor colorWithRed:177/255.0 green:9/255.0  blue:25/255.0  alpha:1.0];
            [self.view addSubview:controller.view];

            
        }
        else
        {
            //display the alert that set up an email account
            RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"ALERT !" message:@"Please set up your email account on device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView1 show];
            [alertView1 release];
        }
        
    }
    else
    {
        //display the alert that email account not available
        RMUIAlertView *alertView1 = [[RMUIAlertView alloc] initWithTitle:@"ALERT !" message:@"No valid email account available on device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView1 show];
        [alertView1 release];
        
    }

//    if([MFMailComposeViewController canSendMail]) {
//        
//        appDelegate.globalMailComposer.mailComposeDelegate = self;
//        [appDelegate.globalMailComposer setSubject:self.textBodymail];
//        
//        // Determine the file name and extension
//        NSArray *filepart = [@"image.png" componentsSeparatedByString:@"."];
//        NSString *filename = [filepart objectAtIndex:0];
//        NSString *extension = [filepart objectAtIndex:1];
//        
//        // Get the resource path and //read the file using NSData
//        //   NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
//        
//        NSData *imageData = UIImagePNGRepresentation(self.pictureImage.image);
//
//        // Determine the MIME type
//        NSString *mimeType;
//        if ([extension isEqualToString:@"jpg"]) {
//            mimeType = @"image/jpeg";
//        } else if ([extension isEqualToString:@"png"]) {
//            mimeType = @"image/png";
//        } else if ([extension isEqualToString:@"doc"]) {
//            mimeType = @"application/msword";
//        } else if ([extension isEqualToString:@"ppt"]) {
//            mimeType = @"application/vnd.ms-powerpoint";
//        } else if ([extension isEqualToString:@"html"]) {
//            mimeType = @"text/html";
//        } else if ([extension isEqualToString:@"pdf"]) {
//            mimeType = @"application/pdf";
//        }
//        
//        // Add attachment
//        [appDelegate.globalMailComposer addAttachmentData:imageData mimeType:mimeType fileName:filename];
//        
//        [self.navigationController presentViewController:appDelegate.globalMailComposer animated:YES completion:nil];
//    }
//    else
//    {
//        [self ShowAlertWithMessage:@"Please set up your email account on device."];
//        [appDelegate cycleTheGlobalMailComposer];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSString *message = @"";
    switch (result) {
            
        case MFMailComposeResultCancelled:
            message = @"Your message has been cancelled!";
            break;
        case MFMailComposeResultSaved:
            message = @"Your message has been saved!";
            break;
        case MFMailComposeResultSent:
            message = @"Your message has been sent!";
            break;
        case MFMailComposeResultFailed:
            message = @"Email Failed";
            break;
        default:
            message = @"Email Not Sent";
            break;
    }
    
    [self ShowAlertWithMessage:message];
    
//    RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
//    [tabBar selectTab:0];
//    [controller dismissViewControllerAnimated:NO completion:^{
//        [appDelegate cycleTheGlobalMailComposer];}
//     ];
    
    [controller.view removeFromSuperview];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [loader release];

//    [super dealloc];
}

@end
