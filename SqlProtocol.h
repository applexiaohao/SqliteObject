//
//  SqlProtocol.h
//  SqliteSample
//
//  Created by Lewis on 13-10-8.
//  Copyright (c) 2013年 www.lanou3g.com  北京蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SqlProtocol <NSObject>

- (NSString *)insertSQL;
- (NSString *)removeSQL;
- (NSString *)updateSQL;

@end
