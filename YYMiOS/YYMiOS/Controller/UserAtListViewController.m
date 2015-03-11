//
//  UserAtListViewController.m
//  YYMiOS
//
//  Created by Lide on 15/1/20.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "UserAtListViewController.h"
#import "UserListCell.h"

@interface UserAtListViewController ()

@end

@implementation UserAtListViewController

#pragma mark - private

- (void)clickConfirmButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(userAtListViewControllerDidClickConfirmButton:)])
    {
        [_delegate userAtListViewControllerDidClickConfirmButton:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickFollowingButton:(id)sender
{
    [_followingButton setSelected:YES];
    [_followerButton setSelected:NO];
    
    _type = 0;
    [_tableView reloadData];
}

- (void)clickFollowerButton:(id)sender
{
    [_followingButton setSelected:NO];
    [_followerButton setSelected:YES];
    
    _type = 1;
    [_tableView reloadData];
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _selectArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        _type = 0;
        _followingArray = [[NSMutableArray alloc] initWithCapacity:0];
        _followerArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"我要@TA";
    
    _confirmButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _confirmButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _confirmButton.backgroundColor = [UIColor clearColor];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_confirmButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followingButton.frame = CGRectMake(_tableHeaderView.frame.size.width / 2 - 70, 5, 70, 30);
    _followingButton.backgroundColor = [UIColor clearColor];
    _followingButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _followingButton.layer.borderWidth = 1.0f;
    [_followingButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followingButton setTitleColor:[UIColor colorWithRed:240.0 / 255.0 green:158.0 / 255.0 blue:194.0 / 255.0 alpha:1.0] forState:UIControlStateSelected];
    [_followingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_followingButton];
    [_followingButton setSelected:YES];
    
    _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followerButton.frame = CGRectMake(_tableHeaderView.frame.size.width / 2, 5, 70, 30);
    _followerButton.backgroundColor = [UIColor clearColor];
    _followerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _followerButton.layer.borderWidth = 1.0f;
    [_followerButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [_followerButton setTitleColor:[UIColor colorWithRed:240.0 / 255.0 green:158.0 / 255.0 blue:194.0 / 255.0 alpha:1.0] forState:UIControlStateSelected];
    [_followerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_followerButton];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [User getUserInfoWithUserId:0
                         offset:0
                          limit:20
                       followId:0
                          fanId:[[User sharedUser] userId]
                        success:^(NSArray *array) {
                            
                            [_followingArray removeAllObjects];
                            [_followingArray addObjectsFromArray:array];
                            [_tableView reloadData];
                            
                        } failure:^(NSError *error) {
                            
                        }];
    
    [User getUserInfoWithUserId:0
                         offset:0
                          limit:20
                       followId:[[User sharedUser] userId]
                          fanId:0
                        success:^(NSArray *array) {
                            
                            [_followerArray removeAllObjects];
                            [_followerArray addObjectsFromArray:array];
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

- (void)setSelectArray:(NSMutableArray *)selectArray
{
    [_selectArray removeAllObjects];
    [_selectArray addObjectsFromArray:selectArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_type == 0)
    {
        return [_followingArray count];
    }
    else
    {
        return [_followerArray count];
    }
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
    
    if(_type == 0)
    {
        cell.user = [_followingArray objectAtIndex:indexPath.row];
    }
    else
    {
        cell.user = [_followerArray objectAtIndex:indexPath.row];
    }
    
    BOOL exist = NO;
    for(User *user in _selectArray)
    {
        if(user.userId == cell.user.userId)
        {
            exist = YES;
            break;
        }
    }
    
    if(exist)
    {
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_selected.png"]] autorelease];
    }
    else
    {
        cell.accessoryView = nil;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == 0)
    {
        BOOL exist = NO;
        for(User *user in _selectArray)
        {
            if(user.userId == [[_followingArray objectAtIndex:indexPath.row] userId])
            {
                exist = YES;
                [_selectArray removeObject:user];
                break;
            }
        }
        
        if(exist)
        {
//            [_selectArray removeObject:[_followingArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [_selectArray addObject:[_followingArray objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        BOOL exist = NO;
        for(User *user in _selectArray)
        {
            if(user.userId == [[_followerArray objectAtIndex:indexPath.row] userId])
            {
                exist = YES;
                [_selectArray removeObject:user];
                break;
            }
        }
        
        if(exist)
        {
//            [_selectArray removeObject:[_followerArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [_selectArray addObject:[_followerArray objectAtIndex:indexPath.row]];
        }
    }
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    return nil;
}

@end
