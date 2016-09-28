//
//  RMUIAlertView.m
//  rm-food-order
//
//  Created by ibrahim bachtiar on 6/9/15.
//  Copyright (c) 2015 Relevant Mobile. All rights reserved.
//

#import "RMUIAlertView.h"

@implementation RMUIAlertView


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id) initWithTitle:(NSString *)title
             message:(NSString *)message
            delegate:(id)delegate
   cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title
                        message:message
                       delegate:delegate
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles, nil];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}


- (void) dismiss:(NSNotification *)notication {
    [self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:YES];
}


@end
