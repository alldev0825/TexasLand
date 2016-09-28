#import <Foundation/Foundation.h>

//
//  Constants.h
//
//

///////////////////////trel///////////////////////////////////////

#define BASE_URL				@"http://trelevant.herokuapp.com/api/v1"
#define APPKEY                  @"26JYV15jTwn7xbfs"
#define GOOGLE_ANALYTICS        @"UA-48084549-1"
#define BASE_URL_HTTPS			@"https://trelevant.herokuapp.com/api/v1"
#define TERMS_OF_USE			@"http://trelevant.herokuapp.com/terms_of_use?appkey="
#define FB_PAGE_URL			    @"http://trelevant.herokuapp.com/url/71/facebook"
#define TWITTER_PAGE_URL        @"http://trelevant.herokuapp.com/url/71/twitter"
#define INSTAGRAM_URL           @"http://trelevant.herokuapp.com/url/71/instagram"
#define PRIVACY_POLICY			@"http://trelevant.herokuapp.com/privacy_policy?appkey="
#define MENU_URL                @"http://trelevant.herokuapp.com/url/71/menu"
#define ONLINE_ORDERING_URL     @"http://trelevant.herokuapp.com/url/33/online-ordering"
#define FAQ_URL                 @"http://trelevant.herokuapp.com/url/71/faq"
#define FULL_WEBSITE_URL        @"http://trelevant.herokuapp.com/url/36/full-website"
#define HOST_URL				@"http://trelevant.herokuapp.com"

///////////////////////live///////////////////////////////////////
/*
#define BASE_URL_VNCR			@"https://alapp.relevantmobile.com/api/vncr"
#define BASE_URL				@"https://alapp.relevantmobile.com/api/v1"
#define APPKEY                  @"o6X8a2AqCxoEvEOP"
#define BASE_URL_HTTPS_VNCR		@"https://alapp.relevantmobile.com/api/vncr"
#define BASE_URL_HTTPS			@"https://alapp.relevantmobile.com/api/v1"
#define TERMS_OF_USE			@"https://alapp.relevantmobile.com/terms_of_use?appkey="
#define PRIVACY_POLICY			@"https://alapp.relevantmobile.com/privacy_policy?appkey="
#define FAQ_URL                 @"https://alapp.relevantmobile.com/url/27/faq"
#define MENU_URL          @"https://alapp.relevantmobile.com/url/27/nutrition"

*/

//App Secret:         82af432220fcb53710a6f3692b42acc6
#define FB_APPID				@"669800236480201"
// Variables to identifiy connection problem from ASIHTTPRequest
#define CONNECTION_FAILURE	    @"A connection failure occurred"
#define TIME_OUT				@"The request timed out"
#define LOCALE_HEADER           @"en"
#define SOMETHING_WENT_WRONG @"We are sorry. Something went wrong. Please try again. If problem persists, contact customer support from the info section of the app for further assistance."
#define keyRequestType		    @"RequestType"
#define kOFFSET_FOR_KEYBOARD 80.0
#define kSCROLLOFFSET_FOR_KEYBOARD 0.0
#define KFULLBRIGHTNESS         @"brightness"

#define	ReleaseObject(obj)					if (obj != nil) { [obj release]; obj = nil; }

#define CALL_US_NOW_CELL                                @"CALL_US_NOW_CELL_IDENTIFIER"
#define CALL_US_NOW_CELL_SIGNUP                         @"CALL_US_NOW_CELL_IDENTIFIER_SIGNUP"
#define CALL_US_NOW_CUSTOM_LABEL_NAME                  1
#define CALL_US_NOW_CUSTOM_LABEL_DESCRIPTION       2
#define CALL_US_NOW_CUSTOM_LABEL_DISTANCE       3
#define CALL_US_NOW_CUSTOM_BUTTON_MOBILE       4
#define CALL_US_NOW_CUSTOM_LABEL_PHONE 10
#define CALL_US_NOW_CUSTOM_LABEL_CALL       8
#define CALL_US_NOW_CUSTOM_LABEL_ORDER       9
#define CALL_MAP 500
#define CALL_PHONE 400
#define TEXT_CALL                               5
#define TEXT_PHONE                              6
#define TEXT_ORDER                              7
//
#pragma mark request Type

typedef enum TheRequestTypes
{
    kRegistrationRequest = 1,
    kUserActivityRequest,
    kLogoutRequest,
    kCategoryListRequest,
    kSubmitCategoryRequest,
    kGetRewardsRequest,
    kLoginRequest,
    kgetRestaurantAddressRequest,
    kUpdateRewardClaimRequest,
    kSignUpRequest,
    kDeleteRewardsRequest,
    kGetOfferListRequest,
    kFetchReferralRequest,
    kForgotPasswordRequest,
    kUpdatePasswordRequest,
    kGetUserActivityRequest,
    kGetAllRestaurantsRequest,
    kGetRewardsActivityRequest,
    kSubmitPromoRequest,
    kUpdateGiftClaimRequest,
    kGetKeyChainValue,
    kReqsBarcode,
    kgetSocialShare,
    kPostSocialShare,
    kGetSurvey,
    kGetUserInfok,
    kGetUserEmail,
    kGetPayCode,
    kGetClienToken,
    kGetScanCode,
    kPostCode,
    kGetSearchRestaurantsRequest,
    kGetPaymentMethod,
    kpostCC,
    KgetSettingCC,
    kGetGalleryStream,
    KpostCCRelevant,
    kGetEmailForgot,
    kOrderPostSuccess,
    kgetRestaurantAddressSearch
} ServerRequestType;

#pragma mark Keys

