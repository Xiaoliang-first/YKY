//
//  homeMyYGLuckNumCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/22.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeMyYGLuckNumCell.h"
#import "homeMyYGLuckNumModel.h"

@interface homeMyYGLuckNumCell()

@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;

@end


@implementation homeMyYGLuckNumCell

-(void)setModel:(homeMyYGLuckNumModel *)model{
    _model = model;
    UIView * bac = [[UIView alloc]init];
    bac.backgroundColor = YKYClearColor;
    self.selectedBackgroundView = bac;
    if (model.time) {
        self.joinTimeLabel.text = model.time;
    }
    if (model.unum) {
        self.joinNumLabel.text = [NSString stringWithFormat:@"%@次",model.unum];
    }
}


- (IBAction)luckMyLuckNumBtnClick:(id)sender {
    NSString * index = [NSString stringWithFormat:@"%d",self.index];
    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"index-lookMyLuckNum"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lookMyLuckNum" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"lookMyLuckNum" object:@(_index) userInfo:nil];
}



@end
