//
//  UserListCell.m
//  YYMiOS
//
//  Created by Lide on 14/12/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "UserListCell.h"

@implementation UserListCell

@synthesize user = _user;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = 30.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, self.contentView.frame.size.width - 20 * 2 - 10 - _avatarImageView.frame.size.width, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_nameLabel];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, _nameLabel.frame.origin.y + (_nameLabel.frame.size.height - 15) / 2, 24, 15)];
        _levelLabel.backgroundColor = [UIColor colorWithRed:197.0 / 255.0 green:197.0 / 255.0 blue:197.0 / 255.0 alpha:1.0];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.font = [UIFont systemFontOfSize:10.0f];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.layer.cornerRadius = 2.0;
        _levelLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_levelLabel];
        
        _followingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _followingButton.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, 60, 20);
        _followingButton.backgroundColor = [UIColor clearColor];
        [_followingButton setTitleColor:[UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _followingButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _followingButton.layer.borderWidth = 0.5;
        _followingButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
//        [_followingButton addTarget:self action:@selector(clickFollowingButton:) forControlEvents:UIControlEventTouchUpInside];
        _followingButton.layer.cornerRadius = 2.0;
        _followingButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_followingButton];
        
        _followerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _followerButton.frame = CGRectMake(_followingButton.frame.origin.x + _followingButton.frame.size.width + 5, _followingButton.frame.origin.y, 60, 20);
        _followerButton.backgroundColor = [UIColor clearColor];
        [_followerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _followerButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        _followerButton.layer.borderWidth = 0.5;
        _followerButton.layer.borderColor = [[UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0] CGColor];
//        [_followerButton addTarget:self action:@selector(clickFollowerButton:) forControlEvents:UIControlEventTouchUpInside];
        _followerButton.layer.cornerRadius = 2.0;
        _followerButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_followerButton];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
