//
//  ContrylistViewController.m
//  YYMiOS
//
//  Created by 关旭 on 15-2-11.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "ContrylistViewController.h"
#import "Country.h"
#import "City.h"
#import "CountryCell.h"

@interface ContrylistViewController ()

@end

@implementation ContrylistViewController
{
    //国家列表
    UITableView *countryTableView;
    //存储国家列表数据
    NSMutableArray *countryArray;
    //位置服务
    CLLocation *location;
    //所选城市实体
    City *selectedCity;
    //存储每个section展开收缩判断条件
    NSMutableArray *isSectionExpandArray;
    
}

#pragma mark - 确认
- (void)confirmAction
{
    
    if(!selectedCity){
        [self.view makeToast:@"请选择城市" duration:TOAST_DURATION position:@"center"];
        return;
    }

    //保存所选城市 id、name
    [Function setAsynchronousWithObject:[NSNumber numberWithInt:selectedCity.cityId] Key:@"city_id"];
    [Function setAsynchronousWithObject:selectedCity.cityName Key:@"city_name"];
    
    //选择城市后重置首页、天气、附近三个页面刷新条件
    [Function setAsynchronousWithObject:[NSNumber numberWithBool:YES] Key:@"refresh_home_data"];
    [Function setAsynchronousWithObject:[NSNumber numberWithBool:YES] Key:@"refresh_weather_data"];
    [Function setAsynchronousWithObject:[NSNumber numberWithBool:YES] Key:@"refresh_nearby_data"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击section
- (void)sectionAction:(id)sender
{
    int index = [sender tag];
    //改变当前section状态
    BOOL isSectionExpand = [[isSectionExpandArray objectAtIndex:index] boolValue];
    [isSectionExpandArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isSectionExpand]];
    //刷新section
    [countryTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = @"城市选择";
    
    //确认
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:confirmBtn];
    
    countryArray = [[NSMutableArray alloc] initWithCapacity:0];
    isSectionExpandArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    countryTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, _adjustView.frame.size.height+20, 280, self.view.frame.size.height) style:UITableViewStylePlain];
    countryTableView.dataSource = self;
    countryTableView.delegate = self;
    countryTableView.backgroundView = nil;
    countryTableView.backgroundColor = [UIColor clearColor];
    countryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:countryTableView];
    
    //待获取到位置信息后请求接口，由近到远排序;如果未获取到坐标，只按首字母排序
    [self performSelector:@selector(loadCountryList) withObject:nil afterDelay:.2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取国家列表
- (void)loadCountryList
{
    [self.view makeToastActivity];
    [Country getCountryListWithCountryId:0
                               longitude:location.coordinate.longitude
                                latitude:location.coordinate.latitude
                                 success:^(NSArray *array) {
                                     //获取国家列表 并显示当前选择城市
                                     [countryArray removeAllObjects];
                                     [countryArray addObjectsFromArray:array];
                                     for(Country *coutry in countryArray){
                                         for(City *city in coutry.cityArray){
                                             if([city.cityName isEqualToString:[Function getAsynchronousWithKey:@"city_name"]]){
                                                 selectedCity = city;
                                             }
                                         }
                                     }
                                     
                                     //根据国家列表 添加相应section判断条件
                                     [isSectionExpandArray removeAllObjects];
                                     for(int i=0;i<countryArray.count;i++){
                                         BOOL isSectionExpand;
                                         //默认展开第一个section
                                         if(i==0){
                                             isSectionExpand = YES;
                                         }else{
                                             isSectionExpand = NO;
                                         }
                                         [isSectionExpandArray addObject:[NSNumber numberWithBool:isSectionExpand]];
                                     }
                                     
                                     [self.view hideToastActivity];
                                     [countryTableView reloadData];
                                     
                                 }
                                 failure:^(NSError *error) {
                                     [self.view hideToastActivity];
                                     [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                                 }];
}

#pragma mark -
#pragma mark - 位置回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = [locations objectAtIndex:0];
    GLog(@"纬度： %f",location.coordinate.latitude);
    GLog(@"经度： %f",location.coordinate.longitude);
    
    // 停止位置更新
    [[LocationManager sharedManager] setDelegate:nil];
    [[LocationManager sharedManager] stopUpdatingLocation];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return countryArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 45)];
    sectionView.backgroundColor = [UIColor whiteColor];
    //文字
    UILabel *countryLabel = [Function createLabelWithFrame:CGRectMake(20, 0, 240, 45) FontSize:16 Text:[[countryArray objectAtIndex:section] countryName]];
    [sectionView addSubview:countryLabel];
    //线
    [sectionView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, 44, 280, 1)]];
    //收缩展开
    UIButton *sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionBtn.frame = sectionView.frame;
    sectionBtn.tag = section;
    [sectionBtn addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:sectionBtn];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[isSectionExpandArray objectAtIndex:section] boolValue]==YES){
        return [[[countryArray objectAtIndex:section] cityArray] count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CountryCell";
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //国家
    Country *country = [countryArray objectAtIndex:indexPath.section];
    //城市
    City *city = [country.cityArray objectAtIndex:indexPath.row];
    //cell样式
    [cell layoutCellWithCity:city SelectedCityName:selectedCity.cityName];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //国家
    Country *country = [countryArray objectAtIndex:indexPath.section];
    //所选城市
    selectedCity = [country.cityArray objectAtIndex:indexPath.row];
    //刷新列表
    [countryTableView reloadData];
    
    return nil;
}
@end
