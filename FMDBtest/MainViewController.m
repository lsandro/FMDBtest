//
//  MainViewController.m
//  FMDBtest
//
//  Created by YI on 16/9/18.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import "MainViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    // 1 获取数据库对象
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path=[path stringByAppendingPathComponent:@"test.sqlite"];
    
    FMDatabase *dataBase=[FMDatabase databaseWithPath:path];
    NSLog(@"路径：%@",path);

    // 2 打开数据库，如果不存在则创建并且打开
    if (![dataBase open]) {
        NSLog(@"数据库打开失败。。");
    } else {
        NSLog(@"数据库打开啦");
        //3 创建表
        NSString * create1=@"create table if not exists t_user(id integer  primary key,name varchar)";//如果表本身存在则会继续创建但不会删除原来的数据
        BOOL c1= [dataBase executeUpdate:create1];
        if(c1){
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    }
    /*
    //4 插入数据
    NSString * insertSql=@"insert into t_user(id,name) values(?,?)";
    
    //    插入语句1
    if ([dataBase executeUpdate:insertSql,@(12),@"admin1插入"]) {
        NSLog(@"1成功插入");
    } else {
        NSLog(@"1没插进去");
    }
    
    //    插入语句2
    if ([dataBase executeUpdate:insertSql withArgumentsInArray:@[@(10),@"admin2插入"]]) {
        NSLog(@"2成功插入");
    } else {
        NSLog(@"2没插进去");
    }
    
    //    插入语句3
    if ([dataBase executeUpdateWithFormat:@"insert into t_user(id,name) values(%d,%@)",6,@"admin3插入"]) {
        NSLog(@"3成功插入");
    } else {
        NSLog(@"3没插进去");
    }
    */
    
    //    删除语句
    /*
    NSString * delete=@"delete from t_user";
    BOOL dflag= [dataBase executeUpdate:delete];//清空表中数据
    if(dflag){
        NSLog(@"删除成功");
    }
    
    */
    
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from %@ where %@ = '%@'",
                           @"t_user", @"name", @"zhangsan"];
    BOOL res = [dataBase executeUpdate:deleteSql];
    
    if (!res) {
        NSLog(@"error when delete db table");
    } else {
        NSLog(@"success to delete db table");
    }
    
    //    修改语句
    /*
    NSString *update=@" update t_user set name=? ";
    BOOL flag=  [dataBase executeUpdate:update,@"zhangsan"];
    if(flag){
        NSLog(@"修改所有name的值成功");
    } else {
        NSLog(@"修改所有name的值失败");
    }
    */
    //感觉这两句好傻啊，谁没事全部清空又全部修改的= =
    
    NSString *updateSql = [NSString stringWithFormat:
                           @"UPDATE %@ SET %@ = ? WHERE %@ = ?",@"t_user",@"name",@"id"];
    BOOL res2 = [dataBase executeUpdate:updateSql,@"sss",@(11)];
    if (!res2) {
        NSLog(@"error when update db table");
    } else {
        NSLog(@"success to update db table");
    }
    
    
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@",@"t_user"];
    FMResultSet * rs = [dataBase executeQuery:sql];
    while ([rs next]) {
        int Id = [rs intForColumn:@"id"];
        NSString * name = [rs stringForColumn:@"name"];
        NSLog(@"id = %d, name = %@", Id, name);
    }
    
    [dataBase close];
    NSLog(@"数据库关闭啦");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
