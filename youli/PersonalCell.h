//
//  PersonalCell.h
//  youli
//
//  Created by ufida on 12-11-5.
//
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface PersonalCell : UITableViewCell

@property (nonatomic, strong) Friend *friend;

- (id)initCell:(NSString *)reuseIdentifier;

@end
