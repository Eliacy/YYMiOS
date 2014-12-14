//
//  FollowerViewController.m
//  YYMiOS
//
//  Created by Lide on 14/12/1.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "FollowerViewController.h"
#import "UserDetailViewController.h"
#import "UserListCell.h"

@interface FollowerViewController ()

@end

@implementation FollowerViewController

@synthesize userId = _userId;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _followerArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"粉丝列表";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [User getUserInfoWithUserId:0
                         offset:0
                          limit:20
                       followId:_userId
                          fanId:0
                        success:^(NSArray *array) {
                            
                            [_followerArray removeAllObjects];
                            [_followerArray addObjectsFromArray:array];
                            [_tableView reloadData];
                            
                        } failure:^(NSError *error) {
                            
                        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_followerArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowerViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.user = [_followerArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[_followerArray objectAtIndex:indexPath.row] userId];
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
    return nil;
}


@end
