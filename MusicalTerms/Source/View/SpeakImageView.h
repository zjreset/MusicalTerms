//
//  SpeakImageView.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeakImageView : UIImageView
{
    NSString *imageName;
}
@property(nonatomic,retain) NSString *imageName;

@end
