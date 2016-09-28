
#import "Server.h"
#import "Reachability.h"
//#import "NSString+SBJSON.h"
//#import "GSNSDataExtensions.h"


@implementation Server

@synthesize delegate;

- (NSMutableURLRequest*)registrationWithDict:(NSDictionary*)userInfo
{
    
    //NSString *urlString = [NSString stringWithFormat:@"%@user_registration.php",kBaseUrl];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    NSMutableURLRequest *request = nil;
    NSString *keyValues = nil;
    NSString *urlString = [NSString stringWithFormat:@"%@user-login.php",BASE_URL];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    //  keyValues = [NSString stringWithFormat:@"username=%@&first_name=%@&last_name=%@&lattitude=%@&longitude=%@&profile_pic=%@&token=%@&uid=%@&email=%@",[userInfo objectForKey:kEmail],[userInfo objectForKey:kFirst_name],[userInfo objectForKey:kLast_name],[userInfo objectForKey:kLatitude],[userInfo objectForKey:kLongitude],[userInfo objectForKey:kProfile_pic],[userInfo objectForKey:kToken],[userInfo objectForKey:kUid],[userInfo objectForKey:kEmail]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

- (NSMutableURLRequest*)activityRequestWithDict:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/version/latest?",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@",[userInfo objectForKey:@"appkey"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //     NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/version/latest?appkey=%@",BASE_URL,[userInfo objectForKey:@"appkey"]]]] retain];
    return request;
    
}



- (NSMutableURLRequest*)categoryListRequestWithDict:(NSDictionary*)userInfo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/categories?auth_token=%@&appkey=%@",BASE_URL,[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"]]]] retain];
    return request;
}

- (NSMutableURLRequest*)SubmitCategoryRequest:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/categories/select",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    NSString *keyValues = [NSString stringWithFormat:@"auth_token=%@&appkey=%@&category_ids=%@",[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"category_ids"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)getUserRewardsRequestWithDict:(NSDictionary*)userInfo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/rewards?auth_token=%@&appkey=%@&device_timestamp=%@&locale=%@",BASE_URL,[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"device_timestamp"],LOCALE_HEADER] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] retain];
    return request;
}


- (NSMutableURLRequest*)submitLoginRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/login",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"email=%@&password=%@&register_type=%@&appkey=%@&sign_in_device_type=%@&device_token=%@&phone_model=%@&os=%@&keychain=%@",[userInfo objectForKey:@"email"],[userInfo objectForKey:@"password"],[userInfo objectForKey:@"register_type"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"sign_in_device_type"],[userInfo objectForKey:@"device_token"],[userInfo objectForKey:@"phone_model"],[userInfo objectForKey:@"os"],[userInfo objectForKey:@"keychain"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)submitUserBarcodeRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/receipts/upload?appkey=%@&auth_token=%@&barcode=%@&offer_id=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"barcode"],[userInfo objectForKey:@"offer_id"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)updateRewardClaimRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/rewards/claim",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&reward_id=%@&lat=%@&lng=%@&location=%@&warn=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"reward_id"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"lng"],[userInfo objectForKey:@"location"],[userInfo objectForKey:@"warn"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)getRestaurantAddressRequestWithDict:(NSDictionary*)userInfo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/rewards/locate?auth_token=%@&appkey=%@&lat=%@&lng=%@",BASE_URL,[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"lng"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] retain];
    return request;
}

- (NSMutableURLRequest*)signUpCallRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/signup",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"email=%@&password=%@&latitude=%@&longitude=%@&register_device_type=%@&register_type=%@&appkey=%@&sign_in_device_type=%@&device_token=%@&referral_code=%@&favorite_location=%@&os=%@&keychain=%@&dob_day=%@&dob_month=%@&dob_year=%@&marketing_optin=%@&first_name=%@",[userInfo objectForKey:@"email"],[userInfo objectForKey:@"password"],[userInfo objectForKey:@"latitude"],[userInfo objectForKey:@"longitude"],[userInfo objectForKey:@"register_device_type"],[userInfo objectForKey:@"register_type"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"sign_in_device_type"],[userInfo objectForKey:@"device_token"],[userInfo objectForKey:@"referral_code"],[userInfo objectForKey:@"favorite_location"], [userInfo objectForKey:@"os"],[userInfo objectForKey:@"keychain"],[userInfo objectForKey:@"dob_day"],[userInfo objectForKey:@"dob_month"],[userInfo objectForKey:@"dob_year"],[userInfo objectForKey:@"marketing_optin"],[userInfo objectForKey:@"first_name"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)skipSurveyPullRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/survey/skip",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&survey_id=%@&receipt_id=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"survey_id"],[userInfo objectForKey:@"receipt_id"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*)getSurveyPullRequestWithDict:(NSDictionary*)userInfo
{
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/survey/pull?auth_token=%@&appkey=%@",BASE_URL,[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] retain];
    return request;
}


//+(NSString *) deleteReward:(NSString *)rid andAuthToken:(NSString *)authToken
- (NSMutableURLRequest*)deleteRewardRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/rewards/%@?appkey=%@&auth_token=%@&locale=%@",BASE_URL,[userInfo objectForKey:@"rewardId"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],LOCALE_HEADER];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"DELETE"];
    //[request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)logoutRequestWithDict:(NSDictionary*)userInfo
{
    
    //    BASE_URL_HTTPS stringByAppendingFormat:@"/user/logout?auth_token=%@&appkey=%@&locale=%@"
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/logout?appkey=%@&auth_token=%@",BASE_URL_HTTPS,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)getOfferListRequestWithDict:(NSDictionary*)userInfo
{
    //NSString *url = [BASE_URL stringByAppendingFormat:@"/offers/nearby?appkey=%@&lat=%f&lng=%f",appKey,lat,lng];
    NSString *urlString = [NSString stringWithFormat:@"%@/offers/nearby?appkey=%@&lat=%@&lng=%@&locale=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"lng"],LOCALE_HEADER];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
    
}

- (NSMutableURLRequest*)fetchReferralRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/referral/email?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)forgotPasswordRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/forgot_password",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&email=%@&register_type=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"email"],[userInfo objectForKey:@"register_type"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*)updatePasswordRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/update_password",BASE_URL_HTTPS];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&password=%@&current_password=%@&password_confirmation=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"password"],[userInfo objectForKey:@"current_password"],[userInfo objectForKey:@"password_confirmation"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*)getUserActivityRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/activity?appkey=%@&auth_token=%@&locale=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],LOCALE_HEADER];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)getRewardsActivityRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/rewards/activity?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)getAllRestaurantsRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restaurants/nearby?appkey=%@&lat=%@&lng=%@&locale=%@&distance=0",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"lng"],LOCALE_HEADER];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)getSearchRestaurantsRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/restaurants/nearby?appkey=%@&lat=%@&lng=%@&search=%@&locale=%@&distance=0",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"lng"],[userInfo objectForKey:@"search"],LOCALE_HEADER];
    
    NSLog(@"rewr ==============%@", urlString );
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)getCheckinLocationsRequestWithDict:(NSDictionary*)userInfo
{
    //NSString *url = [BASE_URL stringByAppendingFormat:@"/checkin/locations?appkey=%@&auth_token=%@&dealid=%@&userlat=%f&userlong=%f&locale=%@",appKey, authToken, dealId, lat,lng,LOCALE_HEADER];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/update_password",BASE_URL_HTTPS];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&dealid=%@&userlat=%@&userlong=%@&locale=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"dealid"],[userInfo objectForKey:@"userlat"],[userInfo objectForKey:@"userlong"],LOCALE_HEADER];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)submitPromoRequestWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/promocode",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&code=%@&force=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"code"],[userInfo objectForKey:@"force"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)getGiftClaimWithDict:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/rewards/gift",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&reward_id=%@&warn=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"reward_id"],[userInfo objectForKey:@"warn"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)getKeyChainValue:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/keychain/generate",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@",[userInfo objectForKey:@"appkey"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)PostSocialShare:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/social_shares/user_interaction",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@&auth_token=%@&medium=%@",[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"medium_id"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (NSMutableURLRequest*)PostCode:(NSDictionary*)userInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/receipts/code",BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    NSString *keyValues = [NSString stringWithFormat:@"auth_token=%@&appkey=%@&barcode=%@",[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"barcode"]];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (NSMutableURLRequest*)getSocialShare:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/social_shares?appkey=%@",BASE_URL,[userInfo objectForKey:@"appkey"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)GetScanCode:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/receipts/upload?appkey=%@&auth_token=%@&barcode=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"barcode"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)GetPayCode:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/pay_code?appkey=%@&auth_token=%@&lat=%@&long=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"],[userInfo objectForKey:@"lat"],[userInfo objectForKey:@"long"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)GetClienToken:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/braintree/client_token?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}

- (NSMutableURLRequest*)GetSurvey:(NSDictionary*)userInfo
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/survey?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    return request;
}



- (NSMutableURLRequest*)GetUserInfo:(NSDictionary*)userInfo
{
    
    //    NSString *urlString = [NSString stringWithFormat:@"%@/user/code?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    //
    //    return request;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/user/code?appkey=%@&auth_token=%@",BASE_URL,[userInfo objectForKey:@"appkey"],[userInfo objectForKey:@"auth_token"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] retain];
    return request;
    
    //    NSString *urlString = [NSString stringWithFormat:@"%@/user/code",BASE_URL];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    //
    //    NSString *keyValues = [NSString stringWithFormat:@"appkey=%@",[userInfo objectForKey:@"auth_token"]];
    //
    //    [request setHTTPMethod:@"GET"];
    ////    [request setHTTPBody:[keyValues dataUsingEncoding:NSUTF8StringEncoding]];
    //    return request;
}

#pragma mark *******************************************************************************************
#pragma mark sendRequestToServer
- (void) sendRequestToServer:(NSDictionary*)userInfo
{
    
    // if Device is not connected with internet
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    //if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaCarrierDataNetwork))
    if (internetStatus == NotReachable)
    {
        
        [self.delegate requestNetworkError];
        
        /*[Utils stopActivityIndicatorInView:self.view];
         RMUIAlertView*	aAlert = [[RMUIAlertView alloc] initWithTitle:@"Error" message:@"Internet connection is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [aAlert show];
         [aAlert release];*/
        return;
    }
    
    // Request
    NSMutableURLRequest *request = nil;
    NSInteger currentRequestType1= ((NSNumber*)[userInfo objectForKey:keyRequestType]).intValue;
    NSLog(@"log %li", (long)currentRequestType1);
    switch (currentRequestType1)
    {
        case kRegistrationRequest:
            request = [[self registrationWithDict:userInfo]retain];
            break;
            
        case kUserActivityRequest:
            request = [[self activityRequestWithDict:userInfo]retain];
            break;
            
        case kLogoutRequest:
            request = [[self logoutRequestWithDict:userInfo]retain];
            break;
            
        case kgetRestaurantAddressSearch:
            request = [[self getSearchRestaurantsRequestWithDict:userInfo] retain];
            break;
            
            
        case kCategoryListRequest:
            request = [[self categoryListRequestWithDict:userInfo]retain];
            break;
            
        case kSubmitCategoryRequest:
            request = [[self SubmitCategoryRequest:userInfo]retain];
            break;
            
        case kGetRewardsRequest:
            request = [[self getUserRewardsRequestWithDict:userInfo]retain];
            break;
            
        case kLoginRequest:
            request = [[self submitLoginRequestWithDict:userInfo]retain];
            break;
            
        case kgetRestaurantAddressRequest:
            request = [[self getRestaurantAddressRequestWithDict:userInfo]retain];
            break;
            
        case kUpdateRewardClaimRequest:
            request = [[self updateRewardClaimRequestWithDict:userInfo]retain];
            break;
            
        case kSignUpRequest:
            request = [[self signUpCallRequestWithDict:userInfo]retain];
            break;
            
        case kDeleteRewardsRequest:
            request = [[self deleteRewardRequestWithDict:userInfo]retain];
            break;
            
        case kGetOfferListRequest:
            request = [[self getOfferListRequestWithDict:userInfo]retain];
            break;
            
        case kFetchReferralRequest:
            request = [[self fetchReferralRequestWithDict:userInfo]retain];
            break;
            
        case kForgotPasswordRequest:
            request = [[self forgotPasswordRequestWithDict:userInfo]retain];
            break;
            
        case kUpdatePasswordRequest:
            request = [[self updatePasswordRequestWithDict:userInfo]retain];
            break;
            
        case kGetUserActivityRequest:
            request = [[self getUserActivityRequestWithDict:userInfo]retain];
            break;
            
        case kGetAllRestaurantsRequest:
            request = [[self getAllRestaurantsRequestWithDict:userInfo]retain];
            break;
            
        case kGetRewardsActivityRequest:
            request = [[self getRewardsActivityRequestWithDict:userInfo]retain];
            break;
            
        case kSubmitPromoRequest:
            request = [[self submitPromoRequestWithDict:userInfo]retain];
            break;
            
        case kUpdateGiftClaimRequest:
            request = [[self getGiftClaimWithDict:userInfo]retain];
            break;
            
        case kGetKeyChainValue:
            request = [[self getKeyChainValue:userInfo]retain];
            break;
            
        case kReqsBarcode:
            request = [[self submitUserBarcodeRequestWithDict:userInfo] retain];
            break;
            
        case kgetSocialShare:
            request = [[self getSocialShare:userInfo] retain];
            break;
            
        case kPostSocialShare:
            request = [[self PostSocialShare:userInfo] retain];
            break;
            
        case kGetSurvey:
            request = [[self GetSurvey:userInfo] retain];
            break;
            
        case kGetUserInfok:
            request = [[self GetUserInfo:userInfo] retain];
            break;
            
        case kGetClienToken:
            request = [[self GetClienToken:userInfo] retain];
            break;
            
        case kGetScanCode:
            request = [[self GetScanCode:userInfo] retain];
            break;
        case kPostCode:
            request = [[self PostCode:userInfo] retain];
            break;

            
            
      
            
            
    }
    
    NSLog(@"Is main thread %@", ([NSThread isMainThread] ? @"Yes" : @" NOT"));
    NSURLConnection* theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    ReleaseObject(request);
    
    if (theConnection)
    {
        receivedData=[[NSMutableData data] retain];	// CLANG IGNORE
    }
    // [theConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger responseStatusCode_get2 = [httpResponse statusCode]; //[responseStatusCode intValue]; // the status code is 0
    //NSLog(@"code = %d",responseStatusCode_get2);
    if (responseStatusCode_get2 == 401) {
        [self.delegate requestFinished:@"401"];
    }
    [receivedData setLength:0];
}


- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receivedData appendData:data];
}


- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)connError
{
    
    //NSError *error = [connError retain];
    /*RMUIAlertView* av = [[RMUIAlertView alloc] initWithTitle:@"Network Error" message:[connError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [av show];
     [av release];*/
    
    [self.delegate requestError:[connError localizedDescription]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSString *string = [[NSString alloc] initWithData: receivedData encoding: NSUTF8StringEncoding];
    
    //    NSDictionary *jsonArray = [string JSONFragmentValue];
    //
    //    ReleaseObject(daataArray);
    //    daataArray = [[NSMutableArray alloc] init];
    //
    //
    //
    //    if(jsonArray)
    //        [daataArray addObject:jsonArray];
    [self.delegate requestFinished:string];
    [string release];
    ReleaseObject(connection);
    
}

#pragma mark Authentication Delegate Methods

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialWithUser:@"ajay4@gmail.com" password:@"123456" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    NSLog(@"chalenging protection space authentication checking");
}


// Web service responce result
-(NSMutableArray*)getResults
{
    
    // NSLog(@"daataArray %@",daataArray);
    return daataArray;
    
}

-(void) dealloc
{
    [receivedData release];
    [daataArray release];
    [super dealloc];
    
}

@end