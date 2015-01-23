//
//  NicknameViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NicknameViewController.h"
#import "User.h"

@interface NicknameViewController ()

@end

@implementation NicknameViewController
{
    UITextField *userNameTextFiled;
}

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    _titleLabel.text = @"名字";
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [saveBtn addTarget:self action:@selector(saveUserName) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:saveBtn];
    
    //修改昵称
    UIView *userNameBG = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 40)];
    userNameBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userNameBG];
    
    userNameTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 40)];
    userNameTextFiled.backgroundColor = [UIColor clearColor];
    [userNameTextFiled setBorderStyle:UITextBorderStyleNone];
    userNameTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTextFiled.returnKeyType = UIReturnKeyDone;
    userNameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    userNameTextFiled.delegate = self;
    userNameTextFiled.text = [[User sharedUser] userName];
    [userNameBG addSubview:userNameTextFiled];
    [userNameTextFiled becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 保存用户昵称
- (void)saveUserName
{
    //检测是否为空
    if(userNameTextFiled.text.length==0){
        [self.view makeToast:@"请输入昵称" duration:TOAST_DURATION position:@"center"];
        return;
    }
    //检测长度
    if(userNameTextFiled.text.length>USER_NAME_LENGTH){
        [self.view makeToast:@"昵称长度不应超过10位" duration:TOAST_DURATION position:@"center"];
        return;
    }
    //请求接口
    [self.view makeToastActivity];
    [User modifyUserInfoWithUserId:[[User sharedUser] userId]
                            iconId:0
                          userName:userNameTextFiled.text
                          password:nil
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
                               [self.view.window makeToast:@"昵称修改成功" duration:TOAST_DURATION position:@"center"];
                               
                           } failure:^(NSError *error) {
                               [self.view hideToastActivity];
                               [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                           }];
    
}

#pragma mark -
#pragma mark - UITextFiled delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveUserName];
    return YES;
}

@end
