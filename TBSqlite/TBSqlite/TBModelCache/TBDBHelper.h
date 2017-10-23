//
//  TBDBHelper.h
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDBHelper : NSObject

+ (BOOL)createTable:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner;

+ (BOOL)create:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner dic:(NSDictionary *)dic;


+ (BOOL)deleteModel:(NSString *)modelId table:(NSString *)tableName;

+ (BOOL)update:(NSString *)tableName modelId:(NSString *)modelId owner:(NSString *)owner dic:(NSDictionary *)dic;

// 查询
+ (NSMutableDictionary *)getById:(NSString *)modelId table:(NSString *)tableName;

+ (NSArray<NSMutableDictionary *> *)executeBySQL:(NSString *)sql value:(id)value1, ...;

@end
