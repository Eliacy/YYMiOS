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
#import "ShareKit.h"
#import "Share.h"
#import "DealEditViewController.h"
#import "Tip.h"
#import "ContrylistViewController.h"

@interface DynamicViewController () <DynamicCellDelegate, TitleExpandKitDelegate>

@end

@implementation DynamicViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickTitleButton:(id)sender
{
    //跳转国家选择页面
    ContrylistViewController *countryListVC = [[[ContrylistViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:countryListVC animated:YES];
}

- (void)clickBestButton:(id)sender
{
    if(_expandKit == nil)
    {
        _expandKit = [[[TitleExpandKit alloc] init] retain];
    }
    [_expandKit setItemArray:_optionsArray];
    [_expandKit setDelegate:self];
    [_expandKit setAlign:YYMExpandAlignLeft];
    [_expandKit setWidth:90];
    [_expandKit show];
}

- (void)clickAddButton:(id)sender
{
    DealEditViewController *dealEditVC = [[[DealEditViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:dealEditVC animated:YES];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _dynamicArray = [[NSMutableArray alloc] initWithCapacity:0];
        _citySelected = 0;
        _newSelected = 0;
        _optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
        Tip *option = [[[Tip alloc] init] autorelease];
        option.title = @"全国最新";
        [_optionsArray addObject:option];
        option = [[[Tip alloc] init] autorelease];
        option.title = @"全国精选";
        [_optionsArray addObject:option];
        option = [[[Tip alloc] init] autorelease];
        option.title = @"本城最新";
        [_optionsArray addObject:option];
        option = [[[Tip alloc] init] autorelease];
        option.title = @"本城精选";
        [_optionsArray addObject:option];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _backButton.hidden = YES;
    
    //标题按钮
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setImage:[UIImage imageNamed:@"togetBuy_title_triangle"] forState:UIControlStateNormal];
    _titleButton.frame = CGRectMake(0, 0, _headerView.frame.size.width, 44);
    [_titleButton setBackgroundColor:[UIColor clearColor]];
    [_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 13)];
    [_titleButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    [_titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_titleButton setTitleColor:GColor(136, 136, 136) forState:UIControlStateHighlighted];
    [_headerView addSubview:_titleButton];
    
    _bestButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _bestButton.frame = CGRectMake(2, 2, 90, 40);
    _bestButton.backgroundColor = [UIColor clearColor];
    [_bestButton setTitle:@"全国最新" forState:UIControlStateNormal];
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
    
    //无数据时底图
    [self.view addSubview:[Function noneDataImageViewWithPoint:CGPointMake((self.view.frame.size.width-kNoneDataImgWidth)/2, _headerView.frame.size.height+(self.view.frame.size.height - _adjustView.frame.size.height-kNoneDataImgHeight)/2)]];
    
    //主视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = GColor(238, 238, 238);
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
    
    if([_dynamicArray count]==0||[[Function getAsynchronousWithKey:@"refresh_dynamic_data"] boolValue]==YES){
        [Function setAsynchronousWithObject:[NSNumber numberWithBool:NO] Key:@"refresh_dynamic_data"];
        
        [self.view makeToastActivity];
        [Deal getDealDetailListWithDealId:0
                                    brief:1
                                 selected:_newSelected
                                published:0
                                   offset:0
                                    limit:20
                                     user:0
                                     site:0
                                     city:_citySelected==1?[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]:0
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
                                      
                                      [self.view hideToastActivity];
                                  } failure:^(NSError *error) {
                                      [self.view hideToastActivity];
                                      [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                  }];
    }
    
    //更改标题
    [Function layoutPlayWayBtnWithTitle:[Function getAsynchronousWithKey:@"city_name"] Button:_titleButton];
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
    
    [self.view makeToastActivity];
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:_newSelected
                            published:0
                               offset:0
                                limit:20
                                 user:0
                                 site:0
                                 city:_citySelected==1?[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]:0
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
                                  [self.view hideToastActivity];
                              } failure:^(NSError *error) {
                                  
                                  _isLoading = NO;
                                  [self.view hideToastActivity];
                                  [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
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
    
    [self.view makeToastActivity];
    [Deal getDealDetailListWithDealId:0
                                brief:1
                             selected:_newSelected
                            published:0
                               offset:[_dynamicArray count]
                                limit:20
                                 user:0
                                 site:0
                                 city:_citySelected==1?[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]:0
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
                                  
                                  [self.view hideToastActivity];
                              } failure:^(NSError *error) {
                                  
                                  _isLoading = NO;
                                  [self.view hideToastActivity];
                                  [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
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
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [self.view makeToastActivity];
        [User unfollowSomeoneWithUserId:deal.user.userId
                             fromUserId:[[User sharedUser] userId]
                                success:^(NSArray *array) {
                                    
                                    _isLoading = NO;
                                    
                                    deal.user.followed = !deal.user.followed;
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_dynamicArray indexOfObject:deal] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    
                                    [self.view hideToastActivity];
                                } failure:^(NSError *error) {
                                    
                                    _isLoading = NO;
                                    [self.view hideToastActivity];
                                    [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                }];
    }
    else
    {
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [self.view makeToastActivity];
        [User followSomeoneWithUserId:deal.user.userId
                           fromUserId:[[User sharedUser] userId]
                              success:^(NSArray *array) {
                                  
                                  _isLoading = NO;
                                  
                                  deal.user.followed = !deal.user.followed;
                                  [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_dynamicArray indexOfObject:deal] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                  
                                  [self.view hideToastActivity];
                              } failure:^(NSError *error) {
                                  
                                  _isLoading = NO;
                                  [self.view hideToastActivity];
                                  [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                              }];
    }
}

- (void)dynamicCellDidClickShareButton:(DynamicCell *)dynamicCell
{
    [[ShareKit sharedKit] show];
    //share
//    [Share shareSomethingWithUserId:[[User sharedUser] userId]
//                             siteId:0
//                           reviewId:dynamicCell.deal.dealId
//                          articleId:0
//                             target:@"微信"
//                            success:^(NSArray *array) {
//                                
//                            } failure:^(NSError *error) {
//                                
//                            }];
    [[ShareKit sharedKit] setArticleId:0];
    [[ShareKit sharedKit] setReviewId:dynamicCell.deal.dealId];
    [[ShareKit sharedKit] setSiteId:0];
}

- (void)dynamicCellDidClickLikeButton:(DynamicCell *)dynamicCell
{
    if(dynamicCell.deal.liked)
    {
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [self.view makeToastActivity];
        [Deal unlikeReviewWithUserId:[[User sharedUser] userId]
                            reviewId:dynamicCell.deal.dealId
                             success:^(NSArray *array) {
                                 
                                 _isLoading = NO;
                                 
                                 dynamicCell.deal.liked = NO;
                                 dynamicCell.deal.likeCount -= 1;
                                 [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[_tableView indexPathForCell:dynamicCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                 
                                 [self.view hideToastActivity];
                             } failure:^(NSError *error) {
                                 
                                 _isLoading = NO;
                                 [self.view hideToastActivity];
                                 [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                             }];
    }
    else
    {
        if(_isLoading)
        {
            return;
        }
        _isLoading = YES;
        
        [self.view makeToastActivity];
        [Deal likeReviewWithUserId:[[User sharedUser] userId]
                          reviewId:dynamicCell.deal.dealId
                           success:^(NSArray *array) {
                               
                               _isLoading = NO;
                               
                               dynamicCell.deal.liked = YES;
                               dynamicCell.deal.likeCount += 1;
                               [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[_tableView indexPathForCell:dynamicCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
                               
                               [self.view hideToastActivity];
                           } failure:^(NSError *error) {
                               
                               _isLoading = NO;
                               [self.view hideToastActivity];
                               [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                           }];
    }
}

#pragma mark - TitleExpandKitDelegate

- (void)titleExpandKitDidSelectWithIndex:(NSIndexPath *)indexPath
{
    [_bestButton setTitle:[[_optionsArray objectAtIndex:indexPath.row] title] forState:UIControlStateNormal];
    
    switch (indexPath.row) {
        case 0:
            //全国最新
            _citySelected = 0;
            _newSelected = 0;
            break;
        case 1:
            //全国精选
            _citySelected = 0;
            _newSelected = 1;
            break;
        case 2:
            //本城最新
            _citySelected = 1;
            _newSelected = 0;
            break;
        case 3:
            //本城精选
            _citySelected = 1;
            _newSelected = 1;
            break;
    }
    //请求接口刷新
    [self refreshAfterPull];
    
}

#pragma mark - 标题点击事件
- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //跳转国家选择页面
        ContrylistViewController *countryListVC = [[[ContrylistViewController alloc] init] autorelease];
        [self.tabVC.navigationController pushViewController:countryListVC animated:YES];
    }
}

@end
