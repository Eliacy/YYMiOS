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
#import "TitleExpandKit.h"

@interface HomeViewController () <TitleExpandKitDelegate>

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
    
    [City getCityListWithCityId:0
                        success:^(NSArray *array) {
                            
                            [_cityArray removeAllObjects];
                            [_cityArray addObjectsFromArray:array];
                            
                            if([_cityArray count] > 0)
                            {
                                _titleLabel.text = [[_cityArray objectAtIndex:0] cityName];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[[_cityArray objectAtIndex:0] cityName] forKey:@"city_name"];
                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[[_cityArray objectAtIndex:0] cityId]] forKey:@"city_id"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [Article getArticleListWithArticleId:0
                                                               brief:1
                                                              offset:0
                                                               limit:20
                                                              cityId:[[_cityArray objectAtIndex:0] cityId]
                                                             success:^(NSArray *array) {
                                                                 
                                                                 [_homeArray removeAllObjects];
                                                                 [_homeArray addObjectsFromArray:array];
                                                                 [_tableView reloadData];
                                                                 
                                                             } failure:^(NSError *error) {
                                                                 
                                                             }];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
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

- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [[TitleExpandKit sharedKit] setItemArray:_cityArray];
        [[TitleExpandKit sharedKit] setDelegate:self];
        [[TitleExpandKit sharedKit] show];
    }
}

#pragma mark - TitleExpandKitDelegate

- (void)titleExpandKitDidSelectWithIndex:(NSIndexPath *)indexPath
{
    _titleLabel.text = [[_cityArray objectAtIndex:indexPath.row] cityName];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[_cityArray objectAtIndex:indexPath.row] cityName] forKey:@"city_name"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[[_cityArray objectAtIndex:indexPath.row] cityId]] forKey:@"city_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Article getArticleListWithArticleId:0
                                   brief:1
                                  offset:0
                                   limit:20
                                  cityId:[[_cityArray objectAtIndex:indexPath.row] cityId]
                                 success:^(NSArray *array) {
                                     
                                     [_homeArray removeAllObjects];
                                     [_homeArray addObjectsFromArray:array];
                                     [_tableView reloadData];
                                     
                                 } failure:^(NSError *error) {
                                     
                                 }];
}


@end
