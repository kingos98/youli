//
//  SubTableCellView.h
//  youli
//
//  Created by sjun on 1/18/13.
//
//

#import <UIKit/UIKit.h>
#import "IZValueSelectorView.h"
#import "ConstellationSelector.h"

@interface SubTableCell : UIView<IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>

@property (nonatomic,strong)IZValueSelectorView *monthView;
@property (nonatomic,strong)IZValueSelectorView *dayView;
@property (nonatomic,strong)IZValueSelectorView *constellationView;
@property (nonatomic,strong)NSString *selectedMonth;
@property (nonatomic,strong)NSString *selectedDay;
@property (nonatomic,strong)NSString *selectedConstellation;
@property (nonatomic,strong)ConstellationSelector *constellationSelector;

@end
