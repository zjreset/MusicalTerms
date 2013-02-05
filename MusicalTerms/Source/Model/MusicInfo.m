//
//  MusicInfo.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo

@synthesize wi_id, wi_name,wi_type,wi_language,wi_symbol,wi_speak,wi_translation_simple,wi_class,wi_deep,wi_area,wi_link_path,wi_picture_path,wi_translation_details,ws_name,ws_name_zh,ws_simple_bpm,ws_area_bpm,ws_other;


+ (id)productWithName:(NSString *)wi_name
{
	MusicInfo *newMusicInfo = [[[self alloc] init] autorelease];
	newMusicInfo.wi_name = wi_name;
	return newMusicInfo;
}

@end
