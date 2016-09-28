//
//  SurveyFormController.h
//
//

#import <UIKit/UIKit.h>
#import "Offers.h"

@class MainAppDelegate;
@interface SurveyFormController : UIViewController <UITextViewDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UIActivityItemSource, UITextFieldDelegate> {
    
    UIPickerView *myPickerView;
    UIButton *doneButton;
    UIImageView *backButton;
    NSMutableArray *array_from;
    NSMutableArray *arrayDrop;
    UIToolbar *toolbar;
    IBOutlet UITextField *textDrop;
    IBOutlet UIButton *button;
    
    IBOutlet UIButton *skipBtn;
    MainAppDelegate *appDelegate;
    NSMutableArray *questionValues;
    
    IBOutlet UIActivityIndicatorView *indicatorView;
    NSMutableArray *radioButtonsArray;
    NSMutableArray *TFArray;
    NSMutableArray *dropArray;
    NSMutableArray *buttonArray;
    NSMutableArray *radioTemp;
    NSMutableArray *dropdowntemp;
    NSMutableArray *viewArray;
    NSMutableArray *buttonIndex;
    
    IBOutlet UILabel *surveyTitle;
    IBOutlet UIButton *sumitButton;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *params,*quesParamList, *paramsDrop;
    NSMutableString *ansParamList ;
    //Offers *offer;
    IBOutlet UITextField *commentField;
    IBOutlet UILabel *headerLabel;
	int startingId;
    int viewFlag;
    NSString *restaurant_name;
    NSString *receipt_date;
	
	NSMutableArray *surveyArray;
    
    NSString *survey_id;
    NSString *receipt_id;
    NSString *deal_id;
    NSString *tempDrop;
	//NSMutableArray *surveyArray;
    NSInteger finalCount;
    NSInteger finalNewCount;
    NSInteger finalCountdropdown;
    NSNumber *rowIndex;
    BOOL checkdropdown;

    
    IBOutlet UIView *ViewMultiple;
    IBOutlet UIScrollView *scrollMultiple;
    
    IBOutlet UILabel *txtLblMultilple;
    IBOutlet UIButton *buttonCheck;
    NSMutableArray *viewMultiple;
    NSMutableArray *StringCheckId;
    NSMutableArray *buttonCheckSum;
    NSMutableArray *IdMultiple;
    NSMutableArray *markIndex;
    NSMutableArray *markButtonArray;
    NSMutableArray *IdCheckArray;
    
    UIToolbar *toolbarCheckBox;
    
    UIImageView *imageCheck;
    
    NSInteger finalCountmultiple;
    NSMutableArray *commentArray;

}
//-(id)initWithDeal:(Offers *)de;
-(id)initWithSurveyId:(NSString *)surveyId andReceiptId:(NSString *) receiptId andDealId:(NSString *) dealId;
-(IBAction) backButtonAction;
-(IBAction) submitButtonPressed;
-(IBAction) hideKeyboard;

- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textDrop;
@property (strong, nonatomic) IBOutlet UIButton *button;
@end
