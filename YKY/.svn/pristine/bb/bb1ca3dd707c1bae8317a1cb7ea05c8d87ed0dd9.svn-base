//
//  NSString+utf8.m
//  YKY
//
//  Created by 亮肖 on 15/4/30.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "NSString+utf8.h"

@implementation NSString (utf8)

-(NSString *)URLEncodingUTF8String{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}
-(NSString *)URLDecodingUTF8String{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
    return result;
}

@end
