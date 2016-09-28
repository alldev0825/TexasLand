//
//  OptionHowTo.m
//
//
#import "getSocial.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "MainAppDelegate.h"
#import "MainLogin.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@interface getSocial ()
@property(nonatomic, strong) UIDocumentInteractionController* docController;
@end

@implementation getSocial

-(IBAction) backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) needMoreButtonAction{
    appDelegate.tabIndex = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reward" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"status"]];
}

- (void) viewDidLayoutSubviews {
    // only works for iOS 7+
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        // snaps the view under the status bar (iOS 6 style)
        viewBounds.origin.y = topBarOffset * -1;
        
        // shrink the bounds of your view to compensate for the offset
        viewBounds.size.height = viewBounds.size.height ;
        self.view.bounds = viewBounds;
        
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            self.view.frame = CGRectMake(0, 0, viewBounds.size.width , 500);
        }else
            self.view.frame = CGRectMake(0, 0, viewBounds.size.width , 410);
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate =(MainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_ANALYTICS];
    [tracker set:kGAIScreenName
           value:@"Info Tutorial"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [titleLbl setTextColor: [Utils colorWithHexString:@"000000"]];
    [titleLbl setFont:[UIFont fontWithName:@"DIN-Light" size:25]];
    
    [subtitleLbl setTextColor: [Utils colorWithHexString:@"666666"]];
    [subtitleLbl setFont:[UIFont fontWithName:@"DIN-Light" size:15]];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [indicator setColor:[Utils colorWithHexString:@"E06B2C"]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *login = [[MainLogin alloc]init];
        [self.navigationController pushViewController:login animated:NO];
        [login release];
    }else{
        [indicator startAnimating];
        [self getSocialShare];
    }
}

- (void)viewDidUnload {
    [titleLbl release];
    titleLbl = nil;
    [subtitleLbl release];
    subtitleLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [titleLbl release];
    [subtitleLbl release];
    [indicator release];
    [_imgView release];
    [super dealloc];
}

- (IBAction)getSocialBtn:(id)sender {
}

- (IBAction)sharefacebookBtn:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:self.textBodyfb];
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your Post has been canceled!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                }
                    break;
                case SLComposeViewControllerResultDone:{
                    [self postSocialShare:@"1"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your Post has been posted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Accounts"
                                                        message:@"There are no Facebook accounts configured. You can add or create a Facebook accounts in Settings"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
    }
    
}

- (IBAction)tweetItBtn:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [controller setInitialText:self.textBodytwitter];
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            [self dismissModalViewControllerAnimated:YES];
            switch (result) {
                case SLComposeViewControllerResultCancelled:{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been canceled!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                }
                    break;
                case SLComposeViewControllerResultDone:{
                    [self postSocialShare:@"2"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your tweet has been posted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [self presentViewController:controller animated:YES completion:Nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
                                                        message:@"There are no Twitter accounts configured. You can add or create a Twitter accounts in Settings"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
    }
}

- (IBAction)instalBtn:(id)sender {
    
    appDelegate.checkInfo = FALSE;
    //    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    //    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    //    {
    //        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //        picker.delegate = self;
    //        picker.allowsEditing = YES;
    //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //        [self presentViewController:picker animated:YES completion:NULL];
    //    }else{
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
    //                                                        message:@"This feature is not supported on this device. Please install the Instagram app to continue"
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"OK"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    /*[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
     [alert dismissWithClickedButtonIndex:0 animated:NO];
     }];*/
    //        [alert release];
    //    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"This feature is not supported on this device. Please install the Instagram app to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    _imgView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    appDelegate.checkInfo = TRUE;
    [self postSocialShare:@"3"];
    [self sharetoInstagram];
}

-(UIImage*)thumbnailFromView:(UIView*)_myView withSize:(CGSize)viewsize{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        CGSize newSize = viewsize;
        newSize.height=newSize.height*2;
        newSize.width=newSize.width*2;
        viewsize=newSize;
    }
    
    UIGraphicsBeginImageContext(_myView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    [_myView.layer renderInContext: context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize size = _myView.frame.size;
    CGFloat scale = MAX(viewsize.width / size.width, viewsize.height / size.height);
    
    UIGraphicsBeginImageContext(viewsize);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

-(UIImage*)thumbnailFromView:(UIView*)_myView{
    return [self thumbnailFromView:_myView withSize:_myView.frame.size];
}

-(void) sharetoInstagram{
    
    UIImage* instaImage = _imgView.image;
    NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [UIImagePNGRepresentation(instaImage) writeToFile:imagePath atomically:YES];
    NSString* captionString = self.textBodyinsta;
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    self.docController.delegate = self;
    self.docController.UTI = @"com.instagram.exclusivegram";
    self.docController.annotation = [NSDictionary dictionaryWithObject: captionString forKey:@"InstagramCaption"];
    [self.docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:NO];
    
    //    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
    //    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
    //        [[UIApplication sharedApplication] openURL:instagramURL];
    //    }
}

-(void) postSocialShare:(NSString*) medium{
    rsquestCount = 2;
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",autToken,@"auth_token",medium, @"medium_id",[NSNumber numberWithInt:kPostSocialShare], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kPostSocialShare;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    appDelegate.checkInfo = TRUE;
}

- (void) getSocialShare{
    rsquestCount = 1;
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

- (void) requestFinished:(NSString * )returnString {
    NSLog(@"testing");
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            
        }else{
            if(rsquestCount == 1){
                if ([returnString isEqualToString:@"401"]) {
                    
                    [appDelegate.facebook logout];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authName"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"authData"];
                    
                    NSHTTPCookie *cookie;
                    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    for (cookie in [storage cookies])
                    {
                        NSString* domainName = [cookie domain];
                        NSRange domainRange = [domainName rangeOfString:@"twitter"];
                        if(domainRange.length > 0)
                        {
                            [storage deleteCookie:cookie];
                        }
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else{
                    NSDictionary *response= [returnString JSONValue];
                    BOOL status= [[response objectForKey:@"status"] boolValue];
                    [indicator stopAnimating];
                    [indicator setHidden:YES];
                    if (status){
                        self.textBodyfb = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"facebook_share_text"]];
                        self.textBodytwitter = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"twitter_share_text"]];
                        self.textBodyinsta = [NSMutableString stringWithFormat:@"%@",[response objectForKey:@"instagram_share_text"]];
                    }
                }
            }else{
                if ([returnString isEqualToString:@"401"]) {
                    
                    [appDelegate.facebook logout];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authName"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey: @"authData"];
                    
                    NSHTTPCookie *cookie;
                    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    for (cookie in [storage cookies])
                    {
                        NSString* domainName = [cookie domain];
                        NSRange domainRange = [domainName rangeOfString:@"twitter"];
                        if(domainRange.length > 0)
                        {
                            [storage deleteCookie:cookie];
                        }
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                    
                }else{
                    
                    //                    NSDictionary *response= [returnString JSONValue];
                    //                    NSString *status= [response objectForKey:@"status"];
                    //                        if ([status isEqualToString:@"success"]){
                    //                            //                    [self.navigationController popViewControllerAnimated:YES];
                    //                        }
                }
                
            }
        }
    }
}

#pragma mark -
#pragma mark Server Request Error
- (void) requestError:(NSString * )returnString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

#pragma mark -
#pragma mark Server Network Error
- (void) requestNetworkError {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

@end
