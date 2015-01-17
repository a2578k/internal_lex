//
//  NSDictionary+Value.h
//  LexView
//
//  Created by LoftLabo on 2014/10/26.
//  Copyright (c) 2014年 LoftLabo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Value)

-(long)locationValue;
-(long)lengthValue;
-(int)typeValue;
-(long)tagLevel;
-(NSRange)rangeValue;
-(NSString*)tagName;
@end
