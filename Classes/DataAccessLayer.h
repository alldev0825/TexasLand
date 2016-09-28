//
//  DataAccessLayer.h
//  

#import <Foundation/Foundation.h>


@interface DataAccessLayer : NSObject {

}

+(NSString *)getSurveyList:(NSString *)appKey 
                  surveyId:(NSString *) surveyId 
                     token:(NSString *) token;
+(NSString *)signUpCall:(NSData *)data;
+(NSString *)loginCall:(NSData *)data;
+(NSString *)logoutCall:(NSString *)authToken appkey:(NSString *)appkey;
+(NSString *)getAllRestaurants:(NSString *)appKey latitude:(float )lat longitude:(float )lng;
+(NSString *) forgotPasswordCall:(NSData *)data;
+(NSString *) getUserRewards:(NSString *)appKey
                  authToken : (NSString *)authToken;
+(NSString *) getUserActivity:(NSString *)appKey
                   authToken : (NSString *)authToken;
+(NSString *) getUserDetails:(NSString *)authToken;
+(NSString *) updatePassword:(NSData *)data;
+(NSString *) submitSurveyAnswers:(NSData *)data
                         surveyId: (NSString *) surveyId;
+(NSString *) claimReward:(NSData *)data;
+(NSString *) getRestaurantAddress:(NSString *)appKey
                        authToken : (NSString *)authToken;
+(NSString *) deleteReward:(NSString *)rid andAuthToken:(NSString *)authToken;
+(NSString *) getstartApplicationUrl:(NSString *) appKey;
+(NSString *) submitPromo:(NSData *)data;
+(NSString *) getDeals: (NSString *) appKey;
+(NSData *) downloadData: (NSString *) url;
+(NSString *) getDealDetail: (NSString *) appKey ofDealId: (NSString *) dealId;


+(NSString *) getCheckinLocations: (NSString *) appKey authToken: (NSString *) authToken dealId: (NSString *)dealId latitude: (float) lat longitude: (float) lng;

+(NSString *) checkInLocation:(NSData *)data;

+(NSString *)getAllLocations:(NSString *)appKey latitude:(float )lat longitude:(float )lng;


@end
