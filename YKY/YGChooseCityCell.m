//
//  YGChooseCityCell.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGChooseCityCell.h"
#import "cityModel.h"

@implementation YGChooseCityCell

-(void)setCitymodel:(cityModel *)citymodel{
    _citymodel = citymodel;

    if (citymodel.ciName) {
        _CurrentCityLabel.text = citymodel.ciName;
    }
}

@end
