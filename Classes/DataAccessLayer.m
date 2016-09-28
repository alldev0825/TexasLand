//
//  DataAccessLayer.m
//  

#import "DataAccessLayer.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"



@implementation DataAccessLayer


+(NSString *)getSurveyList:(NSString *)appKey surveyId:(NSString *) surveyId token:(NSString *) token 
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/survey/%@?appkey=%@&auth_token=%@&locale=%@",surveyId,APPKEY, token, LOCALE_HEADER];
		NSLog(@" Url hit ::::::::: %@" , url);
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		//[request setUseCookiePersistence:NO];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@" Survey List Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Survey List The following error occurred: %@", error);
			responseStr = [error localizedDescription]; 
			
		}
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"Survey List responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
		
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}
+(NSString *)signUpCall:(NSData *)data
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL_HTTPS stringByAppendingFormat:@"/user/signup"];
		NSLog(@" Url hit ::::::::: %@" , url);
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"SignUp call Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"SignUp call The following error occurred: %@", error);
			responseStr = [error localizedDescription]; 
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *)loginCall:(NSData *)data
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL_HTTPS stringByAppendingFormat:@"/user/login"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Login call Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Login call The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *)logoutCall:(NSString *)authToken appkey:(NSString *)appkey
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL_HTTPS stringByAppendingFormat:@"/user/logout?auth_token=%@&appkey=%@&locale=%@",authToken,appkey,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Logout call Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Logout call The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *)getAllRestaurants:(NSString *)appKey latitude:(float )lat longitude:(float )lng{

	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/offers/nearby?appkey=%@&lat=%f&lng=%f&locale=%@",appKey,lat,lng,LOCALE_HEADER];
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];

		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getallrestaurants Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getallrestaurants The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) forgotPasswordCall:(NSData *)data
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/user/forgot_password"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
	[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Forget Password Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Forget Password The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) getstartApplicationUrl:(NSString *) appKey{
    
	NSString *responseStr;
	@try{
		NSString *url= [BASE_URL stringByAppendingFormat:@"/version/latest?appkey=%@&locale=%@",appKey,LOCALE_HEADER];
		//[@"http://demo.relevantmobile.com/api/v1/version/latest?" stringByAppendingFormat:@"appkey=%@",appKey];

		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Latest app Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Latest app The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}
 
+(NSString *) getUserRewards:(NSString *)appKey authToken : (NSString *)authToken
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/rewards?auth_token=%@&appkey=%@&locale=%@",authToken,appKey,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];		
		[request startSynchronous];
        [request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Get user rewards Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Get user rewards The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"get user rewards responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
       
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) getUserActivity:(NSString *)appKey
                  authToken : (NSString *)authToken
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/user/activity?auth_token=%@&appkey=%@&locale=%@",authToken,appKey,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"UserActivity Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"UserActivity The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"User activity responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
       
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}


+(NSString *) getUserDetails:(NSString *)authToken
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/user/profile?auth_token=%@&locale=%@",authToken,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"User details Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"User details The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"User details responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
		
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}


+(NSString *) updatePassword:(NSData *)data
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL_HTTPS stringByAppendingFormat:@"/user/update_password"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"update password Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"update password The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"update password responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) submitSurveyAnswers:(NSData *)data
                         surveyId: (NSString *) surveyId
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/survey/%@/answer",surveyId];
		NSLog(@" Url hit ::::::::: %@" , url);
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"Submit Survey Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"Submit Survey - The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
      
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) claimReward:(NSData *)data
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/rewards/claim"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"claimReward Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"claimReward The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"claimReward responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
       
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) getRestaurantAddress:(NSString *)appKey
                   authToken : (NSString *)authToken
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/rewards/locate?auth_token=%@&appkey=%@&locale=%@",authToken,appKey,LOCALE_HEADER];
		NSLog(@" Url hit ::::::::: %@" , url);
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getRestaurantAddress Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getRestaurantAddress The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) deleteReward:(NSString *)rid andAuthToken:(NSString *)authToken 
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/rewards/%@?appkey=%@&auth_token=%@&locale=%@",rid,APPKEY,authToken,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"DELETE"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		[request setShouldAttemptPersistentConnection:NO];
		//[request appendPostData:data];
		[request startSynchronous];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"deleteReward Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"deleteReward The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"deleteReward responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
       
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}


+(NSString *) submitPromo:(NSData *)data 
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/promocode"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"submitPromo Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"submitPromo The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) getDeals: (NSString *) appKey
{

	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/deals?appkey=%@&locale=%@",appKey,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getDeals Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getDeals The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured in getDeals: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSData *) downloadData: (NSString *) url
{
    //NSString *responseStr;
    NSData* responseData;
	@try{
		//NSString *url = [[NSString alloc ] initWithString:urlToDownload];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseData = [[request responseData] retain];
			NSLog(@"getDeals Response JSON: %d", [responseData length]);
		}
		else {
			NSLog(@"getDeals The following error occurred: %@", error);
			responseData = nil;
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured in getDeals: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseData autorelease];
}

+(NSString *) getDealDetail: (NSString *) appKey ofDealId: (NSString *) dealId
{
    
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/deals/detail?appkey=%@&locale=%@&dealid=%@",appKey,LOCALE_HEADER, dealId];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getDealDetail Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getDealDetail The following error occurred: %@", error);
			responseStr = [error localizedDescription];
		}
	}@catch(NSException *e){
		NSLog(@"exception occured in getDeals: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) getCheckinLocations: (NSString *) appKey authToken: (NSString *) authToken dealId: (NSString *)dealId latitude: (float) lat longitude: (float) lng {
    NSString *responseStr;
	@try{
        //frelevant.herokuapp.com/api/v1/checkin/locations?appkey=YOclRkifmE5rkhQj&locale=en&dealid=25&userlat=42.676&userlong=-73.467668&auth_token=rsDqB1aBoTzzZhRLYdQq
        //appkey=YOclRkifmE5rkhQj&locale=en&dealid=25&userlat=42.676&userlong=-73.467668&auth_token=rsDqB1aBoTzzZhRLYdQq
		NSString *url = [BASE_URL stringByAppendingFormat:@"/checkin/locations?appkey=%@&auth_token=%@&dealid=%@&userlat=%f&userlong=%f&locale=%@",appKey, authToken, dealId, lat,lng,LOCALE_HEADER];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getCheckinLocations Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getCheckinLocations The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *) checkInLocation:(NSData *)data
{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/checkin/submit"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setRequestMethod:@"POST"];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		
		[request appendPostData:data];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"checkInLocation Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"checkInLocation The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
		
		int responseStatusCode = [request responseStatusCode]; 
        NSLog(@"checkInLocation responseStatusCode: %d", responseStatusCode);
        if (responseStatusCode == 401) {
            responseStr = @"401";
        }
        
	}@catch(NSException *e){
		NSLog(@"checkInLocation exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}

+(NSString *)getAllLocations:(NSString *)appKey latitude:(float)lat longitude:(float)lng{
	NSString *responseStr;
	@try{
		NSString *url = [BASE_URL stringByAppendingFormat:@"/restaurants/nearby?appkey=%@&lat=%f&lng=%f&locale=%@&distance=0",appKey,lat,lng,LOCALE_HEADER];

		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request addRequestHeader:@"Content-type" value:@"application/x-www-form-urlencoded"];
		[request startSynchronous];
		[request setShouldAttemptPersistentConnection:NO];
		NSError *error = [request error];
		if (!error) {
			responseStr = [[request responseString] retain];
			NSLog(@"getAllLocations Response JSON: %@", responseStr);
		}
		else {
			NSLog(@"getAllLocations The following error occurred: %@", error);
			responseStr = [error localizedDescription];
			
		}
	}@catch(NSException *e){
		NSLog(@"exception occured: %@", e.reason);
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return [responseStr autorelease];
}


@end
