//
//  LocationSubmit.m
//  Raising Canes
//
//  Created by Zeeshan Akhtar on 7/24/12.
//  Copyright (c) 2012 Zapine Technologies. All rights reserved.
//

#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MainAppDelegate.h"
#import "MainLogin.h"
#import "RXCustomTabBar.h"
//#import "GAI.h"
//#import "GAIFields.h"
//#import "GAIDictionaryBuilder.h"
#import "SurveyFormController.h"
#import "successSubmit.h"
#import "HomeScreenViewC.h"
#import "scan.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation scan


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    appDelegate =(MainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    barcodeField.delegate = self;
    [enterBtn setEnabled:NO];
    if (self.navigationController.viewControllers.count == 2 && [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[HomeScreenViewC class]]) {
        btnBack.hidden = FALSE;
    }else{
        RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
        [tabBar initializeSliderView:self.view];
        btnBack.hidden = TRUE;
    }
    [scrollView setContentSize:CGSizeMake(256, 550)];
    [scrollView setScrollEnabled:YES];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self appWillEnterForegroundNotification];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void) appWillEnterForegroundNotification{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]==-1){
        MainLogin *signUp=[[MainLogin alloc] init];
        [self.navigationController pushViewController:signUp animated:NO];
        [signUp release];
        NSLog(@"UserId == -1 not making rewards request");
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
    [barcodeField release];
    [snapBtn release];
    [enterBtn release];
    [scrollView release];
    [laoder release];
    [super dealloc];
}

-(void)imagePickerController:(UIImagePickerController *)readerPicker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    NSLog(@"test code =========== %@", symbol.data);
    for(symbol in results){
        code = symbol.data;
        
        NSLog(@"1123 %@", code);
        [readerPicker dismissViewControllerAnimated:NO completion:nil];
        [self PostCode];
        break;
    }
}

-(void)PostCode{

    [laoder startAnimating];
    [enterBtn setEnabled:NO];
    self.view.userInteractionEnabled = NO;
    
    NSString *autToken  = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
    {
        autToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]==[NSNull null]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:autToken,@"auth_token",APPKEY,@"appkey",code, @"barcode",[NSNumber numberWithInt:kPostCode],keyRequestType, nil];
    
    NSLog(@"adic -===========- %@", aDic);
    //    rsquestCount = 2;
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kPostCode;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
    
}

- (IBAction)snapBtnAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"scanTab"];
//    self.view.userInteractionEnabled = NO;
    //    [codeField resignFirstResponder];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
            [self callCamera];
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self callCamera];
                    NSLog(@"Granted access to %@", AVMediaTypeVideo);
                } else {
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:@"To enable camera access, please go to Settings > Texas Land & Cattle > Privacy and slide the button next to 'Camera' till it's green." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                    [alert show];
                    NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                }
            }];
        } else {
            // impossible, unknown authorization status
        }
    }else{
        [self callCamera];
    }
    
}

-(void)callCamera{
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    OverlayViewC *overlay=[[OverlayViewC alloc]initWithNibName:@"OverlayViewC" bundle:nil];
    overlay.delegate = self;
    
    reader.showsZBarControls = NO;
    
    reader.cameraOverlayView = overlay.view;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_QRCODE config: ZBAR_CFG_ENABLE to: 1];
    [scanner setSymbology:ZBAR_CODE39 config:ZBAR_CFG_ENABLE to:1];
    [scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_ENABLE to:1];
    reader.readerView.zoom = 1.0;
    
    appDelegate.checkPay = FALSE;
    [self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)enterBtnAction:(id)sender {
//            SurveyFormController *survey=[[SurveyFormController alloc] initWithSurveyId:@"68" andReceiptId:nil andDealId:nil];
//            [self.navigationController pushViewController:survey animated:YES];
//            [survey release];
    
    [barcodeField resignFirstResponder];
    code = barcodeField.text;
    [self PostCode];
    
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString *)returnString {
    self.view.userInteractionEnabled = YES;
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{

            NSDictionary *response= [returnString JSONValue];
            NSLog(@"response ======= %@", response);
            BOOL status = [[response objectForKey:@"status"] boolValue];
            NSString *notice = [response objectForKey:@"notice"];
            NSString *survey_id = [response objectForKey:@"survey_id"];
            NSString *receipt_id = [response objectForKey:@"receipt_id"];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", survey_id] forKey:@"survey_id"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", receipt_id] forKey:@"receipt_id"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:survey_id forKey:@"survey_id"];
                [[NSUserDefaults standardUserDefaults] setObject:receipt_id forKey:@"receipt_id"];
            }
            NSString *msg = [response objectForKey:@"notice"];
            if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                msg = [response objectForKey:@"message"];
            
            if(!msg)
                msg = SOMETHING_WENT_WRONG;
            if (status){

                if([survey_id isEqual:@""] || !survey_id  || [survey_id isKindOfClass:[NSNull class]]){
                    successSubmit *success = [[successSubmit alloc]init];
                    [self.navigationController pushViewController:success animated:YES];
                    [success release];
                    [reader dismissViewControllerAnimated:NO completion:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scanTab"];
                }else{
                    
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    alert.tag = 2;
                    [alert show];
                    [alert release];
                    
                    appDelegate.checkPay = TRUE;
                }
                
            }else{
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:notice delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                alert.tag = 3;
                [alert show];
                [alert release];
                
                appDelegate.checkPay = TRUE;
            }
            
        }
    }
    [laoder stopAnimating];
    [enterBtn setEnabled:YES];

}

- (IBAction)editingChanged {
    if ([barcodeField.text length] != 0) {
        enterBtn.enabled = YES;
    }
    else {
        enterBtn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

- (void)alertView:(RMUIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if(actionSheet.tag == 2){
        NSString *surveyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"survey_id"];
        NSString *receiptId = [[NSUserDefaults standardUserDefaults] objectForKey:@"receipt_id"];
        
        SurveyFormController *survey=[[SurveyFormController alloc] initWithSurveyId:surveyId andReceiptId:receiptId andDealId:nil];
        [self.navigationController pushViewController:survey animated:YES];
        [survey release];
        
        [reader dismissViewControllerAnimated:NO completion:nil];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scanTab"];
    }else if(actionSheet.tag == 3){
        
        [reader dismissViewControllerAnimated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scanTab"];
    }
}

- (void) requestError:(NSString * )returnString {
    self.view.userInteractionEnabled = YES;
    [laoder stopAnimating];
    [enterBtn setEnabled:YES];

    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) requestNetworkError {
        self.view.userInteractionEnabled = YES;
        [laoder stopAnimating];
        [enterBtn setEnabled:YES];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(void)disableBtn{
    //    if(([barcodeField.text length] <= 0))
    //        enterBtn.enabled = NO;
    //    else
    //        enterBtn.enabled = YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == 1){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)backBtn:(id)sender {
    appDelegate.checkPay = FALSE;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelPress{
    appDelegate.checkPay =  FALSE;
    [reader dismissViewControllerAnimated:NO completion:nil];
    return;
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scanTab"];
}

@end
