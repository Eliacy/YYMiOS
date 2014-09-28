//
//  DraftCell.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DraftCell.h"

@implementation DraftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        _avatarImageView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_avatarImageView];
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
