//
//  MySubCell.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakImageView.h"

@interface MySubCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *translationLabel;
    IBOutlet SpeakImageView *imageView;
}
@property(nonatomic,retain) UILabel *nameLabel;
@property(nonatomic,retain) UILabel *translationLabel;
@property(nonatomic,retain) SpeakImageView *imageView;

@end
