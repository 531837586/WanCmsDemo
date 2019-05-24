//
//  ViewController.m
//  WanCmsDemo
//
//  Created by 樊星 on 2019/5/23.
//  Copyright © 2019 樊星. All rights reserved.
//

#import "ViewController.h"
 

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)login:(id)sender {
    __weak typeof(self) weakSelf = self;
    // 加载登录界面
    [WCmsSDK loadLoginViewResultSuccess:^(NSString *logintime, NSString *userName, NSString *sign) {
        weakSelf.namelabel.text = userName;
    } failed:^(NSInteger code, NSString *message) {
        NSLog(@"登录失败消息 code = %zd msg =%@", code, message);
        if (code == -9) {
            weakSelf.namelabel.text = nil;
        }
    }];
}

- (IBAction)pay:(id)sender {
    // 加载支付界面
    if (!_namelabel.text.length) {
        [self showWarningMsg:@"请先登录"];
        return;
    }
    [self doPayAlter];
}

- (IBAction)uploadRole:(id)sender {
    if (!self.namelabel.text.length) {
        [self showWarningMsg:@"请先登录"];
        return;
    }
    [WCmsSDK SetUserInfoDataWithRoleId:@"test001"
                              roleName:@"测试员"
                             roleLevel:@"1"
                                zoneId:@"1"
                              zoneName:@"NO.1"
                                attach:@""
                                 block:^(NSInteger code) {
                                     if (code == 1) {
                                         self.messageLabel.text = @"上传成功";
                                     };
                                 }];
}

- (IBAction)loginOut:(id)sender {
    if (!self.namelabel.text.length) {
        [self showWarningMsg:@"请先登录"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定要退出重新登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.namelabel.text = nil;
      
        [WCmsSDK LoginOut];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doPayAlter{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置金额" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertController) weakAlert = alertController;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入有效金额，单位元";
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        NSString *money = [weakAlert.textFields.firstObject text];
        if(money.length == 0){
            money = @"1";
        }
        [self goToPayWithMoney:money];
    }];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)goToPayWithMoney:(NSString *)money{
    [WCmsSDK loadToPayVCWithroleid:@"test001"
                             money:money
                          serverid:@"1"
                       productName:[NSString stringWithFormat:@"%@元宝", money]
                       productDesc:@""
                            attach:@""
                           success:^(NSString *message, NSString *money) {
                               self.messageLabel.text = message;
                           } faild:^(NSString *message, NSInteger code, NSString *money) {
                               self.messageLabel.text = message;
                           }];
}

- (void)showWarningMsg:(NSString *)msg{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alterVC addAction:okAction];
    [self presentViewController:alterVC animated:YES completion:nil];
}

@end
