//
//  ModelCacheVC.m
//  TBSqlite
//
//  Created by hanchuangkeji on 2017/10/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "ModelCacheVC.h"
#import "TBPerson.h"
#import "TBDBHelper.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+ModelCache.h"

@interface ModelCacheVC ()

@end

@implementation ModelCacheVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TBDBHelper createTable:NSStringFromClass([TBPerson class]) modelId:@"modelId" owner:@"owner"];
    
}

- (IBAction)add:(id)sender {
    TBPerson *person1 = [[TBPerson alloc] init];
    person1.uId = 11;
    person1.name = @"tangbin1";
    person1.age = 12;
    person1.money = 30;
    
    BOOL flag = [person1 tb_createOrUpdate];
    if (flag) {
        NSLog(@"成功");
    }else {
        NSLog(@"失败");
    }
    
}

- (IBAction)delete:(id)sender {
    
    TBPerson *person1 = [[TBPerson alloc] init];
//    person1.uId = 11;
    person1.name = @"tangbin1";
    person1.age = 12;
    person1.money = 30;
    
    BOOL flag = [person1 tb_delete];
    if (flag) {
        NSLog(@"成功");
    }else {
        NSLog(@"失败");
    }
}

- (IBAction)update:(id)sender {
    [TBPerson tb_deleteAll];
}


- (IBAction)query:(id)sender {
//    TBPerson *person1 = [TBPerson tb_objectWithId:@(9)];
//
//    NSLog(@"%@", person1);
    
    NSArray *array = [TBPerson tb_getAll];
    for (TBPerson *person in array) {
        NSLog(@"%@", person.name);
    }
}

@end
