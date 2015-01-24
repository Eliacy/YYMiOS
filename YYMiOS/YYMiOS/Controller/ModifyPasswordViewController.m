//
//  ModifyPasswordViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
{
    //密码输入框
    UITextField *oldPwdTextField,*newPwdTextField,*confirmPwdTextField;
}

@end

@implementation ModifyPasswordViewController

- (id)init
{
    self = [super init];
    if(self != nil)
    {
    
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"修改密码";
    
    //点击背景隐藏键盘
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = self.view.frame;
    hideBtn.backgroundColor = [UIColor clearColor];
    [hideBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideBtn];
    
    //保存
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [saveBtn addTarget:self action:@selector(saveGender) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:saveBtn];
    
    //统一标准
    int leftX = 15;
    int topY = 20;
    int gapY = 7;
    int height = 40;
    int fontSize = 16;
    
    //原密码
    UIView *oldPwdView = [Function createTextFieldBGWithFrame:CGRectMake(leftX, _adjustView.frame.size.height+topY, self.view.frame.size.width-leftX*2, height)];
    [self.view addSubview:oldPwdView];
    UILabel *oldPwdLabel = [Function createLabelWithFrame:CGRectMake(7, 0, 80, height) FontSize:fontSize Text:@"原密码"];
    [oldPwdView addSubview:oldPwdLabel];
    oldPwdTextField = [Function createTextFieldWithFrame:CGRectMake(90, 0, 180, height) Target:self];
    oldPwdTextField.secureTextEntry = YES;
    oldPwdTextField.placeholder = @"请输入原密码";
    oldPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [oldPwdView addSubview:oldPwdTextField];
    
    //新密码
    UIView *newPwdView = [Function createTextFieldBGWithFrame:CGRectMake(leftX, _adjustView.frame.size.height+topY+height+gapY, self.view.frame.size.width-leftX*2, height)];
    [self.view addSubview:newPwdView];
    UILabel *newPwdLabel = [Function createLabelWithFrame:CGRectMake(7, 0, 80, height) FontSize:fontSize Text:@"新密码"];
    [newPwdView addSubview:newPwdLabel];
    newPwdTextField = [Function createTextFieldWithFrame:CGRectMake(90, 0, 180, height) Target:self];
    newPwdTextField.secureTextEntry = YES;
    newPwdTextField.placeholder = @"请输入新密码";
    newPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [newPwdView addSubview:newPwdTextField];
    
    //确认密码
    UIView *confirmPwdView = [Function createTextFieldBGWithFrame:CGRectMake(leftX, _adjustView.frame.size.height+topY+(height+gapY)*2, self.view.frame.size.width-leftX*2, height)];
    [self.view addSubview:confirmPwdView];
    UILabel *confirmPwdLabel = [Function createLabelWithFrame:CGRectMake(7, 0, 80, height) FontSize:fontSize Text:@"确认密码"];
    [confirmPwdView addSubview:confirmPwdLabel];
    confirmPwdTextField = [Function createTextFieldWithFrame:CGRectMake(90, 0, 180, height) Target:self];
    confirmPwdTextField.secureTextEntry = YES;
    confirmPwdTextField.placeholder = @"请再次输入新密码";
    confirmPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [confirmPwdView addSubview:confirmPwdTextField];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保存密码
- (void)saveGender
{
    //隐藏键盘
    [self hideKeyboard];
    //检测
    if(oldPwdTextField.text.length<USER_PWD_MIN_LENGTH||oldPwdTextField.text.length>USER_PWD_MAX_LENGTH){
        [self.view makeToast:@"原密码长度应在6-30位之间" duration:TOAST_DURATION position:@"center"];
        return;
    }
    if(newPwdTextField.text.length<USER_PWD_MIN_LENGTH||newPwdTextField.text.length>USER_PWD_MAX_LENGTH){
        [self.view makeToast:@"新密码长度应在6-30位之间" duration:TOAST_DURATION position:@"center"];
        return;
    }
    if(![newPwdTextField.text isEqualToString:confirmPwdTextField.text]){
        [self.view makeToast:@"两次输入的密码不一致" duration:TOAST_DURATION position:@"center"];
        return;
    }
    
    //请求接口
    [self.view makeToastActivity];
    [User modifyUserInfoWithUserId:[[User sharedUser] userId]
                            iconId:0
                          userName:nil
                          password:newPwdTextField.text
                            gender:nil
                           success:^(NSArray *array) {
                               //更新用户信息
                               if([array count] > 0)
                               {
                                   [LPUtility archiveData:array IntoCache:@"LoginUser"];
                               }
                               [self.view hideToastActivity];
                               //修改成功直接返回用户信息设置页面
                               [self.navigationController popViewControllerAnimated:YES];
                               [self.view.window makeToast:@"密码修改成功" duration:TOAST_DURATION position:@"center"];
                               
                           } failure:^(NSError *error) {
                               [self.view hideToastActivity];
                               [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                           }];
     
    
}

#pragma mark - 隐藏键盘
- (void)hideKeyboard
{
    [oldPwdTextField resignFirstResponder];
    [newPwdTextField resignFirstResponder];
    [confirmPwdTextField resignFirstResponder];
}


@end
