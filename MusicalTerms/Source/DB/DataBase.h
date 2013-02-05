//
//  DataBase.h
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MusicInfo.h"
#import "DictInfo.h"

@interface DataBase : NSObject
{
    sqlite3* pdb;//数据库句柄
}
@property(nonatomic,assign)sqlite3* pdb;
- (BOOL)insertRecordWithEN:(NSString*)en CN:(NSString*)cn Comment:(NSString*)comment;//插入一条纪录
- (NSMutableArray*)quaryTable:(NSString*)str type:(int)typeStr;//查询主表
- (NSMutableArray*)quarySpeadTable;//查询速度表
- (MusicInfo *)getMusicInfo:(NSString*)wi_name;
- (NSMutableArray*)getDictInfo:(int)type;

- (const char*)getFilePath;//获取数据库路径
- (BOOL)createDB;//创建数据库
- (BOOL)createTable;//创建表
- (BOOL)deleteHistoryTable;
- (BOOL)saveHistory:(NSString*)wi_id type:(int)type;

@end
