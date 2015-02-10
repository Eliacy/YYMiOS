
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

#import "RATableViewCell.h"
#import "Constant.h"
#import "Function.h"

@interface RATableViewCell ()

@end

@implementation RATableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //主标题
        self.customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        self.customTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.customTitleLabel];
        
        //副标题
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.textAlignment = NSTextAlignmentRight;
        self.subtitleLabel.text = @"全部";
        self.subtitleLabel.textColor = GColor(188, 188, 188);
        [self.contentView addSubview:self.subtitleLabel];
        
        //分割线
        [self.contentView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 1)]];
        
    }
    return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
}

- (void)prepareForReuse
{
  [super prepareForReuse];
}

#pragma mark - 设置cell样式
- (void)setupWithTitle:(NSString *)title level:(NSInteger)level
     selectedAreaArray:(NSArray *)selectedAreaArray selectedCategoryArray:(NSArray *)selectedCategoryArray selectedOrderArray:(NSArray *)selectedOrderArray
{
    //文字颜色
    UIColor *titleColor = [UIColor blackColor];
    
    //背景色
    if (level == 0) {
        titleColor = GColor(188, 188, 188);
        self.backgroundColor = GColor(136, 136, 136);
        //设置副标题
        self.subtitleLabel.hidden = NO;
        if([title isEqualToString:@"范围"]){
            if(selectedAreaArray.count>0){
                self.subtitleLabel.text = [[selectedAreaArray objectAtIndex:0] name];
            }else{
                self.subtitleLabel.text = @"全部";
            }
        }
        if([title isEqualToString:@"分类"]){
            if(selectedCategoryArray.count>0){
                self.subtitleLabel.text = [[selectedCategoryArray objectAtIndex:0] name];
            }else{
                self.subtitleLabel.text = @"全部";
            }
        }
        if([title isEqualToString:@"排序"]){
            if(selectedOrderArray.count>0){
                self.subtitleLabel.text = [[selectedOrderArray objectAtIndex:0] name];
            }else{
                self.subtitleLabel.text = @"全部";
            }
        }
    } else if (level == 1) {
        self.subtitleLabel.hidden = YES;
        self.backgroundColor = GColor(255, 255, 255);
    } else if (level >= 2) {
        self.subtitleLabel.hidden = YES;
        self.backgroundColor = GColor(248, 248, 248);
    }
    
    //处理次级标题选中变红
    if(level!=0){
        if(selectedAreaArray.count>0){
            if([title isEqualToString:[[selectedAreaArray objectAtIndex:0] name]]){
                titleColor = [UIColor redColor];
            }
        }
        if(selectedCategoryArray.count>0){
            if([title isEqualToString:[[selectedCategoryArray objectAtIndex:0] name]]){
                titleColor = [UIColor redColor];
            }
        }
        if(selectedOrderArray.count>0){
            if([title isEqualToString:[[selectedOrderArray objectAtIndex:0] name]]){
                titleColor = [UIColor redColor];
            }
        }
    }
    
    //主标题
    self.customTitleLabel.text = title;
    self.customTitleLabel.textColor = titleColor;
    
    CGFloat left = 11 + 20 * level;
    CGRect titleFrame = self.customTitleLabel.frame;
    titleFrame.origin.x = left;
    self.customTitleLabel.frame = titleFrame;
  
}
@end
