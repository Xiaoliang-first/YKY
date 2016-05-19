//
//  YGLookOldItems.h
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YGLookOldModel;
@interface YGLookOldItems : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlesLabel;
@property (nonatomic) int indexNum;
@property (nonatomic , strong) YGLookOldModel * model;
@property (nonatomic , copy) NSString * serials;

@end
