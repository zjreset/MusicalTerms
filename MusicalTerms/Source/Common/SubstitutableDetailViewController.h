//
//  SubstitutableDetailViewController.h
//  Music(Ipad)
//
//  Created by runes on 12-9-21.
//
//

#import <Foundation/Foundation.h>

@protocol SubstitutableDetailViewController <NSObject>
@required
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end
