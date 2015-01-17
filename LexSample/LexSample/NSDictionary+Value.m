//
//  NSDictionary+Value.m
//  LexView
//
//  Created by LoftLabo on 2014/10/26.
//  Copyright (c) 2014年 LoftLabo. All rights reserved.
//

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)
-(long)locationValue {
    NSNumber *wvalue=[self objectForKey:@"location"];
    return [wvalue longValue];
}
-(long)lengthValue {
    NSNumber *wvalue=[self objectForKey:@"length"];
    return [wvalue longValue];
}
-(int)typeValue {
    NSNumber *wvalue=[self objectForKey:@"type"];
    return [wvalue intValue];
}
-(NSRange)rangeValue {
    NSNumber *location_value=[self objectForKey:@"location"];
    NSNumber *length_value=[self objectForKey:@"length"];
    return NSMakeRange([location_value longValue], [length_value longValue]);
}
-(NSString*)tagName {
    return [self objectForKey:@"tagName"];
}
-(long)tagLevel {
    NSNumber *wvalue=[self objectForKey:@"tagLevel"];
    return [wvalue longValue];
}
@end
