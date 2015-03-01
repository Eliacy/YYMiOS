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
#import "ArticleViewController.h"

#import "TipsViewController.h"
#import "MessageViewController.h"
#import "Article.h"
#import "City.h"
#import "Country.h"
#import "ContrylistViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickTitleButton:(id)sender
{
    //跳转国家选择页面
    ContrylistViewController *countryListVC = [[[ContrylistViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:countryListVC animated:YES];
}

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

- (void)refreshMessageCount:(NSInteger)count
{
    if(count == 0)
    {
        _messageCountLabel.hidden = YES;
    }
    else
    {
        _messageCountLabel.hidden = NO;
        
        NSString *string = count > 99 ? @"99+" : [NSString stringWithFormat:@"%i", (int)count];
        CGSize stringSize = [LPUtility getTextHeightWithText:string font:_messageCountLabel.font size:CGSizeMake(100, 100)];
        _messageCountLabel.frame = CGRectMake(_messageButton.frame.size.width - stringSize.width - 6, 5, stringSize.width + 6, 12);
        _messageCountLabel.text = string;
    }
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _cityArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _homeArray = [[NSMutableArray alloc] initWithCapacity:0];
        
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
    
    _messageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_messageButton.frame.size.width - 12, 5, 12, 12)];
    _messageCountLabel.backgroundColor = [UIColor redColor];
    _messageCountLabel.layer.cornerRadius = 6.0f;
    _messageCountLabel.layer.masksToBounds = YES;
    _messageCountLabel.textColor = [UIColor whiteColor];
    _messageCountLabel.font = [UIFont systemFontOfSize:10.0f];
    _messageCountLabel.textAlignment = NSTextAlignmentCenter;
    [_messageButton addSubview:_messageCountLabel];
    _messageCountLabel.hidden = YES;
    
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
    
    //首次进入未选择城市时 填充美国下方默认城市 以请求文章列表
    if([[Function getAsynchronousWithKey:@"city_name"] length]==0){
        [self.view makeToastActivity];
        [Country getCountryListWithCountryId:0
                                   longitude:0
                                    latitude:0
                                     success:^(NSArray *array) {
                                         
                                         for(Country *country in array){
                                             //默认取id与美国的default_city_id一致的城市
                                             if([country.countryName isEqualToString:@"美国"]){
                                                 for(City *city in country.cityArray){
                                                     if(city.cityId==country.defaultCityId){
                                                         //保存于本地数据库
                                                         [Function setAsynchronousWithObject:[NSNumber numberWithInt:city.cityId] Key:@"city_id"];
                                                         [Function setAsynchronousWithObject:city.cityName Key:@"city_name"];
                                                         //更改标题
                                                         [Function layoutPlayWayBtnWithTitle:[Function getAsynchronousWithKey:@"city_name"] Button:_titleButton];
                                                     }
                                                 }
                                             }
                                         }
                                         
                                         //请求文章列表
                                         [Article getArticleListWithArticleId:0
                                                                        brief:1
                                                                       offset:0
                                                                        limit:20
                                                                       cityId:[[Function getAsynchronousWithKey:@"city_id"] integerValue]
                                                                      success:^(NSArray *array) {
                                                                          
                                                                          [_homeArray removeAllObjects];
                                                                          [_homeArray addObjectsFromArray:array];
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
                                     failure:^(NSError *error) {
                                         [self.view hideToastActivity];
                                         [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                     }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
    
    //用户首次打开应用 city_name为空 故联网已经在viewDidLoad执行 此处不再请求
    if([[Function getAsynchronousWithKey:@"city_name"] length]!=0){
        //用户进入应用没有数据时或选择城市后返回该页面 刷新文章列表
        if([_homeArray count]==0||[[Function getAsynchronousWithKey:@"refresh_home_data"] boolValue]==YES){
            
            [Function setAsynchronousWithObject:[NSNumber numberWithBool:NO] Key:@"refresh_home_data"];
            
            [self.view makeToastActivity];
            [Article getArticleListWithArticleId:0
                                           brief:1
                                          offset:0
                                           limit:20
                                          cityId:[[Function getAsynchronousWithKey:@"city_id"] integerValue]
                                         success:^(NSArray *array) {
                                             
                                             [_homeArray removeAllObjects];
                                             [_homeArray addObjectsFromArray:array];
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
    [Article getArticleListWithArticleId:0
                                   brief:1
                                  offset:0
                                   limit:20
                                  cityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                                 success:^(NSArray *array) {
                                     
                                     _isLoading = NO;
                                     
                                     [_homeArray removeAllObjects];
                                     [_homeArray addObjectsFromArray:array];
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

#pragma mark - 加载更多
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
    [Article getArticleListWithArticleId:0
                                   brief:1
                                  offset:[_homeArray count]
                                   limit:20
                                  cityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                                 success:^(NSArray *array) {
                                     
                                     _isLoading = NO;
                                     
                                     [_homeArray addObjectsFromArray:array];
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
    
    cell.article = [_homeArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *articleVC = [[[ArticleViewController alloc] init] autorelease];
    articleVC.articleId = [[_homeArray objectAtIndex:indexPath.row] articleId];
    [self.tabVC.navigationController pushViewController:articleVC animated:YES];
    
    return nil;
}


@end
