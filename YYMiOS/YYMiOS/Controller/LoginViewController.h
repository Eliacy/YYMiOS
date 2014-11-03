//
//  LoginViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
{
    UIView          *_backView;
    
    UITextField     *_telephoneTextField;
    UITextField     *_passwordTextField;
    
    UIButton        *_loginButton;
    UIButton        *_registerButton;
}

@end
