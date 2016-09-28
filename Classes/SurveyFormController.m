//
//  SurveyFormController.m
//
//

#import "SurveyFormController.h"
#import "Survey.h"
#import "MainAppDelegate.h"
#import "Constants.h"
#import "DataAccessLayer.h"
#import "JSON.h"
#import "LocationSignUp.h"
#import "ASIFormDataRequest.h"
#import "LocationLogin.h"
#import "MainLogin.h"
#import "successSubmit.h"
#import "skipSurvey.h"

@implementation SurveyFormController
@synthesize button;

int tagButton=0;
unsigned int fooIndex=0;
unsigned int fooIndexChoice=0;
unsigned int indexBtnCheck=0;


#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 ."
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC
#define kGeoCodingString @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"inside viewWillAppear...");
    [super viewWillAppear:YES];
}


-(id)initWithSurveyId:(NSString *)surveyId andReceiptId:(NSString *) receiptId andDealId:(NSString *) dealId {
    self = [super init];
    
    survey_id = [[NSString alloc] initWithFormat:@"%@",surveyId];
    if(receiptId!=nil)
        receipt_id = [[NSString alloc] initWithFormat:@"%@",receiptId];
    else
        receipt_id = nil;
    if(dealId!=nil) {
        deal_id = [[NSString alloc] initWithFormat:@"%@",dealId];
        NSLog(@"Deal id:%@",deal_id);
    }
    else
        deal_id = nil;
    return self;
}

-(id)initWithSurveyId:(NSString *)surveyId andReceiptId:(NSString *) receiptId andDealId:(NSString *) dealId andRestaurantName:(NSString *) restName andReceiptDate:(NSString *) receiptDateStr{
    self = [super init];
    
    survey_id = [[NSString alloc] initWithFormat:@"%@",surveyId];
    if(receiptId!=nil)
        receipt_id = [[NSString alloc] initWithFormat:@"%@",receiptId];
    else
        receipt_id = nil;
    if(dealId!=nil) {
        deal_id = [[NSString alloc] initWithFormat:@"%@",dealId];
        NSLog(@"Deal id:%@",deal_id);
    }
    else
        deal_id = nil;
    
    if(receiptDateStr!=nil)
        receipt_date = [[NSString alloc] initWithFormat:@"%@",receiptDateStr];
    else
        receiptDateStr = nil;
    
    if(restName!=nil) {
        restaurant_name = [[NSString alloc] initWithFormat:@"%@",restName];
    }
    else
        restaurant_name = nil;
    
    
    return self;
}




#pragma mark -
#pragma mark textField delegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    for (int i =0; i< [TFArray count]; i++) {
        [[TFArray objectAtIndex:i] resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [commentField resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
        [scrollView scrollRectToVisible:CGRectMake(0,30,267, 900) animated:YES];
}

-(IBAction) hideKeyboard {
    for (int i =0; i< [TFArray count]; i++) {
        [[TFArray objectAtIndex:i] resignFirstResponder];
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) activeTool:(int) activeNum{
    switch (activeNum) {
        case 1:
        {
            [ViewMultiple setHidden:YES];
            [toolbarCheckBox removeFromSuperview];
            
            button = [dropArray objectAtIndex:tagButton];
            [button setUserInteractionEnabled:TRUE];
            
            [myPickerView removeFromSuperview];
            [toolbar removeFromSuperview];
            [doneButton removeFromSuperview];
            [backButton removeFromSuperview];
         
            break;
        }
            
        case 2:{
            button = [dropArray objectAtIndex:tagButton];
            [button setUserInteractionEnabled:TRUE];

            [myPickerView removeFromSuperview];
            [toolbar removeFromSuperview];
            [doneButton removeFromSuperview];
            [backButton removeFromSuperview];
            
            [self hideKeyboard];
            break;
        }
        case 3:{
            [ViewMultiple setHidden:YES];
            [toolbarCheckBox removeFromSuperview];
            [self hideKeyboard];
        }
            
            
        default:
            break;
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) fetchSurveyList {
	
	[indicatorView startAnimating];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *returnString = [DataAccessLayer getSurveyList:APPKEY surveyId:
                              survey_id
                              //                              appDelegate.selectedDeal.surveyId_Offer
                                                      token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
	if( returnString!= nil && ![returnString isEqualToString:@""]){
		if([returnString isEqualToString:TIME_OUT] || [returnString isEqualToString:CONNECTION_FAILURE]){
			RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:returnString delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
			[alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
			[alert release];
			
		}else {
			
			if ([returnString isEqualToString:@"401"]) {
                RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Login Error",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                alert.tag=1;
				[alert show];
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                    [alert dismissWithClickedButtonIndex:0 animated:NO];
                }];
                [alert release];
                
            }else{
                NSDictionary *response= [returnString JSONValue];
                BOOL status= [[response objectForKey:@"status"] boolValue];
                if (status){
                    NSMutableArray *sur = [response objectForKey:@"survey"];
                    if ([sur count] == 0) {
                        [indicatorView stopAnimating];
                        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"No Survey Record Found" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
                        [alert show];
                        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                            [alert dismissWithClickedButtonIndex:0 animated:NO];
                        }];
                        [alert release];
                        return;
                    }
                    response= [sur objectAtIndex:0];
                    NSMutableArray *surveys = [response objectForKey:@"questions"];
                    
                    [surveyArray removeAllObjects];
                    for(int i = 0 ; i < [surveys count] ; i++){
                        Survey *survey=[[Survey alloc] init];
                        
                        NSDictionary *surveyDict= [surveys objectAtIndex:i];
                        survey.qId= [surveyDict objectForKey:@"id"]==[NSNull null]?@"":[surveyDict objectForKey:@"id"];
                        survey.qtext= [surveyDict objectForKey:@"text"]==[NSNull null]?@"":[surveyDict objectForKey:@"text"];
                        survey.qtype= [surveyDict objectForKey:@"question_type"]==[NSNull null]?@"":[surveyDict objectForKey:@"question_type"];
                        survey.qlabel = [[NSMutableArray alloc] init];
                        survey.dropIdArray = [[NSMutableArray alloc] init];
                        survey.choicesArray = [[NSMutableArray alloc] init];
                        NSMutableArray *choices = [surveyDict objectForKey:@"question_choices"];
                        for(int c= 0 ; c<[choices count] ; c++){
                            NSDictionary *choiceDict = [choices objectAtIndex:c];
                            NSString *choiceId= [choiceDict objectForKey:@"id"]==[NSNull null]?@"":[choiceDict objectForKey:@"id"];
                            [survey.choicesArray addObject:choiceId];
                            
                        }
                        
                        for(int c= 0 ; c<[choices count] ; c++){
                            NSDictionary *choiceDict = [choices objectAtIndex:c];
                            NSString *choiceLabel= [choiceDict objectForKey:@"label"]==[NSNull null]?@"":[choiceDict objectForKey:@"label"];
                            [survey.qlabel addObject:choiceLabel];
                        }
                        
                        for(int c= 0 ; c<[choices count] ; c++){
                            NSDictionary *choiceDict = [choices objectAtIndex:c];
                            NSString *dropId= [choiceDict objectForKey:@"id"]==[NSNull null]?@"":[choiceDict objectForKey:@"id"];
                            [survey.dropIdArray addObject:dropId];
                        }
                        
                        [surveyArray addObject:survey];
                        [survey.choicesArray release];
                        [survey.qlabel release];
                        [survey.dropIdArray release];
                        [survey release];
                    }
                    
                }
                
            }
		}// else for 401 error
	}else{
		
		RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Network Error" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
		[alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
		[alert release];
	}
    
	[self performSelectorOnMainThread:@selector(fetchCompleted) withObject:nil waitUntilDone:true];
	[pool release];
}

-(void) fetchCompleted {

    [indicatorView stopAnimating];
    Survey *survey;
    finalCount = 0;
    finalNewCount = 0;
    int y;
    for (int i=0; i<[surveyArray count]; i++) {
        
        if (i==0) {
            y=10;
        }
        else{
            y=y+95;
        }
        
        survey = [surveyArray objectAtIndex:i];
        
        UILabel *questionlabel=[[UILabel alloc] initWithFrame:CGRectMake(18, y-6, 250, 45)];
        [questionlabel setBackgroundColor:[UIColor clearColor]];
        [questionlabel  setTextColor: [Utils colorWithHexString:@"4b3829"]];
        questionlabel.textAlignment = NSTextAlignmentCenter;
        questionlabel.lineBreakMode = UILineBreakModeWordWrap;
        questionlabel.numberOfLines = 3;
        [questionlabel setFont:[UIFont fontWithName:@"UnitedSansCond-Medium" size:18]];
        [questionlabel setText:survey.qtext];
        
        if ([survey.qtype intValue] == 2) {
            finalCount = i;
			int selectedRadio=0;
            if([survey.choicesArray count]%2==0){
                selectedRadio = 0;
            }else {
                selectedRadio = 0;
            }
            
            [params addObject:[survey.choicesArray objectAtIndex:selectedRadio]];
            
            if(i==0){
                startingId  = [[survey.choicesArray objectAtIndex:0] intValue];
            }
            
            UIImageView *thumbsDown = [[[UIImageView alloc] initWithFrame:CGRectMake(17, y+30, 30, 30)] autorelease];

            int x=15;
            for (int k=0; k < [survey.choicesArray count]; k++) {
                
                UIButton *radioButton=[[UIButton alloc] initWithFrame:CGRectMake(x, y+35, 38, 36)];
                
                [radioButton setImage:[UIImage imageNamed:@"star-white.png"] forState:UIControlStateNormal];
                [radioButton addTarget:self action:@selector(radioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                radioButton.tag = i*10+k;
                [radioButtonsArray addObject:radioButton];
                [scrollView addSubview:radioButton];
                x+=58;
            }
            UIImageView *thumbsUp = [[[UIImageView alloc] initWithFrame:CGRectMake(x, y+25, 30, 30)] autorelease];
            
            [radioTemp addObject:[NSNumber numberWithInteger:i]];
            NSNumber *anumber = [NSNumber numberWithInteger:i];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@", anumber]];
            
            [dropArray addObject:thumbsUp];
            [scrollView addSubview:questionlabel];
        } else if ([survey.qtype intValue] == 3) {
            [scrollView addSubview:questionlabel];
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(textPress:)
             forControlEvents:UIControlEventTouchDown];
            
            UIImage *imge = [UIImage imageNamed:@"survey-select"];
            [button setBackgroundImage:imge forState:UIControlStateNormal];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            button.frame = CGRectMake(10, y+45, 270, 35);
            [button setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:13]];
            [button setTitleColor:[Utils colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
            [button setTitle:@"Select One" forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [scrollView addSubview:button];
            [viewArray addObject:survey.qlabel];
            [dropArray addObject:button];
            button.tag = i;
            
            NSNumber *anumber = [NSNumber numberWithInteger:i];
            [buttonIndex addObject:anumber];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@", anumber]];
            
            [dropdowntemp addObject:[NSNumber numberWithInt:0]];
            [buttonArray addObject:[NSNumber numberWithInt:button.tag]];
            [arrayDrop addObject:[NSNumber numberWithInt:NULL]];
            
        }
        else if ([survey.qtype intValue] == 5) {
            [scrollView addSubview:questionlabel];
            [txtLblMultilple setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:15]];
            [txtLblMultilple setText:survey.qtext];
            
            buttonCheck = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [buttonCheck addTarget:self
                            action:@selector(showMultiple:)
                  forControlEvents:UIControlEventTouchDown];
            
            UIImage *imge = [UIImage imageNamed:@"survey-select"];
            [buttonCheck setBackgroundImage:imge forState:UIControlStateNormal];
            [buttonCheck setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:13]];
            [buttonCheck setTitleColor:[Utils colorWithHexString:@"8a8a8a"] forState:UIControlStateNormal];
            [buttonCheck setTitle:@"Select One" forState:UIControlStateNormal];
            buttonCheck.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            buttonCheck.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            buttonCheck.frame = CGRectMake(10, y+45, 270, 35);
            
            [scrollView addSubview:buttonCheck];
            [viewMultiple addObject:survey.qlabel];
            
            [dropArray addObject:buttonCheck];
            [paramsDrop addObject:buttonCheck];
            buttonCheck.tag = i;
            
            NSNumber *checknumber = [NSNumber numberWithInteger:i];
            
            [StringCheckId addObject:@""];
            [buttonCheckSum addObject:checknumber];
            
            [IdMultiple addObject:survey.dropIdArray];
        }
        
        else{
                        [scrollView addSubview:questionlabel];
            UIImageView *commentImg =  [[UIImageView alloc] initWithFrame:CGRectMake(10, y+35, 270, 83)];
            commentImg.backgroundColor = [UIColor clearColor];
            [commentImg setImage:[UIImage imageNamed:@"select-field.png"]];
            [scrollView addSubview:commentImg];
            
            UITextView *comments = [[UITextView alloc] initWithFrame:CGRectMake(15, y+47, 260, 66)];
            [comments setBackgroundColor:[UIColor clearColor]];
            comments.delegate = self;
            comments.delegate =  (id <UITextViewDelegate>)self;
            [comments setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [comments setAutocorrectionType:UITextAutocorrectionTypeNo];

            [scrollView addSubview:comments];
            
            [TFArray addObject:comments];
            
            [dropArray addObject:comments];
            
            y+=40;
            [comments release];
            [commentImg release];
        }
        
        if(i != [surveyArray count]-1){
            UIImageView *line =  [[UIImageView alloc] initWithFrame:CGRectMake(0, y+93, 290, 1)];
            line.backgroundColor = [UIColor clearColor];
            [line setImage:[UIImage imageNamed:@"line-info.png"]];
            [scrollView addSubview:line];
            
        }

    }
    
    if([surveyArray count] > 0){
        [sumitButton setFrame:CGRectMake(10, y+115, 270, 42)];
        [scrollView addSubview:sumitButton];
        sumitButton.enabled = NO;
        [scrollView setContentSize:CGSizeMake(219, y+320)];
        
    }
    [indicatorView stopAnimating];
    
}

-(void) radioButtonPressed : (UIButton *) sender {
    
    int currentValue;
    int count= [surveyArray count];
    int c=0;
    int rowNo;
    int choiceIndex=0;
    int choicesCount = 0;
    NSLog(@"sender tag %i",sender.tag);
	for (int j=0; j<count; j++) {
        Survey *surveyRow = [surveyArray objectAtIndex:j];
        choicesCount =[surveyRow.choicesArray count];
        if ([surveyRow.qtype intValue] == 2) {
            if (sender.tag>=j*10 && sender.tag <(j+1)*10) {
                currentValue=c;
                rowNo=j;
                choicesCount =[surveyRow.choicesArray count];
                
                NSString *test = [NSString stringWithFormat:@"%i", sender.tag];
                NSLog(@"%i",[test length]);
                NSString *index;
                if([test length] == 1){
                    index = @"0";
                }else{
                    index = [[NSString stringWithFormat:@"%i", sender.tag] substringToIndex:1];
                }
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:index] isEqualToString:@"1"]){
                    finalNewCount = finalNewCount+1;
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:index];
                }
                
                [self enableBtnSubmit];
                break;
                
            }
            c+=choicesCount;
        }
    }
    
    for (int i=currentValue; i<currentValue+choicesCount; i++) {
        UIButton *tempButton = [radioButtonsArray objectAtIndex:i];
        if(sender.tag >= tempButton.tag){
            [tempButton setImage:[UIImage imageNamed:@"star-green.png"] forState:UIControlStateNormal];
			Survey *sr1 = [surveyArray objectAtIndex:rowNo];
            fooIndexChoice = [radioTemp indexOfObject:[NSNumber numberWithInt:rowNo]];
            [params replaceObjectAtIndex:fooIndexChoice withObject:[sr1.choicesArray objectAtIndex:choiceIndex]];
            for (int k = 0; k<[params count]; k++) {
            }
        }
        else{
            [tempButton setImage:[UIImage imageNamed:@"star-white.png"] forState:UIControlStateNormal];
        }
		choiceIndex++;
    }
}

//-(void) viewWillDisappear:(BOOL)animated
//{
//    if(viewFlag!=1)
//        [self.navigationController popViewControllerAnimated:NO];
//}

-(IBAction) imageChange:(UIButton *) sender {
	if(sender.state == UIControlStateSelected) {
		[sender setBackgroundImage:[sender backgroundImageForState:UIControlStateSelected] forState:sender.state];
	}
	else {
	}
	
}

-(IBAction) backButtonAction{
    [MainAppDelegate getAppDelegate].alertCheck = 21;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"successconfirmation"];
    [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"checkStatus"];
    
    skipSurvey *   skip = [[skipSurvey alloc] init];
    
    [self.navigationController pushViewController:skip animated:NO];
    [skip release];
}

-(IBAction) submitButtonPressed{
    [indicatorView startAnimating];
    [NSThread detachNewThreadSelector:@selector(submitSurveyData) toTarget:self withObject:nil];
}

-(void) submitSurveyData{
    
    ansParamList = [[NSMutableString alloc] init];
    quesParamList = [[NSMutableArray alloc] init];
    NSMutableArray *answerArray = [[NSMutableArray alloc] init];
	
    int commentsCount=0, choicesCount=0, dropCount=0, checkCount=0;
    for (int i=0; i < [surveyArray count]; i++) {
        Survey *sry = [surveyArray objectAtIndex:i];
        if ([sry.qtype intValue] == 1) {
            UITextField *comments = [TFArray objectAtIndex:commentsCount];
            commentsCount++;
			[answerArray addObject:[NSString stringWithFormat:@"%@",comments.text]];
            [ansParamList appendFormat:@"%@,",[comments.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else if([sry.qtype intValue] == 3){
            [answerArray addObject:[arrayDrop objectAtIndex:dropCount]];
			[ansParamList appendFormat:@"%@,",[arrayDrop objectAtIndex:dropCount]];
            dropCount++;
        }else if([sry.qtype intValue] == 5){
            [answerArray addObject:[StringCheckId objectAtIndex:checkCount]];
			[ansParamList appendFormat:@"%@,",[StringCheckId objectAtIndex:checkCount]];
            checkCount++;
        }else{
            [answerArray addObject:[NSString stringWithFormat:@"%@",[params objectAtIndex:choicesCount]]];
			[ansParamList appendFormat:@"%@,",[params objectAtIndex:choicesCount]];
            choicesCount++;
        }
    }
    for (int k = 0; k<[surveyArray count]; k++) {
        Survey *survey = [surveyArray objectAtIndex:k];
        [quesParamList addObject:[NSString stringWithFormat:@"%@",survey.qId]];
    }
    
    [ansParamList replaceCharactersInRange:NSMakeRange([ansParamList length]-1, 1) withString:@""];
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *responseStr;
	@try{
        
		NSString *url = [BASE_URL stringByAppendingFormat:@"/survey/%@/answer",
                         survey_id
                         //appDelegate.selectedDeal.surveyId_Offer
                         ];
		
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        NSLog(@"the URL is :%@",url);
		
		[request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"auth_token"];
        [request setPostValue:APPKEY forKey:@"appkey"];
        if(receipt_id !=nil) {
            [request setPostValue: receipt_id
                           forKey:@"receiptId"];
        }
        
        if(deal_id != nil) {
            [request setPostValue:deal_id forKey:@"dealid"];
        }
		[request setPostValue:@"0" forKey:@"rewardId"];
		[request setPostValue:quesParamList forKey:@"questionIdList"];
		
		for(int j=0 ; j<[answerArray count] ; j++){
			[request setPostValue:[answerArray objectAtIndex:j] forKey:[NSString stringWithFormat:@"answers[%@]",[quesParamList objectAtIndex:j]]];
		}
		[answerArray release];
		[request setDelegate:self];
		[request startSynchronous];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
		else {
            responseStr = [error localizedDescription];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:responseStr delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
                [alert dismissWithClickedButtonIndex:0 animated:NO];
            }];
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	
	[pool release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[indicatorView stopAnimating];
    NSDictionary *dict = [[request responseString] JSONValue];
    BOOL status =  [[dict objectForKey:@"status"] boolValue];
    NSString *message = [dict objectForKey:@"message"];
    
    if(!status)
    {
        RMUIAlertView *alert = [[RMUIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
            [alert dismissWithClickedButtonIndex:0 animated:NO];
        }];
        alert.tag = 10;
        [alert release];
        
    }else{
        [scrollView setContentSize:CGSizeMake(290,295)];
        [scrollView scrollRectToVisible:CGRectMake(0,0,300, 295) animated:YES];
        
        [MainAppDelegate getAppDelegate].alertCheck = 31;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"successconfirmation"];
        
        successSubmit *success = [[successSubmit alloc]init];
        [self.navigationController pushViewController:success animated:NO];
        [success release];
//        viewFlag = 1;
        
    }
}


-(void) alertView:(RMUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if([alertView.title isEqualToString:NSLocalizedString(@"Success","")]){
        // deal_id not equal to nil means this screen is called from deal detail page.
        if(deal_id!=nil) {
            if ([alertView.title isEqualToString:@""]) {
                if(self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if(alertView.tag==1){
		[[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"userId"];
		MainLogin *login = [[MainLogin alloc] init];
		[self.navigationController pushViewController:login animated:YES];
		[login release];
		
	} else if(alertView.tag == 10) {
        // deal_id not equal to nil means this screen is called from deal detail page.
        if(deal_id!=nil) {
            if ([alertView.title isEqualToString:@""]) {
                if(self.navigationController.viewControllers.count > 1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }
}

-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:kGeoCodingString,pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    //    [self activeTool:1];
    return YES;
}

// Make sure you are the text fields 'delegate', then this will get called before text gets changed.
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length >= 200 && range.length == 0)
        return NO; // return NO to not change text
    else
        return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate]; // overrided instance to changes status bar that called preferredStatusBarStyle
    [scrollView setScrollEnabled:YES];
	[scrollView setContentSize:CGSizeMake(267, 900)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    [singleTap release];
    [super viewDidLoad];
    
    appDelegate =(MainAppDelegate * ) [[UIApplication sharedApplication] delegate];
    radioButtonsArray = [[NSMutableArray alloc] init];
    TFArray = [[NSMutableArray alloc] init];
    params = [[NSMutableArray alloc] init];
    
    radioButtonsArray = [[NSMutableArray alloc] init];
    TFArray = [[NSMutableArray alloc] init];
    dropArray = [[NSMutableArray alloc] init];
    params = [[NSMutableArray alloc] init];
    paramsDrop = [[NSMutableArray alloc] init];
	surveyArray = [[NSMutableArray alloc] init];
    array_from = [[NSMutableArray alloc] init];
    arrayDrop = [[NSMutableArray alloc] init];
    viewArray = [[NSMutableArray alloc] init];
    buttonArray = [[NSMutableArray alloc] init];
    tempDrop = [[NSString alloc] init];
    dropdowntemp = [[NSMutableArray alloc] init];
    buttonIndex = [[NSMutableArray alloc] init];
    radioTemp = [[NSMutableArray alloc] init];
    toolbar = [[UIToolbar alloc] init];
    checkdropdown = NO;
    // Do any additional setup after loading the view from its nib.
    viewMultiple = [[NSMutableArray alloc] init];
    StringCheckId = [[NSMutableArray alloc] init];
    buttonCheckSum = [[NSMutableArray alloc] init];
    IdMultiple = [[NSMutableArray alloc] init];
    markIndex = [[NSMutableArray alloc] init];
    markButtonArray = [[NSMutableArray alloc] init];
    IdCheckArray = [[NSMutableArray alloc] init];
    
    toolbar = [[UIToolbar alloc] init];
    toolbarCheckBox = [[UIToolbar alloc] init];
    
    imageCheck = [[UIImageView alloc]init];
    
    [ViewMultiple setHidden:YES];
    
    [scrollMultiple setScrollEnabled:YES];
    [scrollMultiple setContentSize:CGSizeMake(267, 600)];
    commentArray = [[NSMutableArray alloc] init];
    
    [indicatorView startAnimating];
    [NSThread detachNewThreadSelector:@selector(fetchSurveyList) toTarget:self withObject:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"checkStatus"];
    finalCountmultiple = 0;
}

- (void)viewDidUnload
{
    [skipBtn release];
    skipBtn = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    
}

- (void) textPress :(UIButton *) sender{
    [self activeTool:3];
    tagButton = sender.tag;
    NSLog(@"%i", tagButton);
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%i", tagButton]] isEqualToString:@"1"]){
        finalCountdropdown = finalCountdropdown + 1;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"%i", tagButton]];
    }
    [self enableBtnSubmit];
    
    for(int b=0; b<[buttonIndex count]; b++){
        NSNumber *rowIndexButton = [buttonIndex objectAtIndex:b];
        NSInteger newIndexButton = [rowIndexButton integerValue];
        button = [dropArray objectAtIndex:newIndexButton];
        NSLog(@"ini button %@", button);
        [button setUserInteractionEnabled:FALSE];
    }
    
    button = [dropArray objectAtIndex:tagButton];
    [button setUserInteractionEnabled:FALSE];
    
    fooIndex = [buttonArray indexOfObject:[NSNumber numberWithInt:tagButton]];
    rowIndex = [dropdowntemp objectAtIndex:fooIndex];
    NSInteger newRow = [rowIndex integerValue];
    
    Survey *survey;
    survey = [surveyArray objectAtIndex:sender.tag];
    array_from = survey.qlabel;
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 300, 320, 360)];
    }else{
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 360, 320, 360)];
    }
    
    [self.view addSubview:myPickerView];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.opaque = YES;
    myPickerView.backgroundColor = [UIColor whiteColor];
    
    if(newRow == 0){
        tempDrop = [array_from objectAtIndex:0];
    }
    
    [myPickerView selectRow:newRow inComponent:0 animated:YES];
    
    //toolbar for dropdown menu for 5 inch
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        toolbar.frame=CGRectMake(0 , 280, 320, 30);

    }else{
        toolbar.frame=CGRectMake(0 , 340, 320, 30);
    }
    
    toolbar.barStyle = UIBarButtonItemStylePlain;
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(aMethod:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,doneButton, nil]];
    [self.view addSubview:toolbar];
    
}

-(void) showMultiple:(UIButton *) sender{
    indexBtnCheck = [buttonCheckSum indexOfObject:[NSNumber numberWithInt:sender.tag]];
    [self activeTool:2];
    [ViewMultiple setHidden:NO];
    
    scrollMultiple.scrollEnabled = YES;
    NSString *test = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkStatus"];
    
    [myPickerView removeFromSuperview];
    [toolbar removeFromSuperview];

            toolbarCheckBox.frame=CGRectMake(0 , ViewMultiple.frame.origin.y+10, 320, 30);
    toolbarCheckBox.barStyle = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButtoncheck = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone target:self
                                                                       action:@selector(doneCheck:)];
    
    [toolbarCheckBox setItems:[NSArray arrayWithObjects:flexibleSpaceLeft,doneButtoncheck, nil]];
    [self.view addSubview:toolbarCheckBox];
    
    if(![test isEqualToString:@"true"]){
        
        int y;
        UIButton *checkBtn =[[UIButton alloc]init];
        for (int i=0; i<[[viewMultiple objectAtIndex:indexBtnCheck]count]; i++) {
            
            if (i==0) {
                y=0;
            }
            else{
                y=y+20;
            }
            
            UILabel *questionlabel=[[UILabel alloc] initWithFrame:CGRectMake(35, y+5, 210, 50)];
            [questionlabel setBackgroundColor:[UIColor clearColor]];
            [questionlabel  setTextColor: [UIColor blackColor]];
            questionlabel.lineBreakMode = UILineBreakModeWordWrap;
            questionlabel.numberOfLines = 2;
            [questionlabel setText:[[viewMultiple objectAtIndex:indexBtnCheck]objectAtIndex:i]];
            
            UIImageView *bgPic = [[[UIImageView alloc] initWithFrame:CGRectMake(0,y+47,320,1)]autorelease];
            bgPic.backgroundColor = [UIColor clearColor];
            [bgPic setImage:[UIImage imageNamed:@"line-sidebar.png"]];
            
            UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake(260, y+15, 25, 25 )];
            iamge.image = [UIImage imageNamed:@"checkBox.png"];
            [iamge setTag:i+1];
            
            checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, y+15, 40, 40 )];
            [checkBtn setTag:i+1];
            checkBtn.backgroundColor = [UIColor clearColor];
            
            [checkBtn addTarget:self
                         action:@selector(markBtn:)
               forControlEvents:UIControlEventTouchUpInside];
            
            NSNumber *anumber = [NSNumber numberWithInteger:i+1];
            [markIndex addObject:anumber];
            [markButtonArray addObject:iamge];
            [scrollMultiple addSubview:questionlabel];
            [scrollMultiple addSubview:bgPic];
            [scrollMultiple addSubview:iamge];
            [scrollMultiple addSubview:checkBtn];
            
            y+=20;
        }
        [scrollMultiple setContentSize:CGSizeMake(219, y+280)];
    }
}

-(IBAction)doneCheck:(id)sender{
    [ViewMultiple setHidden:YES];
    [toolbarCheckBox removeFromSuperview];
    
    NSString *id = [[NSString alloc] init];
    for (int i=0; i<[IdCheckArray count]; i++) {
        if(i == 0){
            id = [NSString stringWithFormat:@"%@",[IdCheckArray objectAtIndex:i]];
        }else{
            id = [id stringByAppendingString:[NSString stringWithFormat:@"-%@", [IdCheckArray objectAtIndex:i]]];
        }
    }
    
    [StringCheckId replaceObjectAtIndex:indexBtnCheck withObject:id];
    [self enableBtnSubmit];
}

-(void) markBtn:(UIButton *) sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"checkStatus"];
    
    for (int i=0; i<[markIndex count]; i++) {
        UIButton *tempButton = [markButtonArray objectAtIndex:i];
        UIImageView *checkImage = [markButtonArray objectAtIndex:i];
        if(sender.tag == tempButton.tag){
            
            NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"check%i", sender.tag]];
            
            if([status isEqualToString:@"true"]){
                checkImage.image = [UIImage imageNamed:@"checkBox"];
                [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:[NSString stringWithFormat:@"check%i", sender.tag]];
                [IdCheckArray removeObject:[[IdMultiple objectAtIndex:0]objectAtIndex:sender.tag - 1]];
            }else{
                checkImage.image = [UIImage imageNamed:@"checkBoxMarked"];
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:[NSString stringWithFormat:@"check%i", sender.tag]];
                [IdCheckArray addObject:[[IdMultiple objectAtIndex:0]objectAtIndex:sender.tag - 1]];
                
            }
        }
    }
    
}

-(void)enableBtnSubmit{
    
    if(([StringCheckId count] >= 1) && ![[StringCheckId objectAtIndex:0] isEqual:@""] )
        finalCountmultiple = 1;
    else if([StringCheckId count] == 0)
        finalCountmultiple = 0;
    else
        finalCountmultiple = 0;
    
    if(finalCountdropdown == [arrayDrop count] && finalNewCount >= [params count] && finalCountmultiple == [paramsDrop count])
        sumitButton.enabled = YES;
    else
        sumitButton.enabled = NO;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    checkdropdown = YES;
    tempDrop = [array_from objectAtIndex:row];
    Survey *survey;
    survey = [surveyArray objectAtIndex:tagButton];
    array_from = survey.qlabel;
    
    [arrayDrop replaceObjectAtIndex:fooIndex withObject:[survey.dropIdArray objectAtIndex:row]];
    [dropdowntemp replaceObjectAtIndex:fooIndex withObject:[NSNumber numberWithInt:row]];
}

-(IBAction)aMethod:(id)sender
{
    button = [dropArray objectAtIndex:tagButton];
    [button setUserInteractionEnabled:TRUE];
    [button setTitle:tempDrop forState:UIControlStateNormal];
    button.titleLabel.textAlignment = UITextAlignmentLeft;
    [myPickerView removeFromSuperview];
    [toolbar removeFromSuperview];
    [doneButton removeFromSuperview];
    [backButton removeFromSuperview];
    
    if([tempDrop length] > 20){
        tempDrop = [tempDrop substringToIndex:20];
        tempDrop = [tempDrop stringByAppendingString:@" ..."];
    }
    
    if(checkdropdown == NO){
        Survey *survey;
        survey = [surveyArray objectAtIndex:tagButton];
        [arrayDrop replaceObjectAtIndex:fooIndex withObject:[survey.dropIdArray objectAtIndex:0]];
    }
    
    for(int b=0; b<[buttonIndex count]; b++){
        NSNumber *rowIndexButton = [buttonIndex objectAtIndex:b];
        NSInteger newIndexButton = [rowIndexButton integerValue];
        button = [dropArray objectAtIndex:newIndexButton];
        NSLog(@"%@", button);
        [button setUserInteractionEnabled:TRUE];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    CGRect frame = CGRectMake(0,0,265,100);
    pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [pickerLabel setTextAlignment:UITextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [pickerLabel setNumberOfLines:2];
    [pickerLabel setText:[array_from objectAtIndex:row]];
    return pickerLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [array_from count];
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [array_from objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
	componentWidth = 250;
	return componentWidth;
}

- (void)dealloc {
    [skipBtn release];
    [surveyTitle release];
    [super dealloc];
}
@end
