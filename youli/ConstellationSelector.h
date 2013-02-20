//
//  ConstellationSelector.h
//  youli
//
//  Created by sjun on 2/6/13.
//
//

#import <UIKit/UIKit.h>

@interface ConstellationSelector : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *values;
@property(nonatomic,strong)NSString *selectedValue;

- (void)scrollToTheSelectedCell;

@end
