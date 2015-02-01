//
//  UserInfoCell.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-21.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "UserInfoCell.h"
#import "Constant.h"
#import "Function.h"
#import "User.h"

@implementation UserInfoCell
{
    //标题
    UILabel *titleLabel;
    //头像
    UIImageView *userIconImageView;
    //内容
    UILabel *userInfoLabel;
    //箭头
    UIImageView *arrowImageView;
    
}

#pragma mark - 构建视图
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //统一标准
        int fontSize = 16;
        int leftX = 10;
        int rightX = 35;
        int arrowRithtX = 15;
        //标题
        titleLabel = [Function createLabelWithFrame:CGRectMake(leftX, (self.frame.size.height -20)/2, 80, 20) FontSize:fontSize Text:nil];
        [self addSubview:titleLabel];
        
        //头像
        userIconImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-rightX-60, (80-60)/2, 60, 60)] autorelease];
        userIconImageView.backgroundColor = [UIColor clearColor];
        userIconImageView.layer.cornerRadius = 30.0;
        userIconImageView.layer.masksToBounds = YES;
        userIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:userIconImageView];
        
        //内容
        userInfoLabel = [Function createLabelWithFrame:CGRectMake(self.frame.size.width-rightX-200, (self.frame.size.height-20)/2, 200, 20) FontSize:fontSize Text:nil];
        userInfoLabel.textAlignment = NSTextAlignmentRight;
        userInfoLabel.textColor = GColor(112, 112, 112);
        [self addSubview:userInfoLabel];
        
        //箭头
        arrowImageView = [Function createArrowImageViewWithPoint:CGPointMake(self.frame.size.width-arrowRithtX-8, (45-12)/2)];
        [self addSubview:arrowImageView];
    }
    return self;
}

//标题
#define titleStrArray @[@"头像",@"昵称",@"性别",@"手机号码",@"修改密码"]

#pragma mark - 布局
- (void)layoutCellWithRow:(int)row
{
    //标题
    titleLabel.text = [titleStrArray objectAtIndex:row];
    //控制高度
    int cellHeight;
    if(row==0){
        cellHeight = 80;
    }else{
        cellHeight = 45;
    }
    [titleLabel setFrame:CGRectMake(10, (cellHeight-20)/2, 80, 20)];
    [arrowImageView setFrame:CGRectMake(self.frame.size.width-15-arrowImageView.frame.size.width, (cellHeight-arrowImageView.frame.size.height)/2, arrowImageView.frame.size.width, arrowImageView.frame.size.height)];
    
    //控制手机号cell右对齐
    if(row==3){
        [userInfoLabel setFrame:CGRectMake(self.frame.size.width-15-200, (self.frame.size.height-20)/2, 200, 20)];
    }else{
        [userInfoLabel setFrame:CGRectMake(self.frame.size.width-35-200, (self.frame.size.height-20)/2, 200, 20)];
    }
    
    //控制显示内容
    switch(row){
        case 0:
            //头像
            userIconImageView.hidden = NO;
            [userIconImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[User sharedUser] userIcon].imageURL imageSize:CGSizeMake(120, 120)]]];
            userInfoLabel.hidden = YES;
            arrowImageView.hidden = NO;
            break;
        case 1:
            //昵称
            userIconImageView.hidden = YES;
            userInfoLabel.hidden = NO;
            userInfoLabel.text = [[User sharedUser] userName];
            arrowImageView.hidden = NO;
            break;
        case 2:
            //性别
            userIconImageView.hidden = YES;
            userInfoLabel.hidden = NO;
            userInfoLabel.text = [[User sharedUser] gender];
            arrowImageView.hidden = NO;
            break;
        case 3:
            //手机号码
            userIconImageView.hidden = YES;
            userInfoLabel.hidden = NO;
            userInfoLabel.text = [[User sharedUser] mobile];
            arrowImageView.hidden = YES;
            break;
        case 4:
            //修改密码
            userIconImageView.hidden = YES;
            userInfoLabel.hidden = YES;
            arrowImageView.hidden = NO;
            break;
            
    }
}

@end
