//
//  PayPlug.h
//  PayDemo
//
//  Created by sam on 15/11/2.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlipaySDK/AlipaySDK.h"
#import "WCResponseInfo.h"
#import <WanCmsSDK/WCmsSDK.h>

typedef NS_ENUM (NSUInteger, TpayWay) {
    AliPay,
};
typedef void (^PayResult)(TpayWay way, id obj, NSError *error);

@interface WCPayPlug : NSObject
@property (nonatomic, assign)  TpayWay payWay; // 支付方式
@property (nonatomic, strong) AlipayInfo *alipayInfo;

+ (instancetype)sharedInstance;

- (void)doPay:(PayResult)blcok;

@property (nonatomic, strong) NSDictionary *alipayResultDic;


@end
