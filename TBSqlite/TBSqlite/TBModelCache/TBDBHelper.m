//
//  TBDBHelper.m
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBDBHelper.h"
#import <FMDB.h>
#import "TBPerson.h"
#import <MJExtension/MJExtension.h>

@implementation TBDBHelper

static FMDatabase *_dataBase;

/**
 以bundleID+tb生成数据库名称

 @return 数据库名称
 */
+ (NSString *)getDBName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    // 为了避免和其他数据库名字冲突，添加tb
    bundleId = [bundleId stringByAppendingString:@".tb"];
    return bundleId;
}


/**
 将数据库保存至cache目录

 @return cache 目录
 */
+ (NSString *)getDBFilePath {
    // 缓存目录
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return cachePath;
}

+ (void)initialize {
    
    // 拼接数据库路径和名称
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.sqlite", [self getDBFilePath], [self getDBName]];
    
    // 创建数据库实例
    FMDatabase *dataBase = [FMDatabase databaseWithPath:filePath];
    _dataBase = dataBase;
    
    // 开启数据库
    if ([dataBase open]) {
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
}


/**
 创建数据库表

 @param tableName 表名称
 @return 成功YES，失败NO
 */
+ (BOOL)createTable:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner {
    
    // 创建数据库表
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (t_id integer primary key autoincrement,modelId text,%@ text, dic blob);", tableName, owner];
    
    BOOL flag1 = [_dataBase executeUpdate:sql];
    if (flag1) {
        NSLog(@"创建数据库成功");
    }else {
        NSLog(@"创建数据库失败");
    }
    return flag1;
}

+ (BOOL)create:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner dic:(NSDictionary *)dic{
    
    // 拼接sql语句
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (modelId, owner, dic) values (?, ?, ?);", tableName];
    
    // 转化二进制
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
   BOOL flag = [_dataBase executeUpdate:sql, modelId, owner, data];
    
    if (flag) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    return flag;
}

+ (NSArray<NSMutableDictionary *> *)executeBySQL:(NSString *)sql value:(id)value1, ...{
    
    FMResultSet *result = [_dataBase executeQuery:sql, value1];
    NSDictionary *dicTemp = nil;
    NSMutableArray *array = nil;
    while ([result next]) {
        NSData *data = [result dataForColumn:@"dic"];
        dicTemp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dicTemp == nil) {
            continue;
        }
        array = array != nil? array : [NSMutableArray array];
        [array addObject:dicTemp];
    }
    
    return array;
}

+ (NSMutableDictionary *)getById:(NSString *)modelId table:(NSString *)tableName {
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where modelId = ?", tableName];
    FMResultSet *result = [_dataBase executeQuery:sql, modelId];
    NSMutableDictionary *dicTemp;
    while ([result next]) {
        NSData *data = [result dataForColumn:@"dic"];
        dicTemp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        break;
    }
    return dicTemp;
}

+ (BOOL)deleteModel:(NSString *)modelId table:(NSString *)tableName {
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where modelId = %@", tableName, modelId];
    
    BOOL flag = [_dataBase executeUpdate:sql];
    if (flag) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    }
    return flag;
}

+ (BOOL)update:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner dic:(NSDictionary *)dic{
    // 转化二进制
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *sql = [NSString stringWithFormat:@"update %@ set owner = ?, dic = ? where modelId = ?", tableName];
    
    BOOL flag = [_dataBase executeUpdate:sql, owner, data, modelId];
    
    if (flag) {
        NSLog(@"更新成功");
    }else {
        NSLog(@"更新失败");
    }
    
    return flag;
}

@end
