//
//  MusicInfo.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfo : NSObject{
    NSString *wi_id;
    NSString *wi_name;
    NSString *wi_type;
    NSString *wi_language;
    NSString *wi_symbol;
    NSString *wi_speak;
    NSString *wi_translation_simple;
    NSString *wi_class;
    NSString *wi_deep;
    NSString *wi_area;
    NSString *wi_link_path;
    NSString *wi_picture_path;
    NSString *wi_translation_details;
    NSString *ws_name;
    NSString *ws_name_zh;
    NSString *ws_simple_bpm;
    NSString *ws_area_bpm;
    NSString *ws_other;
}

@property (nonatomic, copy) NSString *wi_id,*wi_name,*wi_type,*wi_language,*wi_symbol,*wi_speak,*wi_translation_simple,*wi_class,*wi_deep,*wi_area,*wi_link_path,*wi_picture_path,*wi_translation_details,*ws_name,*ws_name_zh,*ws_simple_bpm,*ws_area_bpm,*ws_other;

+ (id)productWithName:(NSString *)wi_name;

@end
