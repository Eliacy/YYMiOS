//
//  TipsViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TipsViewController.h"
#import "Tip.h"
#import "TipsDetailViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _tipsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"Tips";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Tip getTipsListWithTipsId:0
                         brief:1
                        cityId:0
                       success:^(NSArray *array) {
                           
                           [_tipsArray removeAllObjects];
                           [_tipsArray addObjectsFromArray:array];
                           [_tableView reloadData];
                           
                       } failure:^(NSError *error) {
                           
                       }];
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
    return [_tipsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipsViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [[_tipsArray objectAtIndex:indexPath.row] title];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TipsDetailViewController *tipsDetailVC = [[[TipsDetailViewController alloc] init] autorelease];
    tipsDetailVC.tipsId = [[_tipsArray objectAtIndex:indexPath.row] tipId];
    [self.navigationController pushViewController:tipsDetailVC animated:YES];
    
    return nil;
}

@end
