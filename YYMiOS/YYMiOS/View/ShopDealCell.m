//
//  CommentCell.m
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopDealCell.h"
#import "LPImage.h"

@implementation ShopDealCell

@synthesize deal = _deal;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + 15, _imageView.frame.origin.y, 320 - _imageView.frame.size.width - 15 * 3, 50)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, _imageView.frame.origin.y + _imageView.frame.size.height - 20, _contentLabel.frame.size.width, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_nameLabel];
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
    
    if(deal.imageArray && [deal.imageArray count] > 0)
    {
        _imageView.hidden = NO;
        [_imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[deal.imageArray objectAtIndex:0] imageURL] imageSize:CGSizeMake(100, 100)]]];
    }
    else
    {
        _imageView.hidden = YES;
    }
    
    _contentLabel.text = deal.content;
    _nameLabel.text = deal.user.userName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
