//
//  OverlayViewC.m
//  ZoesKitchen
//
//  Created by Ajay Kumar on 01/09/12.
//  Copyright (c) 2012 Mycompany. All rights reserved.

//

#import "OverlayViewC.h"

@interface OverlayViewC ()

@end

@implementation OverlayViewC
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma mark Help Button Action
- (IBAction)TakePhotoHelpButtonClicked:(UIButton *)sender {
    
    [self performSelector:@selector(camraButtonAction) withObject:nil afterDelay:0.0];
    
}

-(void) camraButtonAction {
    
    [delegate cancelPress];

}
     

- (void) HelpDoneSuccessfully {  
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [titlePage release];
    [cancelBtn release];
    [super dealloc];
}
@end
