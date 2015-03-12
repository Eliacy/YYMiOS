//
//  UserDetailViewController.m
//  YYMiOS
//
//  Created by Lide on 14/11/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "UserDetailViewController.h"
#import "DynamicCell.h"
#import "NearbyCell.h"
#import "Deal.h"
#import "POI.h"
#import "DealDetailViewController.h"
#import "ShopViewController.h"
#import "FollowingViewController.h"
#import "FollowerViewController.h"
#import "Share.h"
#import "HomeCell.h"
#import "ArticleViewController.h"
#import "MessageDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

@synthesize userId = _userId;
@synthesize user = _user;

@synthesize detailType = _detailType;

#pragma mark - private

- (void)clickMessageButton:(id)sender
{
    MessageDetailViewController *messageDetailVC = [[[MessageDetailViewController alloc] init] autorelease];
    messageDetailVC.user = _user;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

- (void)clickFollowButton:(id)sender
{
    if(_user.followed)
    {
        [self.view makeToastActivity];
        [User unfollowSomeoneWithUserId:_user.userId
                             fromUserId:[[User sharedUser] userId]
                                success:^(NSArray *array) {
                                    
                                    _user.followed = !_user.followed;
                                    if(_user.followed)
                                    {
                                        [_followButton setTitle:@"取消" forState:UIControlStateNormal];
                                    }
                                    else
                                    {
                                        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                                    }
                                    
                                    [self.view hideToastActivity];
                                } failure:^(NSError *error) {
                                    [self.view hideToastActivity];
                                    
                                }];
    }
    else
    {
        [self.view makeToastActivity];
        [User followSomeoneWithUserId:_user.userId
                           fromUserId:[[User sharedUser] userId]
                              success:^(NSArray *array) {
                                  
                                  _user.followed = !_user.followed;
                                  if(_user.followed)
                                  {
                                      [_followButton setTitle:@"取消" forState:UIControlStateNormal];
                                  }
                                  else
                                  {
                                      [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                                  }
                                  
                                  [self.view hideToastActivity];
                              } failure:^(NSError *error) {
                                  [self.view hideToastActivity];
                                  
                              }];
    }
}

- (void)clickFollowingButton:(id)sender
{
    FollowingViewController *followingVC = [[[FollowingViewController alloc] init] autorelease];
    followingVC.userId = _userId;
    [self.navigationController pushViewController:followingVC animated:YES];
}

- (void)clickFollowerButton:(id)sender
{
    FollowerViewController *followerVC = [[[FollowerViewController alloc] init] autorelease];
    followerVC.userId = _userId;
    [self.navigationController pushViewController:followerVC animated:YES];
}

#pragma mark - 点击喜欢
- (void)clickLikeButton:(id)sender
{
    if([_likeButton isSelected])
    {
        return;
    }
    
    //初始化状态
    _noneDataImageView.hidden = NO;
    [_likeButton setSelected:YES];
    [_shareButton setSelected:NO];
    [_commentButton setSelected:NO];
    [_favouriteButton setSelected:NO];
    
    _likeButton.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _shareButton.backgroundColor = [UIColor clearColor];
    _commentButton.backgroundColor = [UIColor clearColor];
    _favouriteButton.backgroundColor = [UIColor clearColor];
    
    _type = 1;
    [_tableView reloadData];
    
    if([_likeArray count] == 0)
    {
        [self.view makeToastActivity];
        [Deal getReviewLikeListWithOffset:0
                                    limit:20
                                   userId:_userId
                                  success:^(NSArray *array) {
                                      
                                      //有数据时隐藏无数据底图
                                      if(array.count>0){
                                          _noneDataImageView.hidden = YES;
                                      }
                                      
                                      [_likeArray removeAllObjects];
                                      [_likeArray addObjectsFromArray:array];
                                      [_tableView reloadData];
                                      
                                      [self.view hideToastActivity];
                                  } failure:^(NSError *error) {
                                      [self.view hideToastActivity];
                                  }];
    }else{
        //有数据时隐藏无数据底图
        _noneDataImageView.hidden = YES;
    }
}

#pragma mark - 点击分享
- (void)clickShareButton:(id)sender
{
    if([_shareButton isSelected])
    {
        return;
    }
    
    //初始化状态
    _noneDataImageView.hidden = NO;
    [_shareButton setSelected:YES];
    [_likeButton setSelected:NO];
    [_commentButton setSelected:NO];
    [_favouriteButton setSelected:NO];
    
    _shareButton.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _likeButton.backgroundColor = [UIColor clearColor];
    _commentButton.backgroundColor = [UIColor clearColor];
    _favouriteButton.backgroundColor = [UIColor clearColor];
    
    _type = 2;
    [_tableView reloadData];
    
    if([_shareArray count] == 0)
    {
        [self.view makeToastActivity];
        [Share getShareListWithOffset:0
                                limit:20
                               userId:[[User sharedUser] userId]
                              success:^(NSArray *array) {
                                  
                                  //有数据时隐藏无数据底图
                                  if(array.count>0){
                                      _noneDataImageView.hidden = YES;
                                  }
                                  
                                  [_shareArray removeAllObjects];
                                  [_shareArray addObjectsFromArray:array];
                                  [_tableView reloadData];
                                  
                                  [self.view hideToastActivity];
                              } failure:^(NSError *error) {
                                  [self.view hideToastActivity];
                              }];
    }else{
        //有数据时隐藏无数据底图
        _noneDataImageView.hidden = YES;
    }
}

#pragma mark - 点击评论
- (void)clickCommentButton:(id)sender
{
    if([_commentButton isSelected])
    {
        return;
    }
    
    //初始化状态
    _noneDataImageView.hidden = NO;
    [_commentButton setSelected:YES];
    [_shareButton setSelected:NO];
    [_likeButton setSelected:NO];
    [_favouriteButton setSelected:NO];
    
    _commentButton.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _shareButton.backgroundColor = [UIColor clearColor];
    _likeButton.backgroundColor = [UIColor clearColor];
    _favouriteButton.backgroundColor = [UIColor clearColor];
    
    _type = 3;
    [_tableView reloadData];
    
    if([_commentArray count] == 0)
    {
        [self.view makeToastActivity];
        [Deal getDealDetailListWithDealId:0
                                    brief:1
                                 selected:0
                                published:0
                                   offset:0
                                    limit:20
                                     user:_userId
                                     site:0
                                     city:0
                                  success:^(NSArray *array) {
                                      
                                      //有数据时隐藏无数据底图
                                      if(array.count>0){
                                          _noneDataImageView.hidden = YES;
                                      }
                                      
                                      [_commentArray removeAllObjects];
                                      [_commentArray addObjectsFromArray:array];
                                      [_tableView reloadData];
                                      
                                      [self.view hideToastActivity];
                                  } failure:^(NSError *error) {
                                      [self.view hideToastActivity];
                                  }];
    }else{
        //有数据时隐藏无数据底图
        _noneDataImageView.hidden = YES;
    }
}

#pragma mark - 点击收藏
- (void)clickFavouriteButton:(id)sender
{
    if([_favouriteButton isSelected])
    {
        return;
    }
    
    //初始化状态
    _noneDataImageView.hidden = NO;
    [_favouriteButton setSelected:YES];
    [_shareButton setSelected:NO];
    [_commentButton setSelected:NO];
    [_likeButton setSelected:NO];
    
    _favouriteButton.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    _shareButton.backgroundColor = [UIColor clearColor];
    _commentButton.backgroundColor = [UIColor clearColor];
    _likeButton.backgroundColor = [UIColor clearColor];
    
    _type = 4;
    [_tableView reloadData];
    
    if([_favouriteArray count] == 0)
    {
        [self.view makeToastActivity];
        [POI getPOIFavouriteListWithOffset:0
                                     limit:20
                                    userId:_userId
                                   success:^(NSArray *array) {
                                       
                                       //有数据时隐藏无数据底图
                                       if(array.count>0){
                                           _noneDataImageView.hidden = YES;
                                       }
                                       
                                       [_favouriteArray removeAllObjects];
                                       [_favouriteArray addObjectsFromArray:array];
                                       [_tableView reloadData];
                                       
                                       [self.view hideToastActivity];
                                   } failure:^(NSError *error) {
                                       [self.view hideToastActivity];
                                   }];
    }else{
        //有数据时隐藏无数据底图
        _noneDataImageView.hidden = YES;
    }
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _type = 1;
        
        _likeArray = [[NSMutableArray alloc] initWithCapacity:0];
        _shareArray = [[NSMutableArray alloc] initWithCapacity:0];
        _commentArray = [[NSMutableArray alloc] initWithCapacity:0];
        _favouriteArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"个人主页";
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    _messageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _messageButton.frame = CGRectMake(0, 0, _footerView.frame.size.width, _footerView.frame.size.height);
    _messageButton.backgroundColor = [UIColor colorWithRed:249.0 / 255.0 green:100.0 / 255.0 blue:128.0 / 255.0 alpha:1.0];
    [_messageButton setTitle:@"发消息" forState:UIControlStateNormal];
    [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_messageButton addTarget:self action:@selector(clickMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_messageButton];
    
    _followButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _followButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _followButton.backgroundColor = [UIColor clearColor];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_followButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height - _footerView.frame.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 1)] autorelease];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
    
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
    [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _likeButton.titleLabel.numberOfLines = 0;
    _likeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_likeButton];
    
    _likeButton.selected = YES;
    _likeButton.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:107.0 / 255.0 blue:135.0 / 255.0 alpha:1.0];
    
    _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _shareButton.frame = CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width, _backView.frame.size.height - 35, _backView.frame.size.width / 4, 35);
    _shareButton.backgroundColor = [UIColor clearColor];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
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
    [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
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
    [_favouriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _favouriteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _favouriteButton.titleLabel.numberOfLines = 0;
    _favouriteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_favouriteButton addTarget:self action:@selector(clickFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_favouriteButton];
    
    UIView *secondLine = [[[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height - 1, _backView.frame.size.width, 1)] autorelease];
    secondLine.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_backView addSubview:secondLine];
    
    //无数据时底图
    _noneDataImageView = [Function noneDataImageViewWithPoint:CGPointMake((_tableHeaderView.frame.size.width-kNoneDataImgWidth)/2, _tableHeaderView.frame.origin.y+_tableHeaderView.frame.size.height+(_tableView.frame.size.height-_tableHeaderView.frame.origin.y-_tableHeaderView.frame.size.height-kNoneDataImgHeight)/2)];
    [_tableHeaderView addSubview:_noneDataImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [User getUserInfoWithUserId:_userId
                         offset:0
                          limit:0
                       followId:0
                          fanId:0
                        success:^(NSArray *array) {
                            
                            if([array count] > 0)
                            {
                                [self setUser:[array objectAtIndex:0]];
                            }
                            
                        } failure:^(NSError *error) {
                            
                        }];
    
    switch (_detailType) {
        case DetailLike:
        {
            [Deal getReviewLikeListWithOffset:0
                                        limit:20
                                       userId:_userId
                                      success:^(NSArray *array) {
                                          
                                          [_likeArray removeAllObjects];
                                          [_likeArray addObjectsFromArray:array];
                                          [_tableView reloadData];
                                          
                                      } failure:^(NSError *error) {
                                          
                                      }];
        }
            break;
        case DetailShare:
        {
            [self clickShareButton:nil];
        }
            break;
        case DetailComment:
        {
            [self clickCommentButton:nil];
        }
            break;
        case DetailCollect:
        {
            [self clickFavouriteButton:nil];
        }
            break;
        default:
            break;
    }
    
    if(_userId == [[User sharedUser] userId])
    {
        _footerView.hidden = YES;
        _tableView.frame = CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(User *)user
{
    if(_user != nil)
    {
        LP_SAFE_RELEASE(_user);
    }
    _user = [user retain];
    
    if(user.followed)
    {
        [_followButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:user.userIcon.imageURL imageSize:CGSizeMake(120, 120)]]];
    _nameLabel.text = user.userName;
    
    CGSize nameSize = [LPUtility getTextHeightWithText:_nameLabel.text font:_nameLabel.font size:CGSizeMake(300, 100)];
    _levelLabel.frame = CGRectMake(_nameLabel.frame.origin.x + nameSize.width + 5, _levelLabel.frame.origin.y, _levelLabel.frame.size.width, _levelLabel.frame.size.height);
    _levelLabel.text = [NSString stringWithFormat:@"%li级", (long)user.level];
    
    NSString *followingString = [NSString stringWithFormat:@"关注:%li", (long)user.followCount];
    CGSize followingSize = [LPUtility getTextHeightWithText:followingString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
    _followingButton.frame = CGRectMake(_followingButton.frame.origin.x, _followingButton.frame.origin.y, followingSize.width + 20, _followingButton.frame.size.height);
    [_followingButton setTitle:followingString forState:UIControlStateNormal];
    
    NSString *followerString = [NSString stringWithFormat:@"粉丝:%li", (long)user.fanCount];
    CGSize followerSize = [LPUtility getTextHeightWithText:followerString font:[UIFont systemFontOfSize:11.0f] size:CGSizeMake(200, 100)];
    _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followerButton.frame.origin.y, followerSize.width + 20, _followerButton.frame.size.height);
    [_followerButton setTitle:followerString forState:UIControlStateNormal];
    
    [_likeButton setTitle:[NSString stringWithFormat:@"喜欢\n%li", (long)user.likeCount] forState:UIControlStateNormal];
    [_shareButton setTitle:[NSString stringWithFormat:@"分享\n%li", (long)user.shareCount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"评论\n%li", (long)user.reviewCount] forState:UIControlStateNormal];
    [_favouriteButton setTitle:[NSString stringWithFormat:@"收藏\n%li", (long)user.favouriteCount] forState:UIControlStateNormal];
    [_likeButton setTitle:[NSString stringWithFormat:@"喜欢\n%li", (long)user.likeCount] forState:UIControlStateSelected];
    [_shareButton setTitle:[NSString stringWithFormat:@"分享\n%li", (long)user.shareCount] forState:UIControlStateSelected];
    [_commentButton setTitle:[NSString stringWithFormat:@"评论\n%li", (long)user.reviewCount] forState:UIControlStateSelected];
    [_favouriteButton setTitle:[NSString stringWithFormat:@"收藏\n%li", (long)user.favouriteCount] forState:UIControlStateSelected];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == 4)
    {
        return 155.0f;
    }
    else if(_type == 2)
    {
        Share *share = [_shareArray objectAtIndex:indexPath.row];
        if(share.poi)
        {
            return 155.0f;
        }
        else if(share.deal)
        {
            return 445.0f;
        }
        else if(share.article)
        {
            return 140.0f;
        }
        else
        {
            return 0;
        }
    }
    return 445.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_type) {
        case 1:
        {
            return [_likeArray count];
        }
            break;
        case 2:
        {
            return [_shareArray count];
        }
            break;
        case 3:
        {
            return [_commentArray count];
        }
            break;
        case 4:
        {
            return [_favouriteArray count];
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_type) {
        case 1:
        {
            DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerDynamicIdentifier"];
            if(cell == nil)
            {
                cell = [[[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerDynamicIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.deal = [_likeArray objectAtIndex:indexPath.row];
            
            return cell;
        }
            break;
        case 2:
        {
            Share *share = [_shareArray objectAtIndex:indexPath.row];
            
            if(share.poi)
            {
                NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerNearbyIdentifier"];
                if(cell == nil)
                {
                    cell = [[[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerNearbyIdentifier"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.poi = share.poi;
                
                return cell;
            }
            else if(share.deal)
            {
                DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerDynamicIdentifier"];
                if(cell == nil)
                {
                    cell = [[[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerDynamicIdentifier"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.deal = share.deal;
                
                return cell;
            }
            else if(share.article)
            {
                HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerArticleIdentifier"];
                if(cell == nil)
                {
                    cell = [[[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerArticleIdentifier"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.article = share.article;
                
                return cell;
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerIdentifier"];
                if(cell == nil)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerIdentifier"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                return cell;
            }
        }
            break;
        case 3:
        {
            DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerDynamicIdentifier"];
            if(cell == nil)
            {
                cell = [[[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerDynamicIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.deal = [_commentArray objectAtIndex:indexPath.row];
            
            return cell;
        }
            break;
        case 4:
        {
            NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerNearbyIdentifier"];
            if(cell == nil)
            {
                cell = [[[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerNearbyIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.poi = [_favouriteArray objectAtIndex:indexPath.row];
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailViewControllerIdentifier"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserDetailViewControllerIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_type) {
        case 1:
        {
            DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
            dealDetailVC.dealId = [[_likeArray objectAtIndex:indexPath.row] dealId];
            [self.navigationController pushViewController:dealDetailVC animated:YES];
        }
            break;
        case 2:
        {
            Share *share = [_shareArray objectAtIndex:indexPath.row];
            if(share.poi)
            {
                ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
                shopVC.poiId = [share.poi poiId];
                [self.navigationController pushViewController:shopVC animated:YES];
            }
            else if(share.deal)
            {
                DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
                dealDetailVC.dealId = [share.deal dealId];
                [self.navigationController pushViewController:dealDetailVC animated:YES];
            }
            else if(share.article)
            {
                ArticleViewController *articleVC = [[[ArticleViewController alloc] init] autorelease];
                articleVC.articleId = [share.article articleId];
                [self.navigationController pushViewController:articleVC animated:YES];
            }
        }
            break;
        case 3:
        {
            DealDetailViewController *dealDetailVC = [[[DealDetailViewController alloc] init] autorelease];
            dealDetailVC.dealId = [[_commentArray objectAtIndex:indexPath.row] dealId];
            [self.navigationController pushViewController:dealDetailVC animated:YES];
        }
            break;
        case 4:
        {
            ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
            shopVC.poiId = [[_favouriteArray objectAtIndex:indexPath.row] poiId];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

@end
