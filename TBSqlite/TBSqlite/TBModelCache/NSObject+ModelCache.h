//
//  NSObject+ModelCache.h
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TBCache <NSObject>

@required
+ (NSString *)tb_tableId;

@end


@interface NSObject (ModelCache)<TBCache>

- (BOOL)tb_createOrUpdate;

- (BOOL)tb_delete;
+ (BOOL)tb_deleteAll;

+ (instancetype)tb_objectWithId:(id)modelId;
+ (NSArray *)tb_getAll;

@end
