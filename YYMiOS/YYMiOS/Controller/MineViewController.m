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
#import "MineCell.h"
#import "MessageDetailViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

@synthesize tabVC = _tabVC;
@synthesize user = _user;

#pragma mark - private

- (void)clickSettingButton:(id)sender
{
    // 仅在当前用户不是匿名用户的时候，才允许设置用户属性，否则跳转到登陆/注册界面。。
    if(_user == nil || _user.anonymous)
    {
        LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
        [self.tabVC.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        // 设置部分暂无可用功能，因而暂时跳转到用户属性修改的界面。
        UserInfoViewController *userInfoVC = [[[UserInfoViewController alloc] init] autorelease];
        [self.tabVC.navigationController pushViewController:userInfoVC animated:YES];
//        SettingViewController *settingVC = [[[SettingViewController alloc] init] autorelease];
//        [self.tabVC.navigationController pushViewController:settingVC animated:YES];
    }
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
    followerVC.userId = [[User sharedUser] userId];
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

#pragma mark - 打开与指定用户的聊天界面
- (void)pushFeedbackViewByUserId:(NSInteger)userId
{
    [self.view makeToastActivity];
    [User getUserInfoWithUserId:userId
                         offset:0
                          limit:0
                       followId:0
                          fanId:0
                        success:^(NSArray *array) {
                            
                            if([array count] > 0)
                            {
                                //获取数据成功后打开页面
                                MessageDetailViewController *messageDetailVC = [[[MessageDetailViewController alloc] init] autorelease];
                                messageDetailVC.user = [array objectAtIndex:0];
                                [self.tabVC.navigationController pushViewController:messageDetailVC animated:YES];
                                [self.view hideToastActivity];
                            }else{
                                [self.view hideToastActivity];
                                [self.view makeToast:@"未获取到产品经理信息" duration:TOAST_DURATION position:@"center"];
                            }
                            
                        } failure:^(NSError *error) {
                            [self.view makeToast:@"网络异常" duration:TOAST_DURATION position:@"center"];
                            [self.view hideToastActivity];
                        }];
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
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 150)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, _tableHeaderView.frame.size.width, _tableHeaderView.frame.size.height - 30)];
    _backView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_backView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.layer.cornerRadius = 30.0;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backView addSubview:_avatarImageView];
    
    UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvaterView:)];
    [_avatarImageView addGestureRecognizer:oneFingerTap];
    [_backView addGestureRecognizer:oneFingerTap];
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
    
    NSMutableArray *badges = [Function addBadgesWithArray:user.badges
                                                  OffsetX:_followingButton.frame.origin.x
                                                  OffsetY:_followingButton.frame.origin.y + _followingButton.frame.size.height + 5
                                                    Width:_backView.frame.size.width
                              ];
    for (UIImageView *badge in badges)
    {
        [_backView addSubview:badge];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
            return 1;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MineCell";
    MineCell *cell = (MineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"我的草稿";
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
                    cell.textLabel.text = @"给点鼓励";
                }
                    break;
                case 2:
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
                    //我的草稿
                    DraftViewController *draftVC = [[[DraftViewController alloc] init] autorelease];
                    [self.tabVC.navigationController pushViewController:draftVC animated:YES];
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
                    //打开与产品经理一对一的环信聊天界面
                    [self pushFeedbackViewByUserId:PM_ID];
                }
                    break;
                case 1:
                {
                    //跳转app store 需知道appid;
//                    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APP_ID];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    
                    [self.view makeToast:@"敬请期待" duration:TOAST_DURATION position:@"center"];
                }
                    break;
                case 2:
                {
                    //关于
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

#pragma mark - 跳转个人信息页面
- (void)tapAvaterView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // 仅在当前用户不是匿名用户的时候，才允许设置用户属性，否则跳转到登陆/注册界面。。
        if(_user == nil || _user.anonymous)
        {
            LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
            [self.tabVC.navigationController pushViewController:loginVC animated:YES];
        }
        else
        {
            UserInfoViewController *userInfoVC = [[[UserInfoViewController alloc] init] autorelease];
            [self.tabVC.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
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

@end
