//
//  MineCell.m
//  YYMiOS
//
//  Created by 关 旭 on 15-1-25.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "MineCell.h"
#import "Function.h"

@implementation MineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //箭头
        [self.contentView addSubview:[Function createArrowImageViewWithPoint:CGPointMake(self.frame.size.width-23, (45-12)/2)]];
        //线
        [self.contentView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)]];
        
    }
    return self;
}

@end
