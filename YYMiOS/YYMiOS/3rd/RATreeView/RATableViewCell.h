
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@interface RATableViewCell : UITableViewCell

/**
 *  主标题
 */
@property (strong, nonatomic) UILabel *customTitleLabel;

/**
 *  副标题
 */
@property (strong, nonatomic) UILabel *subtitleLabel;

/**
 *  设置cell内容
 *
 *  @param title                    文本
 *  @param level                    层级
 *  @param selectedAreaArray        范围选择情况
 *  @param selectedCategoryArray    分类选择情况
 *  @param selectedOrderArray       排序选择情况
 */
- (void)setupWithTitle:(NSString *)title level:(NSInteger)level
    selectedAreaArray:(NSArray *)selectedAreaArray selectedCategoryArray:(NSArray *)selectedCategoryArray selectedOrderArray:(NSArray *)selectedOrderArray;

@end
