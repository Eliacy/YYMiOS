//
//  DraftCell.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DraftCell.h"

@implementation DraftCell

@synthesize deal = _deal;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        _avatarImageView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_avatarImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 320 - _avatarImageView.frame.size.width - 10 * 3, 25)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, _titleLabel.frame.size.width, 70 - _titleLabel.frame.size.height - 5)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeal:(Deal *)deal
{
    if(_deal != nil)
    {
        LP_SAFE_RELEASE(_deal);
    }
    _deal = [deal retain];
    
    _titleLabel.text = deal.site.siteName;
    _contentLabel.text = deal.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
