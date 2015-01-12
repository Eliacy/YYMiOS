//
//  RegisterViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
{
    UIView          *_backView;
    
    UIView          *_telephoneBackView;
    UITextField     *_telephoneTextField;
    UIView          *_passwordBackView;
    UITextField     *_passwordTextField;
    UIView          *_repasswordBackView;
    UITextField     *_repasswordTextField;
    
    UIButton        *_registerButton;
}

@end
