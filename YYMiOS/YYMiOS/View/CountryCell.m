//
//  CountryCell.m
//  YYMiOS
//
//  Created by 关旭 on 15-2-12.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "CountryCell.h"
#import "Constant.h"
#import "Function.h"

@implementation CountryCell
{
    UILabel *cityLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //文字
        cityLabel = [Function createLabelWithFrame:CGRectMake(40, 0, 210, 45) FontSize:16 Text:@""];
        [self.contentView addSubview:cityLabel];
        //线
        [self.contentView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)]];
        
    }
    return self;
}

#pragma mark - 布局
- (void)layoutCellWithCity:(City *)city SelectedCityName:(NSString *)selectedCityName
{
    //变色
    if([selectedCityName isEqualToString:city.cityName]){
        cityLabel.textColor = GColor(241, 168, 199);
    }else{
        cityLabel.textColor = [UIColor blackColor];
    }
    
    cityLabel.text = city.cityName;
}

@end
