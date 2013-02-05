//
//  MyDetailView.h
//  Music(Ipad)
//
//  Created by runes on 12-9-28.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicInfo.h"

@interface MyDetailView : UIScrollView
{
    AVAudioPlayer   *player;
}
@property (nonatomic, retain) AVAudioPlayer *player;
- (void)setDetailsView:(MusicInfo*)musicInfo withType:(int) type;

@end
