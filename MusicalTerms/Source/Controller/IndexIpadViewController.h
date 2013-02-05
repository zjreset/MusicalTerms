//
//  IndexIpadViewController.h
//  Music(Ipad)
//
//  Created by runes on 12-9-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchViewDelegate.h"

@interface IndexIpadViewController : UIViewController
{
    id<SwitchViewDelegate> delegate;
}
@property(nonatomic,retain) id<SwitchViewDelegate> delegate;

@end
