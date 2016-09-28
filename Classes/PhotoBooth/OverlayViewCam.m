#import "OverlayViewCam.h"

@interface OverlayViewCam ()

@end

@implementation OverlayViewCam
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
        [self setNeedsStatusBarAppearanceUpdate];
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10,-3, 260, 50)];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
//    [label setText:NSLocalizedString(@"Submit Receipt Title",@"")];
//    [label setTextAlignment:UITextAlignmentCenter];
//    [self.view addSubview:label];
}




- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
#pragma mark -
#pragma mark Help Button Action
- (IBAction)TakePhotoHelpButtonClicked:(UIButton *)sender {
    [self performSelector:@selector(camraButtonAction) withObject:nil afterDelay:0.0];
}

-(void) camraButtonAction {
    
    [delegate helpButtonPressed];

}
     

- (void) HelpDoneSuccessfully {  
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
