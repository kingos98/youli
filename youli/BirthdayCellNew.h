//
//  BirthdayCellNew.h
//  youli
//
//  Created by ufida on 13-2-27.
//
//

#import <UIKit/UIKit.h>
#import "Birthday.h"

@interface BirthdayCellNew : UITableViewCell

@property(nonatomic,strong) Birthday *birthday;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UILabel *countDownLabel;
@property(nonatomic,strong) UILabel *typeLabel;

- (id)initCell:(NSString *)reuseIdentifier;

@end
