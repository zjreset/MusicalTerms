//
//  SearchIpadViewController.h
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DetailNavigationViewController.h"
@interface SearchIpadViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate,UISplitViewControllerDelegate>
{
	NSArray			*listContent;			
	NSMutableArray	*filteredListContent;	
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    AVAudioPlayer   *player;
    
	UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    DetailNavigationViewController<SubstitutableDetailViewController> *detailNavigationViewController;
}
@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property(nonatomic,assign)AVAudioPlayer *player;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet DetailNavigationViewController<SubstitutableDetailViewController> *detailNavigationViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@end
