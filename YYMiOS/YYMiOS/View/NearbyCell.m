//
//  NearbyCell.m
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NearbyCell.h"

@implementation NearbyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
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
