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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 320 - _avatarImageView.frame.size.width - 10 * 3, 25)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.text = @"爱马仕第五大道店";
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, _titleLabel.frame.size.width, 70 - _titleLabel.frame.size.height - 5)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"游戏系统方面，本作采用了360度完全自由的视角设定。战术连接系统虽然跟传统的指令战斗差不多，但是其中一个要素就是有距离的概念，玩家需要逐渐缩短与敌人间的距离。此外角色都拥有战术导力器，并且可以相互配合行动，角色行动时要考虑如何才能使角色间更好的配合。而动态语音系统是指不仅在剧情事件和战斗中，玩家走在路上也会听到角色的对话，非常具有真实感。羁绊事件有明显的进化。";
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
