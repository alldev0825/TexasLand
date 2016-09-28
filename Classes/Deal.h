//
//  Deal.h
//  
//
#import <Foundation/Foundation.h>


@interface Deal : NSObject {
	NSString *resturantId, *name, *website, *priceRange, *rating;
	NSString *contact, *offerId, *description, *todayOffer, *offerDate;
	NSString *offerTitle, *offerImage1, *offerImage2, *weblink;
	
	NSString *discountOffer, *city, *latitude, *longitude;
	NSString  *address, *distance,  *pointsMultiplier,  *MiniDescription,*offerDetails,*offerStartDate, *offerEndDate, *message;
	
	NSString *displayText;
	
}
@property (nonatomic, retain) NSString *resturantId, *name, *website,  *priceRange, *rating , *displayText;
@property (nonatomic, retain) NSString *contact, *offerId, *description, *todayOffer, *offerDate;
@property (nonatomic, retain) NSString *offerTitle, *offerImage1, *offerImage2, *weblink;
@property (nonatomic, retain) NSString *discountOffer, *city, *latitude, *longitude;
@property (nonatomic, retain) NSString *address, *distance, *pointsMultiplier, *MiniDescription,*offerDetails, *offerStartDate, *offerEndDate, *message;
@end
