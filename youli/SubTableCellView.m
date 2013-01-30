//
//  SubTableCellView.m
//  youli
//
//  Created by sjun on 1/18/13.
//
//

#import "SubTableCellView.h"

@implementation SubTableCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *mainBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,200)];
        [mainBgView setImage:[UIImage imageNamed:@"sub_cell_bg.png"]];
        [self addSubview:mainBgView];
        
        
    }
    return self;
}

@end
