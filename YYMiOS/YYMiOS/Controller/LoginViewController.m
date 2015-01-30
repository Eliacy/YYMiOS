//
//  LoginViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

#pragma mark - private

- (void)clickLoginButton:(id)sender
{
    //检测输入是否合法
    if(_telephoneTextField.text.length==0){
        [self.view makeToast:@"请输入手机号" duration:TOAST_DURATION position:@"center"];
        return;
    }
// 公司内部人员使用的运营账号通常用户名不是手机号，因而暂时不能做这个检查。
//    if(_telephoneTextField.text.length!=11){
//        [self.view makeToast:@"请输入正确的手机号" duration:TOAST_DURATION position:@"center"];
//        return;
//    }
    if(_passwordTextField.text.length==0){
        [self.view makeToast:@"请输入密码" duration:TOAST_DURATION position:@"center"];
        return;
    }
    
    [[LPAPIClient sharedAPIClient] loginWithUserName:_telephoneTextField.text
                                            password:_passwordTextField.text
                                               token:nil
                                              device:@"iOS"
                                             success:^(id respondObject) {
                                                 
                                                 if([respondObject objectForKey:@"data"] && ![[respondObject objectForKey:@"data"] isEqual:[NSNull null]])
                                                 {
                                                     respondObject = [respondObject objectForKey:@"data"];
                                                     if([respondObject objectForKey:@"token"] && ![[respondObject objectForKey:@"token"] isEqual:[NSNull null]])
                                                     {
                                                         [[NSUserDefaults standardUserDefaults] setObject:[respondObject objectForKey:@"token"] forKey:@"user_access_token"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                     }
                                                     
                                                     if([respondObject objectForKey:@"user"] && ![[respondObject objectForKey:@"user"] isEqual:[NSNull null]])
                                                     {
                                                         NSDictionary *userDictionary = [respondObject objectForKey:@"user"];
                                                         if(userDictionary && [userDictionary isKindOfClass:[NSDictionary class]])
                                                         {
                                                             User *user = [[[User alloc] initWithAttribute:userDictionary] autorelease];
                                                             [LPUtility archiveData:[NSArray arrayWithObject:user] IntoCache:@"LoginUser"];
                                                         }
                                                     }
                                                 }
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"login_flag"];
                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchTabViewContrller];
                                                 
                                                 [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[User sharedUser] emUsername]
                                                                                                     password:[[User sharedUser] emPassword]
                                                                                                   completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                                                       
                                                                                                   } onQueue:nil];
                                                 
                                             } failure:^(NSError *error) {
                                                 
                                             }];
}

- (void)clickRegisterButton:(id)sender
{
    RegisterViewController *registerVC = [[[RegisterViewController alloc] init] autorelease];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)doLogin
{
    [self clickLoginButton:nil];
}

#pragma mark - super

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
    
    _titleLabel.text = @"登录";
    _backButton.hidden = YES;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
    [_backView addGestureRecognizer:backViewTap];
    [backViewTap release];
    
    _telephoneBackView = [[UIView alloc] initWithFrame:CGRectMake(40, _adjustView.frame.size.height + 40, self.view.frame.size.width - 40 * 2, 40)];
    _telephoneBackView.backgroundColor = [UIColor whiteColor];
    _telephoneBackView.layer.borderWidth = 0.5;
    _telephoneBackView.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    _telephoneBackView.layer.cornerRadius = 5.0;
    _telephoneBackView.layer.masksToBounds = YES;
    [self.view addSubview:_telephoneBackView];
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, _telephoneBackView.frame.size.width, _telephoneBackView.frame.size.height)];
    _telephoneTextField.backgroundColor = [UIColor clearColor];
    _telephoneTextField.delegate = self;
    _telephoneTextField.returnKeyType = UIReturnKeyNext;
    _telephoneTextField.placeholder = @"手机号";
    [_telephoneBackView addSubview:_telephoneTextField];
 
    _passwordBackView = [[UIView alloc] initWithFrame:CGRectMake(_telephoneBackView.frame.origin.x, _telephoneBackView.frame.origin.y + _telephoneBackView.frame.size.height + 10, _telephoneBackView.frame.size.width, _telephoneBackView.frame.size.height)];
    _passwordBackView.backgroundColor = [UIColor whiteColor];
    _passwordBackView.layer.borderWidth = 0.5;
    _passwordBackView.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    _passwordBackView.layer.cornerRadius = 5.0;
    _passwordBackView.layer.masksToBounds = YES;
    [self.view addSubview:_passwordBackView];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, _passwordBackView.frame.size.width, _passwordBackView.frame.size.height)];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    _passwordTextField.placeholder = @"密码";
    [_passwordBackView addSubview:_passwordTextField];
    
    _loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _loginButton.frame = CGRectMake(_passwordBackView.frame.origin.x, _passwordBackView.frame.origin.y + _passwordBackView.frame.size.height + 40, _passwordBackView.frame.size.width, _passwordBackView.frame.size.height);
    _loginButton.backgroundColor = [UIColor purpleColor];
    _loginButton.layer.cornerRadius = 5.0;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _registerButton.frame = CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y + _loginButton.frame.size.height + 10, _loginButton.frame.size.width, _loginButton.frame.size.height);
    _registerButton.backgroundColor = [UIColor orangeColor];
    _registerButton.layer.cornerRadius = 5.0;
    _registerButton.layer.masksToBounds = YES;
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIGestureRecognizer

- (void)tapBackView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if([_telephoneTextField isFirstResponder])
        {
            [_telephoneTextField resignFirstResponder];
        }
        else if([_passwordTextField isFirstResponder])
        {
            [_passwordTextField resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _telephoneTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if(textField == _passwordTextField)
    {
        [self doLogin];
    }
    
    return YES;
}

@end
