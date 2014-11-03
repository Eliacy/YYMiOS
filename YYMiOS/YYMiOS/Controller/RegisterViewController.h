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
    
    UITextField     *_telephoneTextField;
    UITextField     *_passwordTextField;
    UITextField     *_repasswordTextField;
    
    UIButton        *_registerButton;
}

@end
