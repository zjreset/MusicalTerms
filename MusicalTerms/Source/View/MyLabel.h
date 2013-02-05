//
//  MyLabel.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabelDelegate.h"

@interface MyLabel : UILabel
{
    id <MyLabelDelegate> delegate;
}
@property (nonatomic, assign) id <MyLabelDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;

@end
