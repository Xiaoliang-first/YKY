//
//  viewsNMB_Tool.m
//  YKY
//
//  Created by 肖亮 on 15/11/10.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "viewsNMB_Tool.h"

#define ClickNumFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ClickNumFile.data"]

@implementation viewsNMB_Tool

+(void)saveViewsClickNmb:(NSMutableArray *)array{
    
    [NSKeyedArchiver archiveRootObject:array toFile:ClickNumFile];
    
}

+(NSMutableArray *)getTheImportentArray{
   
    NSMutableArray * mutableArray = [NSKeyedUnarchiver unarchiveObjectWithFile:ClickNumFile];
    
    return mutableArray;
}

@end
