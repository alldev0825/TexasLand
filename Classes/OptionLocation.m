//
//  OptionLocation.m
//  Raising Canes
//
//  Created by Ajay Kumar on 28/11/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "OptionLocation.h"
#import "MainAppDelegate.h"
#import "OptionList.h"
#import "Constants.h"
#import <MapKit/MapKit.h>
#import "TermsOfUserViewController.h"
#import "webView.h"

@interface OptionLocation ()

@end

@implementation OptionLocation
@synthesize callUsNowTableView;
@synthesize CallUsNowCustomCell,offersArray;


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
    findLocationNearby.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundNotificationLocation)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    searchTxt.delegate = self;
    [indicatorView stopAnimating];
    isSplashLoad=YES;
    [self setNeedsStatusBarAppearanceUpdate]; // overrided instance to changes status bar that called preferredStatusBarStyle
    isLocationOn = TRUE;
    isNetworkOn = TRUE;
    
    [self fetchXML];
    
    isSplashLoad=NO;
    
    findLocationNearby.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findLocationNearby)];
    [findLocationNearby addGestureRecognizer:tapLocation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    NSLog(@"self.navigationController.viewControllers : %@", self.navigationController.viewControllers);
    if (self.navigationController.viewControllers.count <= 2) {
        RXCustomTabBar *tabBar = (RXCustomTabBar *) self.navigationController.tabBarController;
        [tabBar initializeSliderView:self.view];
        
    }else{
        backBtn.hidden = NO;
    }
    
}
-(void)dismissKeyboard {
    [searchTxt resignFirstResponder];
}

-(void)appWillEnterForegroundNotificationLocation{
    [self fetchXML];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self goBtnAction:nil];
    return YES;
}

-(void) searchLocation {
    [indicatorView startAnimating];
    
    if(offersArray)
    {
        [offersArray release];
        offersArray = nil;
    }
    offersArray = [[NSMutableArray alloc] init];
    // Added for Simulator Testing Purposes, should be removed after that: Zeeshan Akhtar
    
    [offersArray removeAllObjects];
    
    NSString *escapedText = [searchTxt.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lat",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"lng",escapedText, @"search",[NSNumber numberWithInt:kgetRestaurantAddressSearch], keyRequestType, nil];
    Server *obj = [[[Server alloc] init] autorelease];
    currentRequestType = kgetRestaurantAddressSearch;
    obj.delegate = self;
    [obj sendRequestToServer:aDic];
}

- (void) appWillEnterForegroundNotification {
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    appDelegate = (MainAppDelegate * )[[UIApplication sharedApplication] delegate];
    
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
    return 80;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_IDENTIFIER = CALL_US_NOW_CELL;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if(indexPath.row == 0 ) {
    } else if(indexPath.row < [offersArray count] - 1 ) {
    } else {
    }
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CallUsNowCustomCell" owner:self options:nil];
        if([nib count] > 0)
        {
            cell = self.CallUsNowCustomCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_NAME];
    UILabel *phoneLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_PHONE];
    UILabel *discriptionLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_DESCRIPTION];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:CALL_US_NOW_CUSTOM_LABEL_DISTANCE];
    
    if (indexPath.row < [offersArray count])
    {
        nameLabel.text = [[offersArray objectAtIndex:indexPath.row] valueForKey:@"app_display_text"];
        phoneLabel.text = [[offersArray objectAtIndex:indexPath.row] valueForKey:@"phone_number"];
        [nameLabel setNumberOfLines:2];
        
        //set line spacing
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
        discriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:[[offersArray objectAtIndex:indexPath.row] valueForKey:@"address"]
                                                                          attributes:attributtes];
        
        NSLog(@"latitude here: %f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]);
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]){
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]==0.00 || ([[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue]==0.00)) {
                distanceLabel.hidden = YES;
            }else{
                distanceLabel.text = [NSString stringWithFormat:@"%.2f mi",[Utils calculateDistance:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue] second:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue] third:[[[offersArray objectAtIndex:indexPath.row] valueForKey:@"latitude"] doubleValue] fourth:[[[offersArray objectAtIndex:indexPath.row] valueForKey:@"longitude"] doubleValue]]/1609.34];

            }
            
        }
        
        UIButton *phoneButton = [[UIButton alloc] init];
        phoneButton.frame=CGRectMake(184, 22, 42, 38);
        phoneButton.backgroundColor = [UIColor clearColor];
        phoneButton.tag = indexPath.row + 1000;
        
        UIButton *locButton = [[UIButton alloc] init];
        locButton.frame=CGRectMake(230, 22, 42, 38);
        locButton.backgroundColor = [UIColor clearColor];
        locButton.tag = indexPath.row + 1000;
        
        UIButton *orderButton = [[UIButton alloc] init];
        orderButton.frame=CGRectMake(275, 22, 42, 38);
        orderButton.backgroundColor = [UIColor clearColor];
        orderButton.tag = indexPath.row + 1000;
        
        [locButton addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:locButton];
        [locButton release];
        
        [phoneButton addTarget:self action:@selector(phonecall:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:phoneButton];
        [phoneButton release];
        
        [orderButton addTarget:self action:@selector(orderLink:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:orderButton];
        [orderButton release];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void) orderLink:(UIButton *)sender{
    NSInteger index= sender.tag - 1000;
    
    NSString *order_link = [[offersArray
                             objectAtIndex:index] valueForKey:@"online_order_link"];
    
    webView *web = [[webView alloc]init];
    web.urlAddress = [NSString stringWithFormat:@"%@", order_link];
    web.showBackBtn = @"TRUE";
    web.titleTxt = @"MENU";
    [self.navigationController pushViewController:web animated:NO];
    [web release];
}

- (void) showMap:(UIButton *)sender {
    
    NSInteger index= sender.tag - 1000;
    double lng = [[[offersArray objectAtIndex:index] valueForKey:@"longitude"]doubleValue];
    double ltd = [[[offersArray objectAtIndex:index] valueForKey:@"latitude"]doubleValue];
    
    double statlng = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue];
    double statltd = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue];
    
    NSString *name_address = [[offersArray objectAtIndex:index] valueForKey:@"address"];
    
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(ltd,lng);
    CLLocationCoordinate2D start = CLLocationCoordinate2DMake(statlng,statltd);
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        //Apple Maps, using the MKMapItem class
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
        MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
        
        item.name = [NSString stringWithFormat:@"%@", name_address];
        
        NSArray* items = [[NSArray alloc] initWithObjects: item, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];
    } else {
        
        NSString *googleMapsURLString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                         start.latitude, start.longitude, destination.latitude, destination.longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
    }
}

- (void) phonecall:(UIButton *)sender {
    
    NSInteger index= sender.tag - 1000;
    
    NSString *number = [[offersArray objectAtIndex:index] valueForKey:@"phone_number"];
    
    NSString* newString = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *trimmed = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSURL* callUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",trimmed]];
    
    //check  Call Function available only in iphone
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:callUrl];
    } else {
        RMUIAlertView *alert=[[RMUIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"This function is only available on a phone device", @"")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction) backButtonAction{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void) timerMainMenu : (id)sender{
    if(offersArray)
    {
        [offersArray release];
        offersArray = nil;
    }
    offersArray = [[NSMutableArray alloc] init];
    // Added for Simulator Testing Purposes, should be removed after that: Zeeshan Akhtar
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]){
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]==0.00) {
            [indicatorView stopAnimating];
            findLocationNearby.hidden = NO;
            callUsNowTableView.hidden = YES;
        }else{
            findLocationNearby.hidden = YES;
            callUsNowTableView.hidden = NO;
            
            [offersArray removeAllObjects];
            
            [indicatorView startAnimating];
            NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:APPKEY,@"appkey",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lat",[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"lng",[NSNumber numberWithInt:kGetAllRestaurantsRequest], keyRequestType, nil];
            Server *obj = [[[Server alloc] init] autorelease];
            currentRequestType = kGetAllRestaurantsRequest;
            obj.delegate = self;
            [obj sendRequestToServer:aDic];
        }
    }else{
        if (![CLLocationManager locationServicesEnabled] ) {
            findLocationNearby.hidden = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:@"0.00" forKey:@"longitude"];
        }
    }
}

-(void) fetchXML {
    
    [indicatorView setHidden:NO];
    [indicatorView startAnimating];
    
    NSTimer *autoTimer;
    
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerMainMenu:) userInfo:nil repeats:NO];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 200 && range.length == 0)
        return NO;
    else
        return true;
}

-(void)findLocationNearby{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]){
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]==0.00) {
            
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Turn On Location Services",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
            alert.tag = 10;
            [alert release];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"location_check"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            [self fetchXML];
        }
    }else{
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Turn On Location Services",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        alert.tag = 10;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        [alert release];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"location_check"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark ServerRequestFinishedProtocol Methods
- (void) requestFinished:(NSString * )returnString {
    
    [indicatorView stopAnimating];
    callUsNowTableView.hidden = NO;
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
            
            NSLog(@"response -=-=-=-=-=- %@", response);
            
            if (status){
                [offersArray removeAllObjects];
                offersArray = [[response objectForKey:@"restaurants"] retain];
                [self performSelectorOnMainThread:@selector(fetchCompleted) withObject:nil waitUntilDone:true];
            }
            else{
                NSString *msg = [response objectForKey:@"notice"];
                if([msg length] == 0 && [[response objectForKey:@"message"] length] != 0)
                    msg = [response objectForKey:@"message"];
                
                if(!msg){
                    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:SOMETHING_WENT_WRONG delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                    [alert show];
                    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                        [alert dismissWithClickedButtonIndex:0 animated:NO];
                    }];
                    [alert release];
                }else{
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
    
    [indicatorView stopAnimating];
    RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }];
    [alert release];
}

- (void) requestNetworkError {
    
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
        //		[self.view setUserInteractionEnabled:YES];
        return;
        
    }else{
        findLocationNearby.hidden = YES;
    }
    
    [callUsNowTableView reloadData];
    //	[self.view setUserInteractionEnabled:YES];
    
    [indicatorView stopAnimating];
    
}


- (void)viewDidUnload
{
    [self setCallUsNowTableView:nil];
    [titlePage release];
    titlePage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    
    [CallUsNowCustomCell release];
    [offersArray release];
    [callUsNowTableView release];
    [headerTitleLbl release];
    [titlePage release];
    [findLocationNearby release];
    [searchTxt release];
    [goBtn release];
    [super dealloc];
}

-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 10)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)goBtnAction:(id)sender {
    callUsNowTableView.hidden = YES;
    [searchTxt resignFirstResponder];
    [self searchLocation];
}
@end