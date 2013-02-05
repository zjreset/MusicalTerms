//
//  SpeakImageView.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "SpeakImageView.h"

@implementation SpeakImageView
@synthesize imageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:TRUE];
        [self setImage:[UIImage imageNamed:@"icon_annoucement.png"]];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:TRUE];
        [self setImage:[UIImage imageNamed:@"icon_annoucement.png"]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[self.imageName lowercaseString] ofType:@"mp3"];       //创建音乐文件路径
    if (musicFilePath != NULL) {
        NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];  
        AVAudioPlayer *player = [[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil] autorelease];
        [musicURL release];
        if (player == nil){
            NSLog(@"audio player not initialized");   
        }          
        else if(TARGET_IPHONE_SIMULATOR){
            NSLog(@"player play"); 
        } 
        else{
            [player play];  
        } 
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
