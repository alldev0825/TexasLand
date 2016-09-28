//
//  Reward.h
//  
//

#import <Foundation/Foundation.h>


@interface Reward : NSObject {

	NSString *rewardId, *POSCode, *chainId, *effectiveDate, *expiryDate, *fineprint, 
    *rewardName, *rewardPoints, *rewardType, *rewardSurveyId, *rewardExpired, *totalPoints , *sortId, *gifter, *rewardURL;
    
}

@property (nonatomic,retain) NSString *rewardId, *POSCode, *chainId, *effectiveDate, *expiryDate, *fineprint, *rewardName, *rewardPoints, *rewardType, *rewardSurveyId, *rewardExpired, *totalPoints , *sortId, *gifter, *rewardURL;
@end
