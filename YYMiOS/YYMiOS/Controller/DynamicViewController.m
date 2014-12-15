//
//  DynamicViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DynamicViewController.h"
#import "TabViewController.h"
#import "DynamicCell.h"

#import "DealDetailViewController.h"
#import "Deal.h"

#import "UserDetailViewController.h"

@interface DynamicViewController () <DynamicCellDelegate>

@end

@implementation DynamicViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickBestButton:(id)sender
{

}

- (void)clickAddButton:(id)sender
{

}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"动态";
    _backButton.hidden = YES;
    
    _bestButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _bestButton.frame = CGRectMake(2, 2, 40, 40);
    _bestButton.backgroundColor = [UIColor clearColor];
    [_bestButton setTitle:@"精选" forState:UIControlStateNormal];
    [_bestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bestButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_bestButton addTarget:self action:@selector(clickBestButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_bestButton];
    
    _addButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _addButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _addButton.backgroundColor = [UIColor clearColor];
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_addButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:187.0 / 255.0 green:187.0 / 255.0 blue:187.0 / 255.0 alpha:1.0];
    _slimeView.slime.skinColor = [UIColor colorWithRed:187.0 / 255.0 green:187.0 / 255.0 blue:187.0 / 255.0 alpha:1.0];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor clearColor];
    [_tableView addSubview:_slimeView];
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 10)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
    
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:0
                            published:0
                               offset:0
                                limit:20
                                 user:0
                                 site:0
                                 city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                              success:^(NSArray *array) {
                                  
                                  [_dynamicArray removeAllObjects];
                                  [_dynamicArray addObjectsFromArray:array];
                                  [_tableView reloadData];
                                  
                                  if([array count] < 20)
                                  {
                                      _isHaveMore = NO;
                                  }
                                  else
                                  {
                                      _isHaveMore = YES;
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                              }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!_isAppear)
    {
        return;
    }
    _isAppear = NO;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
    
    if(_tableView.contentOffset.y + _tableView.frame.size.height > _tableView.contentSize.height - 500 && _tableView.contentSize.height > _tableView.frame.size.height)
    {
        [self loadMore];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - SlimeRefreshDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:0
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    [self performSelector:@selector(refreshAfterPull) withObject:nil afterDelay:0];
}

- (void)refreshAfterPull
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:0
                            published:0
                               offset:0
                                limit:20
                                 user:0
                                 site:0
                                 city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                              success:^(NSArray *array) {
                                  
                                  _isLoading = NO;
                                  
                                  [_dynamicArray removeAllObjects];
                                  [_dynamicArray addObjectsFromArray:array];
                                  [_tableView reloadData];
                                  
                                  if([array count] < 20)
                                  {
                                      _isHaveMore = NO;
                                  }
                                  else
                                  {
                                      _isHaveMore = YES;
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                                  _isLoading = NO;
                                  
                              }];
}

- (void)loadMore
{
    if(!_isHaveMore)
    {
        return;
    }
    
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:0
                            published:0
                               offset:[_dynamicArray count]
                                limit:20
                                 user:0
                                 site:0
                                 city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                              success:^(NSArray *array) {
                                  
                                  _isLoading = NO;
                                  
                                  [_dynamicArray addObjectsFromArray:array];
                                  [_tableView reloadData];
                                  
                                  if([array count] < 20)
                                  {
                                      _isHaveMore = NO;
                                  }
                                  else
                                  {
                                      _isHaveMore = YES;
                                  }
                                  
                              } failure:^(NSError *error) {
                                  
                                  _isLoading = NO;
                                  
                              }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 445.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dynamicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.deal = [_dynamicArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
    dealDetailVC.dealId = [[_dynamicArray objectAtIndex:indexPath.row] dealId];
    dealDetailVC.siteId = [[[_dynamicArray objectAtIndex:indexPath.row] site] siteId];
    [self.tabVC.navigationController pushViewController:dealDetailVC animated:YES];
    
    return nil;
}

#pragma mark - DynamicCellDelegate

- (void)dynamicCellDidTapAvatarImageView:(DynamicCell *)dynamicCell
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = dynamicCell.deal.user.userId;
    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
}

- (void)dynamicCellDidClickFollowButton:(DynamicCell *)dynamicCell
{
    Deal *deal = dynamicCell.deal;
    if(deal.user.followed)
    {
        [User unfollowSomeoneWithUserId:deal.user.userId
                             fromUserId:[[User sharedUser] userId]
                                success:^(NSArray *array) {
                                    
                                    deal.user.followed = !deal.user.followed;
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_dynamicArray indexOfObject:deal] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    
                                } failure:^(NSError *error) {
                                    
                                }];
    }
    else
    {
        [User followSomeoneWithUserId:deal.user.userId
                           fromUserId:[[User sharedUser] userId]
                              success:^(NSArray *array) {
                                  
                                  deal.user.followed = !deal.user.followed;
                                  [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_dynamicArray indexOfObject:deal] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  
                              } failure:^(NSError *error) {
                                  
                              }];
    }
}

- (void)dynamicCellDidClickShareButton:(DynamicCell *)dynamicCell
{

}

@end
