//
//  SettingViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    _titleLabel.text = @"设置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _tableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _tableHeaderView.frame.size.width, _tableHeaderView.frame.size.height - 15)];
    _tableBackView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_tableBackView];
    
    _tableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _tableBackView.frame.size.width - 15 * 2, _tableBackView.frame.size.height)];
    _tableHeaderLabel.backgroundColor = [UIColor clearColor];
    _tableHeaderLabel.textColor = [UIColor darkGrayColor];
    _tableHeaderLabel.font = [UIFont systemFontOfSize:18.0f];
    _tableHeaderLabel.text = @"将推送到手机的消息类别";
    [_tableBackView addSubview:_tableHeaderLabel];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.titleLabel.text = @"系统消息推送";
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"私信消息推送";
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"回复提醒推送";
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
    return nil;
}

@end
