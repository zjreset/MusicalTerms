//
//  SpeedIpadViewController.h
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailNavigationViewController.h"

@interface SpeedIpadViewController : UITableViewController <UISplitViewControllerDelegate>
{
	NSArray			*listContent;			
    AVAudioPlayer   *player;
	IBOutlet UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    DetailNavigationViewController<SubstitutableDetailViewController> *detailViewController;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) IBOutlet DetailNavigationViewController<SubstitutableDetailViewController> *detailViewController;

@end
