//
//  MineViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MineViewController.h"
#import "TabViewController.h"
#import "UserInfoViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"

#import "DraftViewController.h"

#import "FeedbackViewController.h"
#import "AboutViewController.h"

#import "FollowerViewController.h"
#import "FollowingViewController.h"
#import "UserDetailViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

@synthesize tabVC = _tabVC;
@synthesize user = _user;

#pragma mark - private

- (void)clickSettingButton:(id)sender
{
    SettingViewController *settingVC = [[[SettingViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:settingVC animated:YES];
}

- (void)clickMessageButton:(id)sender
{
    MessageViewController *messageVC = [[[MessageViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:messageVC animated:YES];
}

- (void)clickFollowingButton:(id)sender
{
//    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
//    userDetailVC.userId = [[User sharedUser] userId];
//    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
    FollowingViewController *followingVC = [[[FollowingViewController alloc] init] autorelease];
    followingVC.userId = [[User sharedUser] userId];
    [self.tabVC.navigationController pushViewController:followingVC animated:YES];
}

- (void)clickFollowerButton:(id)sender
{
//    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
//    userDetailVC.userId = [[User sharedUser] userId];
//    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
    FollowerViewController *followerVC = [[[FollowerViewController alloc] init] autorelease];
    [self.tabVC.navigationController pushViewController:followerVC animated:YES];
}

- (void)clickLikeButton:(id)sender
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[User sharedUser] userId];
    userDetailVC.detailType = DetailLike;
    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
}

- (void)clickShareButton:(id)sender
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[User sharedUser] userId];
    userDetailVC.detailType = DetailShare;
    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
}

- (void)clickCommentButton:(id)sender
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[User sharedUser] userId];
    userDetailVC.detailType = DetailComment;
    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
}

- (void)clickFavouriteButton:(id)sender
{
    UserDetailViewController *userDetailVC = [[[UserDetailViewController alloc] init] autorelease];
    userDetailVC.userId = [[User sharedUser] userId];
    userDetailVC.detailType = DetailCollect;
    [self.tabVC.navigationController pushViewController:userDetailVC animated:YES];
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
    _titleLabel.text = @"我的主页";
    _backButton.hidden = YES;
    
    _settingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _settingButton.frame = CGRectMake(2, 2, 40, 40);
    _settingButton.backgroundColor = [UIColor clearColor];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_settingButton];
    
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
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 150)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _tableHeaderView.frame.size.width, _tableHeaderView.frame.size.height - 30)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_backView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.layer.cornerRadius = 30;
    _avatarImageView.layer.masksToBounds = YES;
    [_backView addSubview:_avatarImageView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvaterView:)];
    [_avatarImageView addGestureRecognizer:oneFingerTap];
    [oneFingerTap release];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, _backView.frame.size.width - 20 * 2 - 10 - _avatarImageView.frame.size.width, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    [_backView addSubview:_nameLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, _nameLabel.frame.origin.y + (_nameLabel.frame.size.height - 15) / 2, 24, 15)];
    _levelLabel.backgroundColor = [UIColor colorWithRed:197.0 / 255.0 green:197.0 / 255.0 blue:197.0 / 255.0 alpha:1.0];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.font = [UIFont systemFontOfSize:10.0f];
    _levelLabel.textAlignment = NSTextAlignmentCenter;
    _levelLabel.layer.cornerRadius = 2.0;
    _levelLabel.layer.masksToBounds = YES;
    [_backView addSubview:_levelLabel];
    
    _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followingButton.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, 60, 20);
    _followingButton.backgroundColor = [UIColor clearColor];
    [_followingButton setTitleColor:[UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    _followingButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    _followingButton.layer.borderWidth = 0.5;
    _followingButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
    [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    _followingButton.layer.cornerRadius = 2.0;
    _followingButton.layer.masksToBounds = YES;
    [_backView addSubview:_followingButton];
    
    _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followingButton.frame.origin.y, 60, 20);
    _followerButton.backgroundColor = [UIColor clearColor];
    [_followerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _followerButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    _followerButton.layer.borderWidth = 0.5;
    _followerButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
    [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    _followerButton.layer.cornerRadius = 2.0;
    _followerButton.layer.masksToBounds = YES;
    [_backView addSubview:_followerButton];
    
    UIView *firstLine = [[[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height - 35 - 0.5, _backView.frame.size.width, 0.5)] autorelease];
    firstLine.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_backView addSubview:firstLine];
    
    _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _likeButton.frame = CGRectMake(0, _backView.frame.size.height - 35, _backView.frame.size.width / 4, 35);
    _likeButton.backgroundColor = [UIColor clearColor];
    [_likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
    [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _likeButton.titleLabel.numberOfLines = 0;
    _likeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_likeButton];
    
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _shareButton.frame = CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width, _backView.frame.size.height - 35, _backView.frame.size.width / 4, 35);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _shareButton.titleLabel.numberOfLines = 0;
    _shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_shareButton];
    
    _commentButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _commentButton.frame = CGRectMake(_shareButton.frame.origin.x + _shareButton.frame.size.width, _backView.frame.size.height - 35, _backView.frame.size.width / 4, 35);
    _commentButton.backgroundColor = [UIColor clearColor];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _commentButton.titleLabel.numberOfLines = 0;
    _commentButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_commentButton];
    
    _favouriteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _favouriteButton.frame = CGRectMake(_commentButton.frame.origin.x + _commentButton.frame.size.width, _backView.frame.size.height - 35, _backView.frame.size.width / 4, 35);
    _favouriteButton.backgroundColor = [UIColor clearColor];
    [_favouriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_favouriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _favouriteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _favouriteButton.titleLabel.numberOfLines = 0;
    _favouriteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_favouriteButton addTarget:self action:@selector(clickFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_favouriteButton];
    
    UIView *secondLine = [[[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height - 1, _backView.frame.size.width, 1)] autorelease];
    secondLine.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_backView addSubview:secondLine];
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
    
    [User getUserInfoWithUserId:[[User sharedUser] userId]
                         offset:0
                          limit:1
                       followId:0
                          fanId:0
                        success:^(NSArray *array) {
                            
                            if([array count] > 0)
                            {
                                [self setUser:[array objectAtIndex:0]];
                                [LPUtility archiveData:array IntoCache:@"LoginUser"];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
    
    [self setUser:[User sharedUser]];
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

- (void)setUser:(User *)user
{
    if(_user != nil)
    {
        LP_SAFE_RELEASE(_user);
    }
    _user = [user retain];
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:user.userIcon.imageURL imageSize:CGSizeMake(120, 120)]]];
    _nameLabel.text = user.userName;
    
    CGSize nameSize = [LPUtility getTextHeightWithText:_nameLabel.text font:_nameLabel.font size:CGSizeMake(300, 100)];
    _levelLabel.frame = CGRectMake(_nameLabel.frame.origin.x + nameSize.width + 5, _levelLabel.frame.origin.y, _levelLabel.frame.size.width, _levelLabel.frame.size.height);
    _levelLabel.text = [NSString stringWithFormat:@"%i级", user.level];
    
    NSString *followingString = [NSString stringWithFormat:@"关注:%i", user.followCount];
    CGSize followingSize = [LPUtility getTextHeightWithText:followingString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
    _followingButton.frame = CGRectMake(_followingButton.frame.origin.x, _followingButton.frame.origin.y, followingSize.width + 20, _followingButton.frame.size.height);
    [_followingButton setTitle:followingString forState:UIControlStateNormal];
    
    NSString *followerString = [NSString stringWithFormat:@"粉丝:%i", user.fanCount];
    CGSize followerSize = [LPUtility getTextHeightWithText:followerString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followerButton.frame.origin.y, followerSize.width + 20, _followerButton.frame.size.height);
    [_followerButton setTitle:followerString forState:UIControlStateNormal];
    
    [_likeButton setTitle:[NSString stringWithFormat:@"喜欢\n%i", user.likeCount] forState:UIControlStateNormal];
    [_shareButton setTitle:[NSString stringWithFormat:@"分享\n%i", user.shareCount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"评论\n%i", user.reviewCount] forState:UIControlStateNormal];
    [_favouriteButton setTitle:[NSString stringWithFormat:@"收藏\n%i", user.favouriteCount] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
                    DraftViewController *draftVC = [[[DraftViewController alloc] init] autorelease];
                    [self.tabVC.navigationController pushViewController:draftVC animated:YES];
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
                    FeedbackViewController *feedbackVC = [[[FeedbackViewController alloc] init] autorelease];
                    [self.tabVC.navigationController pushViewController:feedbackVC animated:YES];
                }
                    break;
                case 1:
                {
                    AboutViewController *aboutVC = [[[AboutViewController alloc] init] autorelease];
                    [self.tabVC.navigationController pushViewController:aboutVC animated:YES];
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

#pragma mark - UIGestureRecognizer

- (void)tapAvaterView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        UserInfoViewController *userInfoVC = [[[UserInfoViewController alloc] init] autorelease];
        [self.tabVC.navigationController pushViewController:userInfoVC animated:YES];
    }
}

@end
