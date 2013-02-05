//
//  FriendCell.h
//  youli
//
//  Created by sjun on 2/4/13.
//
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;

- (id)initCell:(NSString *)reuseIdentifier;

@end
