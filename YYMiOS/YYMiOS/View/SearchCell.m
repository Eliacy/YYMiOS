//
//  SearchCell.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-30.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "SearchCell.h"
#import "Function.h"

@implementation SearchCell
{
    UILabel *label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //文字
        label = [Function createLabelWithFrame:CGRectMake(0, 0, 0, 0) FontSize:16 Text:@""];
        [self.contentView addSubview:label];
        //线
        [self.contentView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)]];
        
    }
    return self;
}


@end
