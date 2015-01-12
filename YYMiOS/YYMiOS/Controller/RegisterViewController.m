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
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.placeholder = @"密码";
    [_passwordBackView addSubview:_passwordTextField];
    
    _repasswordBackView = [[UIView alloc] initWithFrame:CGRectMake(_passwordBackView.frame.origin.x, _passwordBackView.frame.origin.y + _passwordBackView.frame.size.height + 10, _passwordBackView.frame.size.width, _passwordBackView.frame.size.height)];
    _repasswordBackView.backgroundColor = [UIColor whiteColor];
    _repasswordBackView.layer.borderWidth = 0.5;
    _repasswordBackView.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    _repasswordBackView.layer.cornerRadius = 5.0;
    _repasswordBackView.layer.masksToBounds = YES;
    [self.view addSubview:_repasswordBackView];
    
    _repasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, _repasswordBackView.frame.size.width, _repasswordBackView.frame.size.height)];
    _repasswordTextField.backgroundColor = [UIColor clearColor];
    _repasswordTextField.secureTextEntry = YES;
    _repasswordTextField.delegate = self;
    _repasswordTextField.returnKeyType = UIReturnKeyGo;
    _repasswordTextField.placeholder = @"确认密码";
    [_repasswordBackView addSubview:_repasswordTextField];
    
    _registerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _registerButton.frame = CGRectMake(_repasswordBackView.frame.origin.x, _repasswordBackView.frame.origin.y + _repasswordBackView.frame.size.height + 40, _repasswordBackView.frame.size.width, _repasswordBackView.frame.size.height);
    _registerButton.backgroundColor = [UIColor purpleColor];
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
