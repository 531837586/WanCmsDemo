//
//  PayPlug.m
//  PayDemo
//
//  Created by sam on 15/11/2.
//  Copyright © 2015年 sam. All rights reserved.
//
#import "WCPayPlug.h"
//---------支付宝---------
#import "WCShareVale.h"
#import "NSObject+WCPayAPI.h"

@interface WCPayPlug ()<UIAlertViewDelegate>
@property (nonatomic, copy)  PayResult block;
@end

@implementation WCPayPlug

//创建该类的单例
+ (instancetype)sharedInstance {
    static id instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
    });
    return instace;
}

- (void)doPay:(PayResult)block {
    self.block = block;
    switch (self.payWay) {
        case AliPay: {
            //支付宝支付
            [self Alipay];
            break;
        }
        default:
            break;
    }
    
}

- (void)Alipay {
    [[AlipaySDK defaultService] payOrder:_alipayInfo.signStr fromScheme:AlipayScheme callback: ^(NSDictionary *resultDic) {
        NSLog(@"回调 = %@", resultDic);
    }];
}

- (void)setAlipayResultDic:(NSDictionary *)alipayResultDic{
    _alipayResultDic = alipayResultDic;
    NSString *statuCode = alipayResultDic[@"resultStatus"];
    if ([statuCode isEqualToString:@"9000"]) {
        if (self.block) {
            self.block(self.payWay, @"充值成功", nil);
        }
    }else if([statuCode isEqualToString:@"6001"]){
        NSError *error = [NSError errorWithDomain:@"支付失败,用户取消支付" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":alipayResultDic[@"memo"]}];
        if (self.block) {
            self.block(self.payWay, @"取消充值", error);
        }
    } else{
        NSError *error = [NSError errorWithDomain:@"支付失败" code:[statuCode integerValue] userInfo:@{@"ErrorInfo":alipayResultDic[@"memo"]}];
        if (self.block) {
            self.block(self.payWay, @"充值失败", error);
            
        }
    }
}




@end
