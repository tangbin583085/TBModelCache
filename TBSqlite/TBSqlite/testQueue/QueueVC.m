//
//  QueueVC.m
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "QueueVC.h"

#import <FMDB.h>

@interface QueueVC ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end

@implementation QueueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    // 拼接文件
    NSString *filePath = [cachePath stringByAppendingString:@"/user.sqlite"];
    // 创建数据库实例
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    _queue = queue;
    
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL flag =  [db executeUpdate:@"create table if not exists t_user (id integer primary key autoincrement,name text,money integer)"];
        
        if (flag) {
            NSLog(@"创建数据库成功");
        }else {
            NSLog(@"创建数据库失败");
        }
    }];
}



- (IBAction)add:(id)sender {
    
    CGFloat money = arc4random() % 1000 * 0.1;
    
    NSString *name = [NSString stringWithFormat:@"tangbin%.0f", money];
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL flag = [db executeUpdate:@"insert into t_user (name, money) values (?, ?)", name, @(money)];
        if (flag) {
            NSLog(@"添加数据成功");
        }else {
            NSLog(@"添加数据失败");
        }
        
    }];
    
}

- (IBAction)delete:(id)sender {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL flag = [db executeUpdate:@"delete from t_user where id = ?", @(3)];
        if (flag) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }];
}

- (IBAction)update:(id)sender {
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL flag = [db executeUpdate:@"update t_user set name = ? where id < ?", @"张三", @(2)];
        if (flag) {
            NSLog(@"更新数据成功");
        }else {
            NSLog(@"更新数据失败");
        }
    }];
    
}
- (IBAction)query:(id)sender {

    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:@"select * from t_user"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            CGFloat money = [result doubleForColumn:@"money"];
            NSLog(@"%@, %f", name, money);
        }
    }];
}


@end
