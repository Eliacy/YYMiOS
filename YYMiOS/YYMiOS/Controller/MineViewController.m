//
//  MineViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickSettingButton:(id)sender
{

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
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"我的";
    _backButton.hidden = YES;
    
    _settingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _settingButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _settingButton.backgroundColor = [UIColor clearColor];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_settingButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 150)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _tableHeaderView.frame.size.width, _tableHeaderView.frame.size.height - 15)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_backView];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            return 15;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return nil;
        }
            break;
        case 1:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"我的草稿";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"我的折扣券";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"我的小贴士";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"我的备忘录";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"意见反馈";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"关于";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                }
                    break;
                case 1:
                {
                
                }
                    break;
                case 2:
                {
                
                }
                    break;
                case 3:
                {
                
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                }
                    break;
                case 1:
                {
                
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return nil;
}

@end
