//
//  SqliteManager.h
//  SqliteSample
//
//  Created by Lewis on 13-10-8.
//  Copyright (c) 2013年 www.lanou3g.com  北京蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteObject.h"

/**
 *@用来管理数据库数据
 */

@interface SqliteManager : NSObject

+ (SqliteManager *)singleton;

//创建数据表格
- (BOOL)create:(SqliteObject *)object;
//删除表格
- (BOOL)drop:(SqliteObject *)object;
//插入数据
- (BOOL)insert:(SqliteObject *)object;
//删除数据
- (BOOL)remove:(SqliteObject *)object;
//更新数据
- (BOOL)update:(SqliteObject *)object;
//查询数据
- (NSArray *)itemList:(SqliteObject *)object;


@end

/*
//用来返回sql语句字符串
typedef NSString *(^SQLBlock)();

@interface SqliteManager(SqliteExtendMethods)
- (BOOL)executeWithBlock:(SQLBlock)block;
- (NSArray *)itemListWithBlock:(SQLBlock)block;

@end
*/