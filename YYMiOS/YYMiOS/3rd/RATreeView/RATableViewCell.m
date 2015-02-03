
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
        
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        self.customTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.customTitleLabel];
        
        //线
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


- (void)setupWithTitle:(NSString *)title level:(NSInteger)level
{
  self.customTitleLabel.text = title;
  
  if (level == 0) {
    self.detailTextLabel.textColor = GColor(159, 159, 159);
  }
  
  if (level == 0) {
    self.backgroundColor = GColor(136, 136, 136);
  } else if (level == 1) {
    self.backgroundColor = GColor(255, 255, 255);
  } else if (level >= 2) {
    self.backgroundColor = GColor(248, 248, 248);
  }
  
  CGFloat left = 11 + 20 * level;
  
  CGRect titleFrame = self.customTitleLabel.frame;
  titleFrame.origin.x = left;
  self.customTitleLabel.frame = titleFrame;
  
}
@end
