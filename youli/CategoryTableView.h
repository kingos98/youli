//
//  CategoryTableView.h
//  youli
//
//  Created by apple on 11/27/12.
//
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoryTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) Category *category;
@property(nonatomic,strong)UIImageView *imgSetting;
@end

