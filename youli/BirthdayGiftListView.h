//
//  BirthdayGiftListView.h
//  youli
//
//  Created by ufida on 12-12-7.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface BirthdayGiftListView : BaseController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)NSMutableArray *items;

@end
