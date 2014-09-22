//
//  HomeCell.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 130)];
        _backImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_backImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_backImageView.frame.size.width - 140) / 2, (_backImageView.frame.size.height - 30) / 2, 140, 30)];
        _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"美国最佳海淘圣地";
        [_backImageView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _backImageView.frame.size.height - 20, _backImageView.frame.size.width - 10, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.text = @"2014.08.31";
        [_backImageView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
