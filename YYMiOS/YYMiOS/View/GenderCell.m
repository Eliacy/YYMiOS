//
//  GenderCell.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-22.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "GenderCell.h"
#import "Constant.h"
#import "Function.h"

@implementation GenderCell
{
    //性别
    UILabel *genderLabel;
    //是否选中
    UIImageView *selectedImageView;
}

#pragma mark - 构建视图
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //统一标准
        int leftX = 15;
        int fontSize = 16;
        
        //标题
        genderLabel = [Function createLabelWithFrame:CGRectMake(leftX, (self.frame.size.height -20)/2, 80, 20) FontSize:fontSize Text:nil];
        genderLabel.textColor = GColor(129, 129, 129);
        [self addSubview:genderLabel];
        
        //是否选中
        selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-22-leftX, (self.frame.size.height-22)/2, 22, 22)];
        selectedImageView.image = [UIImage imageNamed:@"confirm"];
        [self addSubview:selectedImageView];
        
    }
    return self;
}

#pragma mark - 布局
- (void)layoutCellWithRow:(int)row Gender:(NSString *)gender;
{
    genderLabel.text = [genderStrArray objectAtIndex:row];
    
    if([[genderStrArray objectAtIndex:row] isEqualToString:gender]){
        selectedImageView.hidden = NO;
    }else{
        selectedImageView.hidden = YES;
    }
}


@end
