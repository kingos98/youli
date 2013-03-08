//
//  BirthdayGiftControllerNew.h
//  youli
//
//  Created by ufida on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "YouliDelegate.h"
#import "BaseController.h"
#import "sqlite3.h"
#import "BirthdayGiftDetailController.h"
#import "BirthdayGiftDetailControllerDelegate.h"
#import "CategoryTableView.h"

@interface BirthdayGiftController : BaseController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,YouliDelegate>
@end
