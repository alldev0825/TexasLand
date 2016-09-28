//
//  Offers.h
//  
//
#import <Foundation/Foundation.h>

@interface Offers : NSObject {
    NSString *chainId_Offer,*offerId_Offer, *name_Offer,*surveyId_Offer,*address_Rest,*appDisplayText_Rest,*restaurantId_Rest,*latitude_Rest, *longitude_Rest, *name_Rest, *phoneNumber_Rest, *zipcode_Rest, *receiptId_Survey;
    NSString *rest_distance, *preset_distance_status;
    NSString *rest_openAt, *rest_closeAt;
}
@property(nonatomic,retain) NSString *chainId_Offer,*offerId_Offer, *name_Offer,*surveyId_Offer,*address_Rest,*appDisplayText_Rest,*restaurantId_Rest,*latitude_Rest, *longitude_Rest, *name_Rest, *phoneNumber_Rest, *zipcode_Rest,*receiptId_Survey;
@property(nonatomic, retain) NSString *rest_distance, *preset_distance_status;
@property(nonatomic, retain) NSString  *rest_openAt, *rest_closeAt;

@end
