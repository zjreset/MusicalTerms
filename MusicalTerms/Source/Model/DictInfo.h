//
//  DictInfo.h
//  Music
//
//  Created by runes on 12-8-30.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictInfo : NSObject
{
    NSString *dictId;
    NSString *dictName;
}
@property (nonatomic, retain) NSString *dictId;
@property (nonatomic, retain) NSString *dictName;
@end
