//
//  SettingCell.m
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

@synthesize titleLabel = _titleLabel;
@synthesize switchButton = _switchButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 290, 24)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_titleLabel];
        
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
        _switchButton.frame = CGRectMake(320 - 15 - _switchButton.frame.size.width, (44 - _switchButton.frame.size.height) / 2, _switchButton.frame.size.width, _switchButton.frame.size.height);
        [self.contentView addSubview:_switchButton];
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
