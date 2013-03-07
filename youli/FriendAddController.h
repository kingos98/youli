//
//  FriendAddController.h
//  youli
//
//  Created by sjun on 1/23/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "UIFolderTableView.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "SubTableCell.h"

@interface FriendAddController : BaseController<UITableViewDelegate, UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate>

@property(strong, nonatomic)NSMutableArray *items;

@property(strong, nonatomic)UIFolderTableView *friendTable;

@property(strong, nonatomic)UIFolderTableView *folderTableView;

@property(strong, nonatomic)SubTableCell *subTableCellView;

+ (void)loadFriend:(void (^)(NSArray *friends, NSError *error))block;

@end
