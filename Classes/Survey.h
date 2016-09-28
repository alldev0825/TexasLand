//
//  Survey.h
//  
//
#import <Foundation/Foundation.h>

@interface Survey : NSObject {
    NSString *qId, *qtype, *qtext, *noofoptions;
    NSMutableArray  *choicesArray;
    NSMutableString *choices;
    NSMutableArray *qlabel;
    NSMutableArray *dropIdArray;
}
@property(nonatomic,retain) NSString *qId, *qtype, *qtext, *noofoptions;
@property(nonatomic,retain) NSMutableArray  *choicesArray, *qlabel, *dropIdArray;
@property(nonatomic,retain) NSMutableString *choices;
@end
