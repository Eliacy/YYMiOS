//
//  LoginViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - private

- (void)clickLoginButton:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchTabViewContrller];
}

- (void)clickRegisterButton:(id)sender
{
    RegisterViewController *registerVC = [[[RegisterViewController alloc] init] autorelease];
    [self.navigationController pushViewController:registerVC animated:YES];
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
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, _adjustView.frame.size.height + 40, self.view.frame.size.width - 40 * 2, 40)];
    _telephoneTextField.backgroundColor = [UIColor whiteColor];
    _telephoneTextField.placeholder = @"手机号";
    [self.view addSubview:_telephoneTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_telephoneTextField.frame.origin.x, _telephoneTextField.frame.origin.y + _telephoneTextField.frame.size.height + 10, _telephoneTextField.frame.size.width, _telephoneTextField.frame.size.height)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.placeholder = @"密码";
    [self.view addSubview:_passwordTextField];
    
    _loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _loginButton.frame = CGRectMake(_passwordTextField.frame.origin.x, _passwordTextField.frame.origin.y + _passwordTextField.frame.size.height + 40, _passwordTextField.frame.size.width, _passwordTextField.frame.size.height);
    _loginButton.backgroundColor = [UIColor purpleColor];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _registerButton.frame = CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y + _loginButton.frame.size.height + 10, _loginButton.frame.size.width, _loginButton.frame.size.height);
    _registerButton.backgroundColor = [UIColor orangeColor];
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

@end
