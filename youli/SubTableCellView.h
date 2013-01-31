//
//  SubTableCellView.h
//  youli
//
//  Created by sjun on 1/18/13.
//
//

#import <UIKit/UIKit.h>
#import "IZValueSelectorView.h"

@interface SubTableCellView : UIView<IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>

@property (nonatomic,strong)IZValueSelectorView *monthView;
@property (nonatomic,strong)IZValueSelectorView *dayView;
@property (nonatomic,strong)IZValueSelectorView *constellationView;

@end
