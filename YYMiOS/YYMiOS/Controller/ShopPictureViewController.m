//
//  ShopPictureViewController.m
//  YYMiOS
//
//  Created by Lide on 14/11/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopPictureViewController.h"

@interface ShopPictureViewController ()

@end

@implementation ShopPictureViewController

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"晒单照片";
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
