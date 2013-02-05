//
//  MySubCell.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "MySubCell.h"

@implementation MySubCell
@synthesize nameLabel;
@synthesize translationLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
