//
//  SqliteObject.m
//  SqliteSample
//
//  Created by Lewis on 13-12-4.
//  Copyright (c) 2013年 www.lanou3g.com  北京蓝鸥科技有限公司. All rights reserved.
//

#import "SqliteObject.h"
#import <objc/runtime.h>


@interface SqliteObject()

@property (nonatomic ,strong) NSMutableArray *propertyList;

@end

@implementation SqliteObject

- (void)dealloc
{
    self.propertyList = nil;
    self.rowid = nil;
    [super dealloc];
}

+ (id)object
{
    SqliteObject *object = [[self alloc] init];
    return [object autorelease];
}

- (NSMutableArray *)propertyList
{
    if (_propertyList != nil) {
        return _propertyList;
    }
    _propertyList = [[NSMutableArray alloc] init];
    
    unsigned int outCount = 0;
    objc_property_t *properties = NULL;
    //添加父类的属性
    properties = class_copyPropertyList(class_getSuperclass(self.class), &outCount);
    for (int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName isEqualToString:@"propertyList"]) {
            continue;
        }
        [_propertyList addObject:propertyName];
    }
    //添加子类的属性
    properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        [_propertyList addObject:propertyName];
    }
    
    return _propertyList;
}

//创建数据库表格的SQL
- (NSString *)createSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"create table %@(",NSStringFromClass(self.class)];
    for (NSString *property in self.propertyList)
    {
        if ([property isEqualToString:@"rowid"])
        {
            [sql appendFormat:@"%@ integer primary key autoincrement,",property];
            continue;
        }
        [sql appendFormat:@"%@ text,",property];
    }
    NSRange lastRange = NSMakeRange(sql.length - 1, 1);
    [sql deleteCharactersInRange:lastRange];
    [sql appendFormat:@");"];
    
    return [sql autorelease];
}

- (NSString *)dropSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"drop table %@;",NSStringFromClass(self.class)];
    return [sql autorelease];
}

- (NSString *)insertSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"insert into %@(",NSStringFromClass(self.class)];
    for (NSString *property in self.propertyList)
    {
        if ([property isEqualToString:@"propertyList"]) {
            continue;
        }
        if ([property isEqualToString:@"rowid"]) {
            continue;
        }
        [sql appendFormat:@"%@,",property];
    }
    NSRange lastRange = NSMakeRange(sql.length - 1, 1);
    [sql deleteCharactersInRange:lastRange];
    [sql appendString:@")"];
    
    [sql appendString:@"values("];
    
    for (NSString *property in self.propertyList) {
        if ([property isEqualToString:@"propertyList"]) {
            continue;
        }
        if ([property isEqualToString:@"rowid"]) {
            continue;
        }
        [sql appendFormat:@"'%@',",[self valueForKey:property]];
    }
    
    lastRange = NSMakeRange(sql.length - 1, 1);
    [sql deleteCharactersInRange:lastRange];
    [sql appendString:@");"];
    
    return [sql autorelease];
}

- (NSString *)removeSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"delete from %@ ",NSStringFromClass(self.class)];
    [sql appendFormat:@"where rowid='%@';",self.rowid];
    return [sql autorelease];
}
- (NSString *)updateSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"update %@ set ",NSStringFromClass(self.class)];
    
    for (NSString *property in self.propertyList)
    {
        if ([property isEqualToString:@"propertyList"]) {
            continue;
        }
        if ([property isEqualToString:@"rowid"]) {
            continue;
        }
        [sql appendFormat:@"%@",property];
        [sql appendFormat:@"="];
        [sql appendFormat:@"%@,",[self valueForKey:property]];
    }
    NSRange lastRange = NSMakeRange(sql.length - 1, 1);
    [sql deleteCharactersInRange:lastRange];
    
    [sql appendFormat:@" where rowid=%@",self.rowid];
    return [sql autorelease];
}
- (NSString *)selectSQL
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select * from %@;",NSStringFromClass(self.class)];
    return [sql autorelease];
}


@end
