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
        
        self.monthView = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(0, 35, 90, 170)];
        self.monthView.dataSource = self;
        self.monthView.delegate = self;
        self.monthView.shouldBeTransparent = YES;
        self.monthView.horizontalScrolling = NO;
        self.monthView.values  = [[NSArray alloc] initWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月",@"",nil];
        [self addSubview:self.monthView];
        
        self.dayView = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(90, 35, 90, 170)];
        self.dayView.dataSource = self;
        self.dayView.delegate = self;
        self.dayView.shouldBeTransparent = YES;
        self.dayView.horizontalScrolling = NO;
        self.dayView.values  = [[NSArray alloc] initWithObjects:@"1日",@"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日",@"",nil];
        [self addSubview:self.dayView];
        
        self.constellationView = [[IZValueSelectorView alloc] initWithFrame:CGRectMake(210, 35, 90, 170)];
        self.constellationView.dataSource = self;
        self.constellationView.delegate = self;
        self.constellationView.shouldBeTransparent = YES;
        self.constellationView.horizontalScrolling = NO;
        self.constellationView.values  = [[NSArray alloc] initWithObjects:@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座",@"",nil];
        //        [self addSubview:self.constellationView];
        
        self.constellationSelector = [[ConstellationSelector alloc] initWithFrame:CGRectMake(210, 35, 90, 170)];
        self.constellationSelector.backgroundColor = [UIColor clearColor];
        self.constellationSelector.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.constellationSelector];
        
    }
    return self;
}

#pragma IZValueSelector dataSource
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 33;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 80.0;
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    return CGRectMake(0.0, self.monthView.frame.size.height/2 - 35.0, 90.0, 70.0);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSString *selectedValue = [valueSelector.values objectAtIndex:index-1];
    if([selectedValue hasSuffix:@"月"]){
        self.selectedMonth = [valueSelector.values objectAtIndex:index-1];
    }
    if([selectedValue hasSuffix:@"日"]){
        self.selectedDay = [valueSelector.values objectAtIndex:index-1];
    }
    if([selectedValue hasSuffix:@"座"]){
        self.selectedConstellation = [valueSelector.values objectAtIndex:index-1];
    }
}

@end
