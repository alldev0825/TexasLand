//
//  User.h
//  
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
    
	NSString *chainId,
    *createdAt,
    *cryptedPassword,
    *deviceID,
    *email,
    *facebookID,
    *firstName,
    *id_User,
    *lastName,
    *latitude,
    *longitude,
    *persistenceToken,
    *points,
    *registerDeviceType,
    *registerType,
    *twitterID,
    *updatedAt,
    *username;

    
}
@property (nonatomic, retain) NSString *chainId,*createdAt,*cryptedPassword,*deviceID,*email,*facebookID,*firstName,*id_User,*lastName,*latitude,*longitude,*persistenceToken,*points,*registerDeviceType,*registerType,*twitterID,*updatedAt,*username;

@end
