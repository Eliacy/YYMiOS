//
//  CommentCell.m
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopDealCell.h"

@implementation ShopDealCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
        _imageView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_imageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + 15, _imageView.frame.origin.y, 320 - _imageView.frame.size.width - 15 * 3, 50)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"适合我的风格，比在国内买要便宜多了。最关键的是此款是米国限量款，真的好便宜啊，在国内买真心不合适，而且还容易碰到假货。";
        [self.contentView addSubview:_contentLabel];
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
