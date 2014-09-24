//
//  MineViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MineViewController.h"
#import "TabViewController.h"
#import "SettingViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

@synthesize tabVC = _tabVC;

#pragma mark - private

- (void)clickSettingButton:(id)sender
{
    SettingViewController *settingVC = [[[SettingViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:settingVC animated:YES];
}

- (void)clickFollowingButton:(id)sender
{

}

- (void)clickFollowerButton:(id)sender
{

}

- (void)clickLikeButton:(id)sender
{

}

- (void)clickShareButton:(id)sender
{

}

- (void)clickCommentButton:(id)sender
{

}

- (void)clickFavouriteButton:(id)sender
{

}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"我的";
    _backButton.hidden = YES;
    
    _settingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _settingButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _settingButton.backgroundColor = [UIColor clearColor];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_settingButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 150)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _tableHeaderView.frame.size.width, _tableHeaderView.frame.size.height - 15)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_backView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    _avatarImageView.backgroundColor = [UIColor brownColor];
    [_backView addSubview:_avatarImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, _backView.frame.size.width - 20 * 2 - 10 - _avatarImageView.frame.size.width, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    _nameLabel.text = @"我的ID叫小花";
    [_backView addSubview:_nameLabel];
    
    _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followingButton.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, 60, 30);
    _followingButton.backgroundColor = [UIColor clearColor];
    [_followingButton setTitle:@"关注:15" forState:UIControlStateNormal];
    [_followingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followingButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _followingButton.layer.borderWidth = 1.0;
    _followingButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_followingButton];
    
    _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 10, _followingButton.frame.origin.y, 60, 30);
    _followerButton.backgroundColor = [UIColor clearColor];
    [_followerButton setTitle:@"粉丝:15" forState:UIControlStateNormal];
    [_followerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followerButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _followerButton.layer.borderWidth = 1.0;
    _followerButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_followerButton];
    
    _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _likeButton.frame = CGRectMake(0, _backView.frame.size.height - 40, _backView.frame.size.width / 4, 40);
    _likeButton.backgroundColor = [UIColor clearColor];
    [_likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_likeButton];
    
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _shareButton.frame = CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width, _backView.frame.size.height - 40, _backView.frame.size.width / 4, 40);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_shareButton];
    
    _commentButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _commentButton.frame = CGRectMake(_shareButton.frame.origin.x + _shareButton.frame.size.width, _backView.frame.size.height - 40, _backView.frame.size.width / 4, 40);
    _commentButton.backgroundColor = [UIColor clearColor];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_commentButton];
    
    _favouriteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _favouriteButton.frame = CGRectMake(_commentButton.frame.origin.x + _commentButton.frame.size.width, _backView.frame.size.height - 40, _backView.frame.size.width / 4, 40);
    _favouriteButton.backgroundColor = [UIColor clearColor];
    [_favouriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_favouriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _favouriteButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_favouriteButton addTarget:self action:@selector(clickFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_favouriteButton];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            return 15;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return nil;
        }
            break;
        case 1:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)] autorelease];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"我的草稿";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"我的折扣券";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"我的小贴士";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"我的备忘录";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"意见反馈";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"关于";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                }
                    break;
                case 1:
                {
                
                }
                    break;
                case 2:
                {
                
                }
                    break;
                case 3:
                {
                
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                }
                    break;
                case 1:
                {
                
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return nil;
}

@end
