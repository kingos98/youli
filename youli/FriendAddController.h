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
#import "Friend.h"

@protocol AddFriendDelegate <NSObject>
-(void)addNewFriend:(Friend *)newFriend;
@end

@interface FriendAddController : BaseController<UITableViewDelegate, UITableViewDataSource,AddFriendDelegate>

@property(strong, nonatomic)NSArray *items;
@property(strong, nonatomic)UIFolderTableView *friendTable;
@property(strong, nonatomic)UIFolderTableView *folderTableView;
@property(strong, nonatomic)SubTableCell *subTableCellView;

@end
