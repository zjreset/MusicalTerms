//
//  MyLabelDelegate.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyLabel;
@protocol MyLabelDelegate <NSObject>
@required
- (void)myLabel:(MyLabel *)myLabel touchesWtihTag:(NSInteger)tag;

@end
