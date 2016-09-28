//
//  OptionLocation.m
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "OptionLocationSignup.h"
#import "MainAppDelegate.h"
#import "OptionList.h"
/*#import "GAI.h"
 #import "GAIFields.h"
 #import "GAIDictionaryBuilder.h"*/
#import <MapKit/MapKit.h>

@interface OptionLocationSignup ()

// @ADDED 06/01/2015 - Food Orders
// Ibrahim

@property IBOutlet UIButton *cartButton;

- (void) showRestoDetails:(id)sender;
- (void) showMenus:(id)sender;
- (void) foodApiSet:(id)sender;
- (void) getResto:(id)sender restoId:(NSNumber*)restoId;
- (void) goToResto;
- (void) goToOrderSummary:(id)sender;
// END OF @ADDED

@end

@implementation OptionLocationSignup
@synthesize headerTitleLbl;
@synthesize callUsNowTableView;
@synthesize CallUsNowCustomCell,offersArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    findlocation.userInteractionEnabled = YES;
    [self setNeedsStatusBarAppearanceUpdate]; // overrided instance to changes status bar that called preferredStatusBarStyle

    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnOnLocation)];
    [findlocation addGestureRecognizer:tapGesture];
    findlocation.hidden = YES;
    
    isSplashLoad=YES;
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    isLocationOn = TRUE;
    isNetworkOn = TRUE;
    
    [self fetchXML];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundNotification)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    isSplashLoad=NO;
    
    appDelegate.checkInfo = TRUE;
    
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searchField.delegate = self;
    
    /*UITapGestureRecognizer *tapGR;
    tapGR = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    tapGR.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foodApiSet:)
                                                 name:@"FoodApiIsSet"
                                               object:nil];*/
}

/*-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        // handling code
        [searchField resignFirstResponder];
    }
}*/

-(void)turnOnLocation{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]==0.00) {
            
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Turn On Location Services",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"location_check"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            [self fetchXML];
        }
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Turn On Location Services",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"location_check"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (UIColor *) colorWithHexString: (NSString *) stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (void) appWillEnterForegroundNotification {
    [indicatorView startAnimating];
    [self fetchXML];
    
    isSplashLoad=NO;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id_signup_location"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name_signup_location"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_signup_flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    isSplashLoad=NO;
}

- (IBAction)BcakButtonClicked:(UIButton *)sender {
    
    // [self.view removeFromSuperview];;
}

#pragma mark -
#pragma Tableview Datasource And Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return offersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (int)lineCountForText:(NSString *)text fontType:(UIFont*)font
{
//    UIFont *font = [UIFont fontWithName:@"ClarendonBT-Roman" size:15];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    
    return ceil(rect.size.height / font.lineHeight);
}

- (int)lineCountForTextaddress:(NSString *)text fontType:(UIFont*)font
{
    //    UIFont *font = [UIFont fontWithName:@"ClarendonBT-Roman" size:15];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    
    return ceil(rect.size.height / font.lineHeight);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CELL_IDENTIFIER = CALL_US_NOW_CELL_SIGNUP;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    UIImageView *bgPic = [[[UIImageView alloc] initWithFrame:CGRectMake(3,62,300,6)]autorelease];
    bgPic.backgroundColor = [UIColor clearColor];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CallUsNowCustomCellSignup" owner:self options:nil];
        if([nib count] > 0)
        {
            cell = self.CallUsNowCustomCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_NAME];
        UILabel *phoneLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_PHONE];
    UILabel *discriptionLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_DESCRIPTION];
    
    if (indexPath.row < [offersArray count])
    {
        nameLabel.text = [[offersArray objectAtIndex:indexPath.row] valueForKey:@"app_display_text"];
        [nameLabel setNumberOfLines:2];
        phoneLabel.text = [[offersArray objectAtIndex:indexPath.row] valueForKey:@"phone_number"];

        //set line spacing
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
        discriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:[[offersArray objectAtIndex:indexPath.row] valueForKey:@"address"]
                                                                          attributes:attributtes];
        
        UIButton *phoneButton = [[UIButton alloc] init];
        phoneButton.frame=CGRectMake(10, -5, 280, 60);
        phoneButton.backgroundColor = [UIColor clearColor];
        phoneButton.tag = indexPath.row + 1000;
        
        [phoneButton addTarget:self action:@selector(getlocation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:phoneButton];
        [phoneButton release];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.contentView addSubview:bgPic];
    }
    //    }
    return cell;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"here");
    [searchField resignFirstResponder];
}

- (void) getlocation:(UIButton *)sender {
     NSInteger index= sender.tag - 1000;
    
     NSString *id_location = [[offersArray objectAtIndex:index] valueForKey:@"id"];
     NSString *name_location = [[offersArray objectAtIndex:index] valueForKey:@"app_display_text"];
    
    NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= %@", id_location);
    [[NSUserDefaults standardUserDefaults] setObject:id_location forKey:@"id_signup_location"];
    [[NSUserDefaults standardUserDefaults] setObject:name_location forKey:@"name_signup_location"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"location_signup_flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction) backButtonAction{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) fetchXML {
    
    if(offersArray)
    {
        [offersArray release];
        offersArray = nil;
    }
    offersArray = [[NSMutableArray alloc] init];
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]){
//        NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
        [self getLocation];
//    }
}

-(void)getLocation{
    /*if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]==0.00 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue]==0.00) {
        [indicatorView stopAnimating];
        callUsNowTableView.hidden = YES;
        findlocation.hidden = NO;
        
    }else{*/
        callUsNowTableView.hidden = NO;
        findlocation.hidden = YES;
        
        [indicatorView startAnimating];
        [offersArray removeAllObjects];
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lat",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"lng",[NSNumber numberWithInt:kGetAllRestaurantsRequest], keyRequestType, nil];
        Server *obj = [[[Server alloc] init] autorelease];
        currentRequestType = kGetAllRestaurantsRequest;
        obj.delegate = self;
        [obj sendRequestToServer:aDic];
//    }
}

#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    if( returnString!= nil && ![returnString isEqualToString:@""]){
        if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            [alert release];
            [callUsNowTableView reloadData];
            
        }else {
            
            NSDictionary *response= [returnString JSONValue];
            BOOL status= [[response objectForKey:@"status"] boolValue];
            NSLog(@"=--=-=-=-=-=-=-=-= %@", response);
            
            if (status){
                [offersArray removeAllObjects];
                offersArray = [[response objectForKey:@"restaurants"] retain];
                [self performSelectorOnMainThread:@selector(fetchCompleted) withObject:nil waitUntilDone:true];
            }
            else{
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if([msg length] == 0)
                    msg = SOMETHING_WENT_WRONG;
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }];
                [alert release];
                [callUsNowTableView reloadData];
            }
        }
        
    }
    else{
        
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
        [callUsNowTableView reloadData];
    }
    
}

- (void) requestError:(NSString * )returnString {
    [self.view setUserInteractionEnabled:YES];
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

- (void) requestNetworkError {
    [self.view setUserInteractionEnabled:YES];
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

-(void) fetchCompleted {
    
   	if ([offersArray count] == 0) {
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"No Results Found",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
        
        [callUsNowTableView reloadData];
        [indicatorView stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        return;
        
    }
    
    [callUsNowTableView reloadData];
    [self.view setUserInteractionEnabled:YES];
    
    [indicatorView stopAnimating];
}


- (void)viewDidUnload
{
    [self setCallUsNowTableView:nil];
    [self setHeaderTitleLbl:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    
    [CallUsNowCustomCell release];
    [offersArray release];
    [callUsNowTableView release];
    [headerTitleLbl release];
    [goBtn release];
    [searchField release];
    [lbltitle release];
    [subtiltLbl release];
    [findlocation release];
    [backImg release];
    [backBtn release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        callUsNowTableView.hidden = YES;
        [self goClick:nil];
    }
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO;
    else
        return true;
}


- (IBAction)goClick:(id)sender {
    self.view.userInteractionEnabled = NO;
    [indicatorView startAnimating];
    [searchField resignFirstResponder];
    
    if(offersArray)
    {
        [offersArray release];
        offersArray = nil;
    }
    offersArray = [[NSMutableArray alloc] init];
    
    findlocation.hidden = YES;
    callUsNowTableView.hidden = NO;
    
    [offersArray removeAllObjects];
    
    NSString *escapedText = [searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lat",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"lng",escapedText, @"search",[NSNumber numberWithInt:kgetRestaurantAddressSearch], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kgetRestaurantAddressSearch;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

@end
