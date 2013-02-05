//
//  ClassfyIpadViewController.h
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailNavigationViewController.h"

@interface ClassfyIpadViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>
{
	NSArray         *listContent;	
	NSArray         *alertListContent;
    AVAudioPlayer   *player;
    BOOL            noResultToDisplay;
    UIBarButtonItem *languageButton;
    UIBarButtonItem *freqButton;
    UIBarButtonItem *resourceButton;
    UIBarButtonItem *resetButton;
    UITableView     *alertTableView;
    UIAlertView     *myAlertView;
    int             clickTag;
    NSString        *languageName;
    NSString        *resourceName;
    NSString        *freqName;
	IBOutlet UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    DetailNavigationViewController<SubstitutableDetailViewController> *detailViewController;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSArray *alertListContent;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic) BOOL noResultToDisplay;
@property (nonatomic, retain) UIBarButtonItem *languageButton;
@property (nonatomic, retain) UIBarButtonItem *freqButton;
@property (nonatomic, retain) UIBarButtonItem *resourceButton;
@property (nonatomic, retain) UIBarButtonItem *resetButton;
@property (nonatomic, retain) UITableView *alertTableView;
@property (nonatomic, retain) UIAlertView *myAlertView;
@property (nonatomic) int clickTag;
@property (nonatomic, retain) NSString *languageName;
@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSString *freqName;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet DetailNavigationViewController<SubstitutableDetailViewController> *detailViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@end
