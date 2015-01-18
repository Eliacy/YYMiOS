//
//  POISelectViewController.m
//  YYMiOS
//
//  Created by Lide on 15/1/19.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "POISelectViewController.h"
#import "NearbyCell.h"

@interface POISelectViewController ()

@end

@implementation POISelectViewController

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _poiArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"选择店铺";
    
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
    
    UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [POI getPOIListWithOffset:0
                        limit:20
                      keyword:@""
                         area:0
                         city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        range:-1
                     category:0
                        order:0
                    longitude:0
                     latitude:0
                      success:^(NSArray *array) {
                          
                          [_poiArray removeAllObjects];
                          [_poiArray addObjectsFromArray:array];
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
    
    [POI getPOIListWithOffset:0
                        limit:20
                      keyword:@""
                         area:0
                         city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        range:-1
                     category:0
                        order:0
                    longitude:0
                     latitude:0
                      success:^(NSArray *array) {
                          
                          _isLoading = NO;
                          
                          [_poiArray removeAllObjects];
                          [_poiArray addObjectsFromArray:array];
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
    
    [POI getPOIListWithOffset:[_poiArray count]
                        limit:20
                      keyword:@""
                         area:0
                         city:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                        range:-1
                     category:0
                        order:0
                    longitude:0
                     latitude:0
                      success:^(NSArray *array) {
                          
                          _isLoading = NO;
                          
                          [_poiArray addObjectsFromArray:array];
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
    return 155;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_poiArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NearbyViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.poi = [_poiArray objectAtIndex:indexPath.row];
    if(cell.poi.keywordArray && [cell.poi.keywordArray isKindOfClass:[NSArray class]] && [cell.poi.keywordArray count] > 0)
    {
        cell.keywordImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)indexPath.row % 6 + 1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    }
    else
    {
        cell.keywordImageView.image = nil;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate && [_delegate respondsToSelector:@selector(poiSelectViewControllerDidSelectPOI:)])
    {
        [_delegate poiSelectViewControllerDidSelectPOI:[_poiArray objectAtIndex:indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return nil;
}

@end
