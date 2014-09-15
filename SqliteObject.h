//
//  SqliteObject.h
//  SqliteSample
//
//  Created by Lewis on 13-12-4.
//  Copyright (c) 2013年 www.lanou3g.com  北京蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//作为封装库的基类
@interface SqliteObject : NSObject

@property (nonatomic ,copy)NSString *rowid;

+ (id)object;

- (NSString *)createSQL;
- (NSString *)dropSQL;
- (NSString *)insertSQL;
- (NSString *)removeSQL;
- (NSString *)updateSQL;
- (NSString *)selectSQL;

@end
