//
//  HomeCell.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

@synthesize article = _article;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 130)];
        _backImageView.backgroundColor = [UIColor clearColor];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_backImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_backImageView.frame.size.width - 140) / 2, (_backImageView.frame.size.height - 30) / 2, 140, 30)];
        _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backImageView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _backImageView.frame.size.height - 20, _backImageView.frame.size.width - 10, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [_backImageView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setArticle:(Article *)article
{
    if(_article != nil)
    {
        LP_SAFE_RELEASE(_article);
    }
    _article = [article retain];
    
    if(article.caption.imageURL && ![article.caption.imageURL isEqualToString:@""])
    {
        [_backImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:article.caption.imageURL imageSize:CGSizeMake(620, 260)]]];
    }
    else
    {
        _backImageView.image = nil;
    }
    
    CGSize titleSize = [LPUtility getTextHeightWithText:article.title
                                                   font:_titleLabel.font
                                                   size:CGSizeMake(2000, 100)];
    _titleLabel.frame = CGRectMake((_backImageView.frame.size.width - titleSize.width - 20) / 2, (_backImageView.frame.size.height - 30) / 2, titleSize.width + 20, 30);
    _titleLabel.text = article.title;
    
    _timeLabel.text = article.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
