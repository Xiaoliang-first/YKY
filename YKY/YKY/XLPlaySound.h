//
//  XLPlaySound.h
//  YKY
//
//  Created by 亮肖 on 15/5/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface XLPlaySound : NSObject
{
    SystemSoundID soundID;
}

/**
 *  @brief  为播放震动效果初始化
 *
 *  @return self
 */
-(id)initForPlayingVibrate;

/**
 *  @brief  为播放系统音效初始化(无需提供音频文件)
 *
 *  @param resourceName 系统音效名称
 *  @param type 系统音效类型
 *
 *  @return self
 */
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;

/**
 *  @brief  为播放特定的音频文件初始化（需提供音频文件）
 *
 *  @param filename 音频文件名（加在工程中）
 *
 *  @return self
 */
-(id)initForPlayingSoundEffectWith:(NSString *)filename;

/**
 *  @brief  播放音效
 */
-(void)play;

@end
