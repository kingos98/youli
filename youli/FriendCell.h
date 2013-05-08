//
//  FriendCell.h
//  youli
//
//  Created by sjun on 2/4/13.
//
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "FriendAddController.h"

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;
@property (nonatomic,strong) Friend *currentFriend;

- (id)initCell:(NSString *)reuseIdentifier delegate:(id<AddFriendDelegate>)_delegate;
@end
