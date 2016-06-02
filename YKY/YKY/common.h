//
//  common.h
//  一块摇
//
//  Created by 亮肖 on 15/4/22.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.



#ifndef ____common_h
#define ____common_h

//  1标示移动端  0 标示pc端
#define Kclient @1
//  单点登录标志
#define KotherLogin @100100
//  第三方id尚未在yky平台绑定
#define KnoBangding @101010
//  手机号未在yky平台注册‘
#define KnoRegist @101011
//  没有数据
#define knoData @100103


//局域网电脑
#define kbaseURL @"http://192.168.1.110:8090"
///ykyInterface
//#define kbaseURL @"http://192.168.1.91:8090/ykyInterface"
//#define kbaseURL @"http://192.168.1.31:8080"



//公司外网接口
//#define kbaseURL @"http://api.yikuaiyao.com"

//#define kbaseURL @"http://220.194.52.2:8084/ykyInterface"


/** 加载城市列表数据接口 */
#define kgetCityListStr [kbaseURL stringByAppendingString:@"/system/systemCityInfo"]

#define kYGCityListStr @"/system/shakeCityInfo"

/** 商家推荐加载模拟数据的接口 */
#define KmanagerCommendatoryStr [kbaseURL stringByAppendingString:@"/index/merchantSuggest"]

/** 加载商家环境的图片的接口 */
#define kbossEnvironmentStr [kbaseURL stringByAppendingString:@"/index/merchantImages"]

/** 是否需要获取提醒奖品列表接口 */
#define kremindStr [kbaseURL stringByAppendingString:@"/coupons/isCouponsExpire"]

/** 获取签到接口 */
#define kgetrigstStr [kbaseURL stringByAppendingString:@"/user/checkinInspect"]

/** 确认签到接口 */
#define kokregistStr [kbaseURL stringByAppendingString:@"/user/checkin"]

/** 首页广告图片数据的请求接口 */
#define khomeBannerStr [kbaseURL stringByAppendingString:@"/index/bannerAdver"]

/** 首页用户扫描接口 */
#define kuserSaomiaoStr @"/coupons/selectCouponsInMerchant"

/** 首页获取奖品数据接口 */
#define khomePrizeDataStr [kbaseURL stringByAppendingString:@"/index/prizeList"]

/** 加载本期大奖数据接口 */
#define kcurrentBigPrizeDataStr [kbaseURL stringByAppendingString:@"/index/prizeDetial"]

/** 获取中奖名单列表的接口 */
#define klistOfAwardWinnersStr [kbaseURL stringByAppendingString:@"/index/firstCoupons"]

/** 更多界面获取列表接口 */
#define ktheMoreStr [kbaseURL stringByAppendingString:@"/viewPrizeListMore_prizeJson.action"]

/** 活动专区加载活动列表的接口 */
#define kactivityListStr [kbaseURL stringByAppendingString:@"/index/merchantActivityList"]

/** 获取活动详情列表的接口 */
#define kactivityDetailListStr [kbaseURL stringByAppendingString:@"/index/activityPrizeList"]

/** 活动详情列表获取顶部banner的接口 */
#define kactivityDetailBannerStr [kbaseURL stringByAppendingString:@"/index/activityBannerAdver"]

/** 活动专区奖品活动详情数据接口 */
#define kactivityDetailDataStr [kbaseURL stringByAppendingString:@"/index/prizeDetial"]

/** 活动摇接口 */
#define kactivityRockingStr [kbaseURL stringByAppendingString:@"/activeShake"]

/** 奖兜搜索奖品方法接口 */
#define kboundSearchStr [kbaseURL stringByAppendingString:@"/coupons/shakeCoupons"]

/** 奖兜请求奖兜奖品列表数据方法接口 */
#define kboundsPrizeDataListStr [kbaseURL stringByAppendingString:@"/coupons/shakeCoupons"]

/** 奖兜奖品兑换银币接口 */
#define kduihuanPrizeStr [kbaseURL stringByAppendingString:@"/coupons/couponsExchange"]

/** 奖兜多选删除接口 */
#define kboundsDuoxuanshanchuStr [kbaseURL stringByAppendingString:@"/deledtAMDCoupons_couponsJson.action"]

/** 奖兜获取奖品详情数据接口 */
#define kboundDetailDataStr [kbaseURL stringByAppendingPathComponent:@"/coupons/prizeDetailView"]

/** 奖兜奖品详情删除奖品接口 */
#define kdeleatePeizeStr [kbaseURL stringByAppendingString:@"/deledtAMDCoupons_couponsJson.action"]

/** 奖兜奖品详情兑换银币接口 */
#define kboundPrizeduihuanYb [kbaseURL stringByAppendingString:@"/coupons/couponsExchange"]

/** 获取提醒奖品列表的接口 */
#define kgetRemaindListStr [kbaseURL stringByAppendingString:@"/coupons/couponsExpireRemind"]

//
///** 摇奖界面获取奖品分类数据接口 */
//#define krockingGetKindsStr @"/system/kinds"

/** 摇奖界面获取界面信息的接口 */
#define krockingGetPageDataStr [kbaseURL stringByAppendingString:@"/viewPrizeBigest_couponsJson.action"]

/**  摇奖界面随意摇接口*/
#define krockingStr [kbaseURL stringByAppendingString:@"/shake"]

/** 充值界面获取界面信息接口 */
#define kchargePageDataStr [kbaseURL stringByAppendingString:@"/viewTbUserForClient_clientUser.action"]

/** 充值界面获取微信支付结果信息接口 */
#define kchargeGetWehatResultStr [kbaseURL stringByAppendingString:@"/viewTbUserForClient_clientUser.action"]

/** 充值界面微信支付接口 */
#define kweixinPay [kbaseURL stringByAppendingString:@"/clientRecharge/saveRechargeForWX"]

/** 我的界面设置用户信息接口 */
#define kmeSetUserDataStr [kbaseURL stringByAppendingString:@"/user/userInfoView"]

/** 忘记密码界面验证手机号是否存在的接口 */
#define kauthPhoneStr [kbaseURL stringByAppendingString:@"/user/validateUserExist"]

/** 忘记密码接口 */
#define kforgetPwdStr [kbaseURL stringByAppendingString:@"/user/findPwd"]

/** 注册界面验证手机号是否可被注册接口 */
#define ksignAuthPhoneStr [kbaseURL stringByAppendingString:@"/user/validateUserExist"]

///** 注册界面获取注册城市信息接口 */
//#define ksignGetCitylistStr [kbaseURL stringByAppendingString:@"/viewCityInformation_cityJson.action"]

/** 注册接口 */
#define ksignStr [kbaseURL stringByAppendingString:@"/user/registered"]

/** 登录按钮点击事件接口 */
#define kLogInStr [kbaseURL stringByAppendingString:@"/user/login"]

/** 验证第三方id是否在后台有注册或者绑定接口 */
#define kauthPhoneNmbStr [kbaseURL stringByAppendingString:@"/user/thirdLogin"]

/** 绑定第三方登陆号接口 */
#define kBangDingStr [kbaseURL stringByAppendingString:@"/user/thirdBindingUser"]

//第三方绑定注册
#define kthirdRegist [kbaseURL stringByAppendingString:@"/user/thirdRegistered"]

/** 帮助中心接口 */
#define kHelpCenterStr [kbaseURL stringByAppendingString:@"/common/functionInstruction.jsp"]

/** 系统通知接口 */
#define ksystemNoticeStr [kbaseURL stringByAppendingString:@"/system/systemMessageInfo"]

/** 服务协议接口 */
#define ksevrceXieYiStr [kbaseURL stringByAppendingString:@"/common/serviceDetail.jsp"]

/** 产品吐槽接口 */
#define kFeedBackStr [kbaseURL stringByAppendingString:@"/user/feedBack"]

/** 充值记录接口 */
#define kmyChargeStr [kbaseURL stringByAppendingPathComponent:@"/user/recordRecharge"]

/** 消息中心接口 */
#define kmessageCenterStr [kbaseURL stringByAppendingString:@"/system/systemMessageInfo"]

/** 修改密码接口 */
#define kfixPwdStr [kbaseURL stringByAppendingString:@"/user/updatePwd"]

/** 修改手机号接口 */
#define kFixPhoneNmbStr [kbaseURL stringByAppendingString:@"/user/updateAccount"]

/** 提交新的用户信息接口 */
#define kUpdateUserMessageStr [kbaseURL stringByAppendingString:@"/user/updateUserInfo"]

/** 用户上传头像到服务器接口 */
#define kUserSendIconImgStr [kbaseURL stringByAppendingString:@"/user/headImageUpload"]








/***********************商家登陆端*************************/



/** 商家登录接口 */
#define kBossLogInStr [kbaseURL stringByAppendingString:@"/merchant/login"]

/** 根据扫描结果获取奖券信息接口 */
#define kGetPrizeDataStr [kbaseURL stringByAppendingString:@"/merchant/checkCoupons"]

/** 商家使用奖券按钮点击时用的接口 */
#define kUserUsePrizeStr [kbaseURL stringByAppendingString:@"/merchant/toUseCoupons"]

/** 商家查询本店消费记录接口 */
#define kcheckCouponsListStr [kbaseURL stringByAppendingString:@"/merchant/selectUesd"]

/** 登陆商家密码修改接口 */
#define kBossFixPwdStr [kbaseURL stringByAppendingString:@"/merchant/updatePwd"]


















#endif
