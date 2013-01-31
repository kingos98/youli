//
//  SubTableCellView.m
//  youli
//
//  Created by sjun on 1/18/13.
//
//

#import "SubTableCellView.h"
#import "IZValueSelectorView.h"

@implementation SubTableCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,200)];
        [mainBgView setImage:[UIImage imageNamed:@"sub_cell_bg.png"]];
        [self addSubview:mainBgView];
        
        self.monthView = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
        self.monthView.dataSource = self;
        self.monthView.delegate = self;
        self.monthView.shouldBeTransparent = YES;
        self.monthView.horizontalScrolling = NO;
        [self addSubview:self.monthView];
        
    }
    return self;
}

#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return 12;
}

//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}

- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = nil;
    label.text = [NSString stringWithFormat:@"%d",index];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0.0, self.monthView.frame.size.height/2 - 35.0, 90.0, 70.0);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
