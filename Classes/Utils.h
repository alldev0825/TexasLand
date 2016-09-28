//
//  Utils.h
//  ZoesKitchen
//
//  Created by Ajay Kumar on 25/08/12.
//  Copyright (c) 2012 Mycompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject
{
    NSMutableDictionary *imageDownloadsInProgress;

}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

+ (BOOL)emailValidate:(NSString *)email;
+ (double) calculateDistance:(double)nLat1 second:(double)nLon1 third:(double)nLat2 fourth:(double)nLon2;
+ (NSDate*)localDateStringForISODateTimeString:(NSString*)ISOString;
+ (NSString*)getCurrentDateAndTime;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+(NSString *)checkDevice;
@end
