//
//  DetailNavigationViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-22.
//
//

#import "DetailNavigationViewController.h"

@interface DetailNavigationViewController ()

@end

@implementation DetailNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.title = @"词汇信息";
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        viewController.view = view;
        [self pushViewController:viewController animated:NO];
        [view release];
        [viewController release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark Managing the popover controller
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [self.navigationBar.topItem setRightBarButtonItem:barButtonItem animated:NO];
    
//    NSMutableArray *itemsArray = [self.navigationBar.topItem.leftBarButtonItems mutableCopy];
//    [itemsArray insertObject:barButtonItem atIndex:0];
//    [self.navigationBar.topItem setLeftBarButtonItems:itemsArray animated:NO];
//    [itemsArray release];
    
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [self.navigationBar.topItem setRightBarButtonItem:nil animated:NO];
    
//    NSMutableArray *itemsArray = [self.navigationBar.topItem.leftBarButtonItems mutableCopy];
//    [itemsArray removeObject:barButtonItem];
//    [self.navigationBar.topItem setLeftBarButtonItems:itemsArray animated:NO];
//    [itemsArray release];
}

@end
