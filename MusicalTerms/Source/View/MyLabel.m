//
//  MyLabel.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "MyLabel.h"

#define FONTSIZE 13
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
@implementation MyLabel

@synthesize delegate;
// 设置换行模式,字体大小,背景色,文字颜色,开启与用户交互功能,设置label行数,0为不限制
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
        [self setFont:[UIFont systemFontOfSize:FONTSIZE]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:COLOR(59,136,195,1.0)];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
    }
    return self;
}
// 点击该label的时候, 更换labeltext颜色
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:[UIColor redColor]];
}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作,配合moved的使用
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:COLOR(59,136,195,1.0)];
    //    UITouch *touch = [touches anyObject];
    //    CGPoint points = [touch locationInView:self];
    //    if (points.x >= self.frame.origin.x && points.y >= self.frame.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    //    {
    //        [delegate myLabel:self touchesWtihTag:self.tag];
    //    }
}
//配合touchBegan的使用
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //恢复点击前的颜色
    [self setTextColor:COLOR(59,136,195,1.0)];
}
//移动label
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)dealloc {
    [super dealloc];
}


@end
