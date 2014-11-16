//
//  RegisterViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>

@end

@implementation RegisterViewController

#pragma mark - private

- (void)clickRegisterButton:(id)sender
{
    [[LPAPIClient sharedAPIClient] registerWithIconId:0
                                             userName:@""
                                               mobile:_telephoneTextField.text
                                             password:_passwordTextField.text
                                               gender:nil
                                                token:nil
                                               device:@"iOS"
                                              success:^(id respondObject) {
                                                  
                                                  if([respondObject objectForKey:@"data"] && ![[respondObject objectForKey:@"data"] isEqual:[NSNull null]])
                                                  {
                                                      respondObject = [respondObject objectForKey:@"data"];
                                                      if([respondObject objectForKey:@"token"] && ![[respondObject objectForKey:@"token"] isEqual:[NSNull null]])
                                                      {
                                                          [[NSUserDefaults standardUserDefaults] setObject:[respondObject objectForKey:@"token"] forKey:@"user_access_token"];
                                                          [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[[respondObject objectForKey:@"user_id"] integerValue]] forKey:@"user_id"];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                      }
                                                  }
                                                  
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"login_flag"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  [(AppDelegate *)[[UIApplication sharedApplication] delegate] lanuchTabViewContrller];
                                                  
                                              } failure:^(NSError *error) {
                                                  
                                              }];
}

- (void)doRegister
{
    [self clickRegisterButton:nil];
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
    
    _titleLabel.text = @"注册";
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
    [_backView addGestureRecognizer:backViewTap];
    [backViewTap release];
    
    _telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, _adjustView.frame.size.height + 40, self.view.frame.size.width - 40 * 2, 40)];
    _telephoneTextField.backgroundColor = [UIColor whiteColor];
    _telephoneTextField.delegate = self;
    _telephoneTextField.returnKeyType = UIReturnKeyNext;
    _telephoneTextField.placeholder = @"手机号";
    [self.view addSubview:_telephoneTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_telephoneTextField.frame.origin.x, _telephoneTextField.frame.origin.y + _telephoneTextField.frame.size.height + 10, _telephoneTextField.frame.size.width, _telephoneTextField.frame.size.height)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.placeholder = @"密码";
    [self.view addSubview:_passwordTextField];
    
    _repasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(_passwordTextField.frame.origin.x, _passwordTextField.frame.origin.y + _passwordTextField.frame.size.height + 10, _passwordTextField.frame.size.width, _passwordTextField.frame.size.height)];
    _repasswordTextField.backgroundColor = [UIColor whiteColor];
    _repasswordTextField.secureTextEntry = YES;
    _repasswordTextField.delegate = self;
    _repasswordTextField.returnKeyType = UIReturnKeyGo;
    _repasswordTextField.placeholder = @"确认密码";
    [self.view addSubview:_repasswordTextField];
    
    _registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _registerButton.frame = CGRectMake(_repasswordTextField.frame.origin.x, _repasswordTextField.frame.origin.y + _repasswordTextField.frame.size.height + 40, _repasswordTextField.frame.size.width, _repasswordTextField.frame.size.height);
    _registerButton.backgroundColor = [UIColor purpleColor];
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
        else if([_repasswordTextField isFirstResponder])
        {
            [_repasswordTextField resignFirstResponder];
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
        [_repasswordTextField becomeFirstResponder];
    }
    else if(textField == _repasswordTextField)
    {
        [self doRegister];
    }
    
    return YES;
}

@end
