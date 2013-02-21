//
//  SubTableCellView.m
//  youli
//
//  Created by sjun on 1/18/13.
//
//

#import "SubTableCellView.h"
#import "IZValueSelectorView.h"
#import "ConstellationUtils.h"

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
        
        self.constellationSelector = [[ConstellationSelector alloc] initWithFrame:CGRectMake(210, 35, 90, 170)];
        self.constellationSelector.backgroundColor = [UIColor clearColor];
        self.constellationSelector.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedMonth = @"1月";
        self.selectedDay = @"1日";
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
    NSRange monthRange = [self.selectedMonth rangeOfString:@"月"];
    NSRange dayRange = [self.selectedDay rangeOfString:@"日"];
    NSInteger month = [[self.selectedMonth substringToIndex:monthRange.location] integerValue];
    NSInteger day = [[self.selectedDay substringToIndex:dayRange.location] integerValue];
    self.constellationSelector.selectedValue = [ConstellationUtils getAstroWithMonth:month andDay:day];
    self.selectedConstellation = self.constellationSelector.selectedValue;
    [self.constellationSelector scrollToTheSelectedCell];    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat currentOffset = contentOffset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = contentSize.height;
    if(currentOffset==maximumOffset)
    {
        
    }
}

@end
