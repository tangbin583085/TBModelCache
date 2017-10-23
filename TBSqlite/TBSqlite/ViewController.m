//
//  ViewController.m
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>
#import "QueueVC.h"


@interface ViewController ()
@property (nonatomic, strong) FMDatabase *dataBase;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    // 创建一个数据库实例
    FMDatabase *dataBase = [FMDatabase databaseWithPath:filePath];
    _dataBase = dataBase;
    // 打开数据库
    BOOL flag = [dataBase open];
    if (flag) {
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
    
    // 创建数据库表
    BOOL flag1 = [dataBase executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);"];
    if (flag1) {
        NSLog(@"创建数据库成功");
    }else {
        NSLog(@"创建数据库失败");
    }
}
- (IBAction)add:(id)sender {
    
    int phone = arc4random() % 1000;
    NSString *name = [NSString
                      stringWithFormat:@"tangbin%d", phone];
    
    BOOL flag = [_dataBase executeUpdate:@"insert into t_contact (name, phone) values (?, ?)", name, @(phone)];
    
    if (flag) {
        NSLog(@"插入数据正确---> %@, %d", name, phone);
    }else {
        NSLog(@"插入数据失败");
    }
    
}

- (IBAction)delete:(id)sender {
    NSString *name = @"tangbin";
    
    BOOL flag = [_dataBase executeUpdate:@"delete from t_contact where name != ?", name];
    if (flag) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    }
}

- (IBAction)update:(id)sender {
    
    BOOL flag = [_dataBase executeUpdate:@"update t_contact set name = ? where id < ?", @"汤彬", @(46)];
    if (flag) {
        NSLog(@"更新成功");
    }else {
        NSLog(@"更新失败");
    }
}

- (IBAction)query:(id)sender {
    
    FMResultSet *result = [_dataBase executeQuery:@"select * from t_contact"];
    
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"name --> %@    phone ---- > %@", name, phone);
    }
    
}

- (IBAction)gotoQueueVC:(id)sender {
    QueueVC *vc = [[QueueVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
