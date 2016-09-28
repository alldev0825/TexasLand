//
//  Utils.m
//  ZoesKitchen
//
//  Created by Ajay Kumar on 25/08/12.
//  Copyright (c) 2012 Mycompany. All rights reserved.
//

#import "Utils.h"
#import "DeviceHardware.h"

@implementation Utils

@synthesize imageDownloadsInProgress;

-(void) dealloc
{
    [imageDownloadsInProgress release];
    [super dealloc];
}

#pragma mark email validation
+ (BOOL)emailValidate:(NSString *)email
{
	//Based on the string below
	//NSString *strEmailMatchstring=@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
	
	//Quick return if @ Or . not in the string
	if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound)
		//NSLog(@"%@",[email rangeOfString:@"@"]);
		//			NSLog(@"%@",[email rangeOfString:@"."]);
		return YES;
	
	//Break email address into its components
	NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
	NSLog(@"%@",accountName);
	email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
	NSLog(@"%@",email);
	//'.' not present in substring
	if([email rangeOfString:@"."].location==NSNotFound)
		return YES;
	NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
	NSLog(@"%@",domainName);
	
	NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
	NSLog(@"%@",subDomain);
	
	//username, domainname and subdomain name should not contain the following charters below
	//filter for user name
	NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;':\"<>,?/`";
	//filter for domain
	NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;':\"<>,+?/`";
	//filter for subdomain
	NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";'<>,?/1234567890";
	
	//subdomain should not be less that 2 and not greater 6
	if(!(subDomain.length>=2 && subDomain.length<=6)) 
		return YES;
	
	if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
		return YES;
	
	return NO;
}

//distance calculation..
+ (double) calculateDistance:(double)nLat1 second:(double)nLon1 third:(double)nLat2 fourth:(double)nLon2
{
    CLLocation *currentLoc = [[[CLLocation alloc] initWithLatitude:nLat1 longitude:nLon1] autorelease];
    CLLocation *restaurnatLoc = [[[CLLocation alloc] initWithLatitude:nLat2 longitude:nLon2] autorelease];
    CLLocationDistance meters = [restaurnatLoc distanceFromLocation:currentLoc];
    return meters;
}
+ (NSDate*)localDateStringForISODateTimeString:(NSString*)ISOString
{
    // Configure the ISO formatter
    NSString *timeZoneString = [ISOString substringFromIndex:19];
    NSString *dateString = [ISOString substringToIndex:19];

    NSDateFormatter* isoDateFormatter = [[NSDateFormatter alloc] init];
    int zoneOffset = (60 * 60 * timeZoneString.intValue);
    isoDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:zoneOffset];
    [isoDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    // Configure user local formatter (configure this for how you want
    // your user to see the date string)
    NSDateFormatter* userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Convert the string -- this date can now also just be used
    // as the correct date object for other calculations and/or
    // comparisons
    NSDate* date = [isoDateFormatter dateFromString:ISOString];
    
    // Return the string in the user's locale and time zone
    //return [isoDateFormatter dateFromString:ISOString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:zoneOffset];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *theDate = [formatter dateFromString:dateString];
    return [formatter dateFromString:dateString];
}

/* Function for getting current date and time from system*/
+ (NSString*)getCurrentDateAndTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    NSString *dateString = [[NSString alloc] initWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]]; 
    [dateFormatter release];
    return [dateString autorelease];
    
}

////////Generating UIColor from Hexa code.//////////
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert{
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

+(NSString *)checkDevice
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NSString *platformString = [DeviceHardware platformString];
        return platformString;
    }
    else
    {
        return @"iPad";
    }
}

@end
