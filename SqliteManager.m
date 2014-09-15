//
//  SqliteManager.m
//  SqliteSample
//
//  Created by Lewis on 13-10-8.
//  Copyright (c) 2013年 www.lanou3g.com  北京蓝鸥科技有限公司. All rights reserved.
//

#import "SqliteManager.h"
#import <sqlite3.h>

static inline NSString *toto(const char *pStr)
{
    return [NSString stringWithUTF8String:pStr];
}

@interface SqliteManager()

//打开数据库
- (void)_open;
//关闭数据库
- (void)_close;

@end

@implementation SqliteManager
{
    sqlite3 *database;
}
//打开数据库
- (void)_open
{
    //获取Document文件夹路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //
    NSBundle*bundle =[NSBundle mainBundle];
    NSDictionary*info =[bundle infoDictionary];
    NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
    
    //获取数据库文件的路径
    NSString *sqlitePath = [documentPath stringByAppendingFormat:@"/%@.sqlite",prodName];
    //使用函数打开数据，并且将数据库对象赋值给database
    sqlite3_open([sqlitePath UTF8String], &database);
}
//关闭数据库
- (void)_close
{
    sqlite3_close(database);
}

static SqliteManager *s_SqliteManager = nil;
+ (SqliteManager *)singleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_SqliteManager == nil) {
            s_SqliteManager = [[SqliteManager alloc] init];
        }
    });
    return s_SqliteManager;
}
//创建数据表格
- (BOOL)create:(SqliteObject *)object
{
    [self _open];
    
    int result = sqlite3_exec(database, object.createSQL.UTF8String, NULL, NULL, NULL);
    [self _close];
    
    return result == SQLITE_OK;
}
//插入数据
- (BOOL)insert:(SqliteObject *)object
{
    //打开数据库
    [self _open];
    //执行sql
    int result = sqlite3_exec(database, object.insertSQL.UTF8String, NULL, NULL, NULL);
    //关闭数据库
    [self _close];
    return result == SQLITE_OK;
}
//删除数据
- (BOOL)remove:(SqliteObject *)object
{
    //打开数据库
    [self _open];
    //执行sql
    int result = sqlite3_exec(database, object.removeSQL.UTF8String, NULL, NULL, NULL);
    //关闭数据库
    [self _close];
    return result == SQLITE_OK;
}
//更新数据
- (BOOL)update:(SqliteObject *)object
{
    //打开数据库
    [self _open];
    //执行sql
    int result = sqlite3_exec(database, object.updateSQL.UTF8String, NULL, NULL, NULL);
    //关闭数据库
    [self _close];
    return result == SQLITE_OK;
}
//删除表格
- (BOOL)drop:(SqliteObject *)object
{
    [self _open];
    //执行sql
    int result = sqlite3_exec(database, object.dropSQL.UTF8String, NULL, NULL, NULL);
    //关闭数据库
    [self _close];
    return result == SQLITE_OK;
}

//查询数据
-(NSArray *)itemList:(SqliteObject *)object
{
    [self _open];
    //声明sql执行状态对象
    sqlite3_stmt *statement = NULL;
    //获取执行状态对象
    sqlite3_prepare(database, object.selectSQL.UTF8String, object.selectSQL.length, &statement, NULL);
    
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    //执行sql语句
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        //通过参数Object的真实类名分配内存
        SqliteObject *item = [[[object class] alloc] init];
        NSInteger columnCount = sqlite3_column_count(statement);
        for (NSInteger index = 0; index < columnCount; index ++) {
            NSString *value = toto((const char *)sqlite3_column_text(statement, index));
            NSString *key = toto((const char *)sqlite3_column_name(statement, index));
            
            NSLog(@"%@",key);
            key = [key substringFromIndex:2];
            [item setValue:value forKey:key];
        }
        [resultList addObject:item];
        [item release];
    }

    //终止执行状态对象
    sqlite3_finalize(statement);
    //关闭数据库
    [self _close];
    
    return [resultList autorelease];
}

@end


/*
@implementation SqliteManager (SqliteExtendMethods)
- (BOOL)executeWithBlock:(SQLBlock)block
{
    [self _open];
    //执行sql
    int result = sqlite3_exec(database, block().UTF8String, NULL, NULL, NULL);
    //关闭数据库
    [self _close];
    return result == SQLITE_OK;
}
- (NSArray *)itemListWithBlock:(SQLBlock)block
{
    [self _open];
    //获取sql语句
    NSString *sql = block();
    //声明sql执行状态对象
    sqlite3_stmt *statement = NULL;
    //获取执行状态对象
    sqlite3_prepare(database, sql.UTF8String, sql.length, &statement, NULL);
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    //单步执行sql语句
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        SqliteObject *item = [[SqliteObject alloc] init];
        NSInteger columnCount = sqlite3_column_count(statement);
        for (NSInteger index = 0; index < columnCount; index ++) {
            NSString *value = toto((const char *)sqlite3_column_text(statement, index));
            NSString *key = toto((const char *)sqlite3_column_name(statement, index));
            [item setValue:value forKey:key];
        }
        [resultList addObject:item];
        [item release];
    }
    
    //终止执行状态对象
    sqlite3_finalize(statement);
    //关闭数据库
    [self _close];
    
    return [resultList autorelease];
}

@end
*/