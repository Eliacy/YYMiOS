//
//  DynamicCell.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        _backImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backImageView];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        _avatarImageView.backgroundColor = [UIColor brownColor];
        [_backImageView addSubview:_avatarImageView];
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
