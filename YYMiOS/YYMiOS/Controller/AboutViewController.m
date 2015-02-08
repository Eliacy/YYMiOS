//
//  AboutViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "AboutViewController.h"
#import "NSBundle+Extensions.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    _titleLabel.text = @"关于";
    self.view.backgroundColor = GColor(246, 246, 246);
    
    //上半部分视图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height+40, self.view.frame.size.width, 120)];
    [self.view addSubview:topView];
    
    //图标
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-85)/2, 0, 85, 85)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [topView addSubview:logoImageView];
    
    //版本
    UILabel *versionLabel = [Function createLabelWithFrame:CGRectMake(0, logoImageView.frame.size.height+15, self.view.frame.size.width, 20) FontSize:14 Text:[NSString stringWithFormat:@"V%@",[NSBundle bundleVersion]]];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = GColor(79, 79, 79);
    [topView addSubview:versionLabel];
    
    //下半部分视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-85-65, self.view.frame.size.width, 85)];
    [self.view addSubview:bottomView];
    
    //公司名
    UILabel *companyNameLabel = [Function createLabelWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20) FontSize:14 Text:@"优游美魅（北京）科技有限责任公司"];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:companyNameLabel];
    
    //分割线
    [bottomView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(29, 35, 89, 1)]];
    [bottomView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(203, 35, 89, 1)]];
    UILabel *companyEnglishNameLabel = [Function createLabelWithFrame:CGRectMake(0, 25, self.view.frame.size.width, 20) FontSize:12 Text:@"YOUYOUMM"];
    companyEnglishNameLabel.textAlignment = NSTextAlignmentCenter;
    companyEnglishNameLabel.textColor = GColor(136, 136, 136);
    [bottomView addSubview:companyEnglishNameLabel];
    //版权
    UILabel *copyrightLabel1 = [Function createLabelWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 20) FontSize:12 Text:@"Copyright © 2014 youyoumm.com"];
    copyrightLabel1.textAlignment = NSTextAlignmentCenter;
    copyrightLabel1.textColor = GColor(136, 136, 136);
    [bottomView addSubview:copyrightLabel1];
    UILabel *copyrightLabel2 = [Function createLabelWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 20) FontSize:12 Text:@"All Rights Reserved."];
    copyrightLabel2.textAlignment = NSTextAlignmentCenter;
    copyrightLabel2.textColor = GColor(136, 136, 136);
    [bottomView addSubview:copyrightLabel2];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
