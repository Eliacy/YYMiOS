//
//  HomeViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "HomeViewController.h"
#import "TabViewController.h"
#import "HomeCell.h"

#import "TipsViewController.h"
#import "MessageViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickTipsButton:(id)sender
{
    TipsViewController *tipsVC = [[[TipsViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:tipsVC animated:YES];
}

- (void)clickMessageButton:(id)sender
{
    MessageViewController *messageVC = [[[MessageViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _homeArray = [[NSMutableArray alloc] initWithCapacity:0];
        //fake data
        [_homeArray addObjectsFromArray:[NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil]];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"首页";
    _backButton.hidden = YES;
    
    _tipsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _tipsButton.frame = CGRectMake(2, 2, 40, 40);
    _tipsButton.backgroundColor = [UIColor clearColor];
    [_tipsButton setTitle:@"Tips" forState:UIControlStateNormal];
    [_tipsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tipsButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_tipsButton addTarget:self action:@selector(clickTipsButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_tipsButton];
    
    _messageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _messageButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _messageButton.backgroundColor = [UIColor clearColor];
    [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
    [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _messageButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_messageButton addTarget:self action:@selector(clickMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_messageButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 10)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_homeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
