//
//  NSObject+ModelCache.m
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "NSObject+ModelCache.h"
#import <objc/runtime.h>
#import "TBDBHelper.h"
#import <MJExtension/MJExtension.h>

@implementation NSObject (ModelCache)


/**
 获取id

 @return 返回id
 */
- (id)getModelIdValue {
    
    // 是否响应配置ID函数
    if (![self.class respondsToSelector:@selector(tb_tableId)]){
        NSLog(@"tb_tableId 没有指定id");
        return nil;
    }
    NSString *paramkey = [self.class tb_tableId];
    id modelId = [self valueForKeyPath:paramkey];
    return modelId;
}



+ (instancetype)tb_objectWithId:(id)modelId {
    if (modelId == nil) return nil;
    
    NSDictionary *dic = [TBDBHelper getById:modelId table:NSStringFromClass([self class])];
    
    return [[self class] mj_objectWithKeyValues:dic];
}

- (BOOL)tb_delete {
    BOOL flag = false;
    [NSString stringWithFormat:@""];
    // 获取model ID
    id modelId = [self getModelIdValue];
    if (modelId == nil) return false;
    
    flag = [TBDBHelper deleteModel:modelId table:NSStringFromClass(self.class)];
    
    return flag;
}

+ (BOOL)tb_deleteAll {
    BOOL flag = false;
    NSString *sql = [NSString stringWithFormat:@"delete from %@", NSStringFromClass(self.class)];
    
    flag = [TBDBHelper executeBySQL:sql value:nil];
    
    return flag;
}

- (BOOL)tb_createOrUpdate{
    BOOL flag = false;
    
    // 获取model ID
    id modelId = [self getModelIdValue];
    if (modelId == nil) return false;
    
    // 先查询
    id value = [TBDBHelper getById:modelId table:NSStringFromClass(self.class)];
    
    // 不存在该数据，新建
    if (value == nil) {
        flag = [self create];
    }else {// 更新
        flag = [self update];
    }
    
    return flag;
}

- (BOOL)update{
    NSDictionary *dic = self.mj_keyValues;
    return [TBDBHelper update:NSStringFromClass(self.class) modelId:[self getModelIdValue] owner:[self getModelIdValue] dic:dic];
}

- (BOOL)create{
    NSDictionary *dic = self.mj_keyValues;
    return [TBDBHelper create:NSStringFromClass(self.class) modelId:[self getModelIdValue] owner:[self getModelIdValue] dic:dic];
}


+ (NSArray *)tb_getAll {
    NSString *sql = [NSString stringWithFormat:@"select * from %@", NSStringFromClass(self.class)];
    NSArray<NSDictionary *> *array = [TBDBHelper executeBySQL:sql value:nil];
    
    NSMutableArray *arrayTemp = nil;
    for (NSDictionary *dic in array) {
        arrayTemp = arrayTemp == nil? [NSMutableArray array] : arrayTemp;
        [arrayTemp addObject:[[self class] mj_objectWithKeyValues:dic]];
        ;
    }
    return arrayTemp;
}



@end
