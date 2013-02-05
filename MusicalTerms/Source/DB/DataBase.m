//
//  DataBase.m
//  Music
//
//  Created by runes on 12-8-27.
//  Copyright (c) 2012年 Runes.cn. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase
@synthesize pdb;

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("selector: %sn", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

#define FIRSTINIT 0
- (id)init{
    self = [super init];
    if (self!=nil) {
#if FIRSTINIT   
        //第一次初始化
        
#endif
    }
    //[self copyFileDatabase];
    return self;
}

- (const char*)getFilePath{//获取数据库路径
    return [[NSString stringWithFormat:@"%@/Documents/music_db.db",NSHomeDirectory() ] UTF8String];
}

- (BOOL)createDB{
    int ret = sqlite3_open([self getFilePath ], &pdb);//打开数据库，数据库不存在则创建
    if (SQLITE_OK == ret) {//创建成功
        sqlite3_close(pdb);//关闭
        return YES;
    }else{
        return NO;//创建失败
    }
}

- (BOOL)createTable{
    char* err;
    char* sql = "create table dictionary(ID integer primary key autoincrement,en nvarchar(64),cn nvarchar(128),comment nvarchar(256))";//创建表语句
    if (sql==NULL) {
        return NO;
    }
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    
    if (SQLITE_OK == sqlite3_exec(pdb, sql, NULL, NULL, &err)) {//执行创建表语句成功
        sqlite3_close(pdb);
        return YES;
    }else{//创建表失败
        return NO;
    }
}

- (BOOL)insertRecordWithEN:(NSString*)en CN:(NSString*)cn Comment:(NSString*)comment{
    int ret = 0;
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){//打开数据库
        return NO;
    }
    char* sql = "insert into dictionary(en,cn,comment) values(?,?,?);";//插入语句，3个参数
    sqlite3_stmt* stmt;//
    if (sqlite3_prepare_v2(pdb, sql, -1, &stmt, nil)==SQLITE_OK) {//准备语句
        sqlite3_bind_text(stmt, 1, [en UTF8String], -1, NULL);//绑定参数
        sqlite3_bind_text(stmt, 2, [cn UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [comment UTF8String], -1, NULL);
    }else{
        return NO;
    }
    if (SQLITE_DONE == (ret = sqlite3_step(stmt))) {//执行查询
        sqlite3_finalize(stmt);
        sqlite3_close(pdb);
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)deleteHistoryTable{
    char* err;
    char* sql = "delete from SYS_SELECT_HISTORY;";//创建表语句
    if (sql==NULL) {
        return NO;
    }
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    
    if (SQLITE_OK == sqlite3_exec(pdb, sql, NULL, NULL, &err)) {//执行创建表语句成功
        sqlite3_close(pdb);
        return YES;
    }else{//创建表失败
        return NO;
    }
}

- (NSMutableArray*)quaryTable:(NSString *)str type:(int)type{
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    NSMutableString* sql = [[NSMutableString alloc] init];
    switch (type) {
        case 1:     //检索翻译
            [sql appendString: @"select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),wt_msg_zh,(select c.wtd_msg_zh from sys_word_translation_detail c where c.id=a.id),(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time from sys_word_info a, sys_word_translation b where a.id=b.id "];
            break;
        case 2:     //检索解释
            [sql appendString: @"select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),(select wt_msg_zh from sys_word_translation b where b.id=a.id),wtd_msg_zh,(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time from sys_word_info a, sys_word_translation_detail b where a.id=b.id "];
            break;
        case 3:    //检索历史
            [sql appendString: @"select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),(select wt_msg_zh from sys_word_translation b where b.id=a.id),(select c.wtd_msg_zh from sys_word_translation_detail c where c.id=a.id),(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time from sys_word_info a,sys_select_history b where a.id=b.sh_id and b.sh_type=1 "];
            break;
        case 4:     //速度词汇
            [sql appendString: @"select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),(select wt_msg_zh from sys_word_translation b where b.id=a.id),(select c.wtd_msg_zh from sys_word_translation_detail c where c.id=a.id),(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time,ws_name,ws_name_zh,ws_simple_bpm,ws_area_bpm,ws_other from sys_word_info a,sys_word_spead b where replace(a.wi_name,' ','')=b.ws_name "];
            break;
        default:    //常规检索
            [sql appendString: @"select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),(select wt_msg_zh from sys_word_translation b where b.id=a.id),(select c.wtd_msg_zh from sys_word_translation_detail c where c.id=a.id),(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time from sys_word_info a where 1=1 "];
            break;
    }
    
    if (str != nil) {
        [sql appendString:str];
    }
    switch (type) {
        case 3:
            [sql appendString:@"  collate nocase order by b.sh_count desc;"];
            break;
        case 4:
            [sql appendString:@"  collate nocase order by b.id asc;"];
            break;
            
        default:
            [sql appendString:@"  collate nocase order by wi_name asc;"];
            break;
    }
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(pdb, (char *)[sql UTF8String], -1, &stmt, nil)!=SQLITE_OK) {//准备
        [sql release];
        sqlite3_close(pdb);
        return NO;
    }
    NSMutableArray* arr =[[NSMutableArray alloc]init];//存放查询结果
    while( SQLITE_ROW == sqlite3_step(stmt) ){//执行
        MusicInfo *newMusicInfo = [[[MusicInfo alloc] init] autorelease];
        newMusicInfo.wi_id = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 0)];
        newMusicInfo.wi_name = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 1)];
        if (newMusicInfo.wi_name != nil) {
            newMusicInfo.wi_name = [newMusicInfo.wi_name lowercaseString];
            //去除两端空格
            newMusicInfo.wi_name = [newMusicInfo.wi_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        newMusicInfo.wi_language = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 2)];
        newMusicInfo.wi_symbol = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 3)];
        newMusicInfo.wi_link_path = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 4)];//@"http://www.google.com.hk";//
        newMusicInfo.wi_type = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 5)];
        newMusicInfo.wi_class = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 6)];
        newMusicInfo.wi_deep = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 7)];
        newMusicInfo.wi_area = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 8)];
        newMusicInfo.wi_translation_simple = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 9)];
        newMusicInfo.wi_translation_details = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 10)];
        newMusicInfo.wi_picture_path = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 11)];
        if (type == 4) {
            newMusicInfo.ws_name = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 13)];
            newMusicInfo.ws_name_zh = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 14)];
            newMusicInfo.ws_simple_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 15)];
            newMusicInfo.ws_area_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 16)];
            newMusicInfo.ws_other = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 17)];
        }
        [arr addObject:newMusicInfo];//插入到结果数组
    }
    [sql release];
    sqlite3_finalize(stmt);
    sqlite3_close(pdb);
    return [arr autorelease];//返回查询结果数组
}

/**
 * 保存访问历史记录
 */
- (BOOL)saveHistory:(NSString*)wi_id type:(int)type
{
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select sh_count from sys_select_history where sh_id=%@ and sh_type=%i",wi_id,type];
    sqlite3_stmt* stmt;
    
    if (sqlite3_prepare_v2(pdb, (char *)[sqlStr UTF8String], -1, &stmt, nil)!=SQLITE_OK) {//准备
        sqlite3_close(pdb);
        return NO;
    }
    BOOL isOk = YES;
    int count = 0;
    while( SQLITE_ROW == sqlite3_step(stmt) ){//执行
        count =  (int)(char*)sqlite3_column_text(stmt, 0);
        sqlStr = [NSString stringWithFormat:@"update sys_select_history set sh_count=sh_count+1 where sh_id=%i",type];
    }
    sqlite3_finalize(stmt);
    if (count == 0) {
        sqlStr = [NSString stringWithFormat:@"insert into sys_select_history (sh_id,sh_type,sh_count)values(%@,%i,0)",wi_id,type];
    }
    if (!SQLITE_OK == sqlite3_exec(pdb, (char *)[sqlStr UTF8String], NULL, NULL, nil)) {  
        isOk = NO;
    }
    sqlite3_close(pdb);
    return isOk;
}

- (NSString*)convertCharToNSString:(char*) ch{
    if(ch != NULL){
        return [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    }
    else {
        return NULL;
    }
}

/**
 * 查询速度表
 */
- (NSMutableArray*)quarySpeadTable{
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    char * sql = "select id,ws_name,ws_name_zh,ws_simple_bpm,ws_area_bpm,ws_other from sys_word_spead ;";    
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(pdb, sql, -1, &stmt, nil)!=SQLITE_OK) {//准备
        return NO;
    }
    sql = nil;
    NSMutableArray* arr =[[NSMutableArray alloc]init];//存放查询结果
    while( SQLITE_ROW == sqlite3_step(stmt) ){//执行
        MusicInfo *newMusicInfo = [[[MusicInfo alloc] init] autorelease];
        newMusicInfo.ws_name = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 1)];
        newMusicInfo.ws_name_zh = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 2)];
        newMusicInfo.ws_simple_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 3)];
        newMusicInfo.ws_area_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 4)];
        newMusicInfo.ws_other = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 5)];

        [arr addObject:newMusicInfo];//插入到结果数组
    }
    sqlite3_finalize(stmt);
    sqlite3_close(pdb);
    return [arr autorelease];//返回查询结果数组
}

- (MusicInfo*)getMusicInfo:(NSString *)wi_name{
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    char* sql = "select a.id,wi_name,wi_language,wi_symbol,wi_link_path,(select name from sys_dict where id=wi_type),(select name from sys_dict where id=wi_resource_class),(select name from sys_dict where id=wi_freq_deep),(select name from sys_dict where id=wi_expert_area),(select wt_msg_zh from sys_word_translation b where b.id=a.id),(select c.wtd_msg_zh from sys_word_translation_detail c where c.id=a.id),(select wp_path from sys_word_picture d where d.id=a.id),wi_create_time from sys_word_info a where wi_name like ? order by wi_name desc;";
    
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(pdb, sql, -1, &stmt, nil)==SQLITE_OK) {//准备
        sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%%%@%%",wi_name] UTF8String], -1, NULL);//绑定参数
    }
    else {
        return NO;
    }
    sql = nil;
    MusicInfo *newMusicInfo = [[[MusicInfo alloc] init] autorelease];
    while( SQLITE_ROW == sqlite3_step(stmt) ){//执行
        newMusicInfo.wi_id = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 0)];
        newMusicInfo.wi_name = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 1)];
        if (newMusicInfo.wi_name != nil) {
            newMusicInfo.wi_name = [newMusicInfo.wi_name lowercaseString];
            newMusicInfo.wi_name = [newMusicInfo.wi_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        newMusicInfo.wi_language = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 2)];
        newMusicInfo.wi_symbol = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 3)];
        newMusicInfo.wi_link_path = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 4)];
        newMusicInfo.wi_type = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 5)];
        newMusicInfo.wi_class = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 6)];
        newMusicInfo.wi_deep = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 7)];
        newMusicInfo.wi_area = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 8)];
        newMusicInfo.wi_translation_simple = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 9)];
        newMusicInfo.wi_translation_details = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 10)];
        newMusicInfo.wi_picture_path = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 11)];
        
//        newMusicInfo.ws_name = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 13)];
//        newMusicInfo.ws_name_zh = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 14)];
//        newMusicInfo.ws_simple_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 15)];
//        newMusicInfo.ws_area_bpm = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 16)];
//        newMusicInfo.ws_other = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 17)];
    }
    sqlite3_finalize(stmt);
    sqlite3_close(pdb);
    return newMusicInfo;//返回查询结果数组
}

/**
 * 查询数据字典
 */
- (NSMutableArray*)getDictInfo:(int)type
{
    if (SQLITE_OK != sqlite3_open([self getFilePath ], &pdb)){
        return NO;
    }
    char* sql = "select id,name from sys_dict where type=? order by name asc;";
    
    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(pdb, sql, -1, &stmt, nil)==SQLITE_OK) {//准备
        sqlite3_bind_text(stmt, 1, [[NSString stringWithFormat:@"%i",type] UTF8String], -1, NULL);//绑定参数
    }
    else {
        return NO;
    }
    sql = nil;
    NSMutableArray* arr =[[NSMutableArray alloc]init];//存放查询结果
    while( SQLITE_ROW == sqlite3_step(stmt) ){//执行
        DictInfo *newDictInfo = [[[DictInfo alloc] init] autorelease];
        newDictInfo.dictId = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 0)];
        newDictInfo.dictName = [self convertCharToNSString:(char*)sqlite3_column_text(stmt, 1)];
        
        [arr addObject:newDictInfo];//插入到结果数组
    }
    sqlite3_finalize(stmt);
    sqlite3_close(pdb);
    return [arr autorelease];//返回查询结果数组
}

/**
 * 第一次运行时拷贝数据库到沙盒中
 */
-(void)copyFileDatabase 
{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];     
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"db/music_db.db"]; 
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) { 
        NSLog(@"文件已经存在了"); 
    }
    else { 
        NSString *resourceFolderPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db/music_db.db"];
        //pathForResource:@"db/music_db.db" 
        //ofType:@"db"]; 
        NSLog(@"resourceSampleImagesFolderPath=%@",resourceFolderPath);
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath]; 
        NSLog(@"mainBundleFile==%@",mainBundleFile);
        [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath 
                                                contents:mainBundleFile 
                                              attributes:nil]; 
    }
} 

/**
 * 删除数据库文件
 */
-(void)deleteFileDatabase 
{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];     
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"music_db.db"]; 
    [[NSFileManager defaultManager] delete:documentLibraryFolderPath]; 
}
@end
