//
//  SRSpecificationsCell.h
//  SRCustomTableViews
//
//  Created by sailon ransom on 8/22/12.
//  Copyright (c) 2012 sailon ransom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Birthday.h"

@interface BirthdayCell : UITableViewCell

@property(nonatomic,strong) Birthday *birthday;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UILabel *countDownLabel;
@property(nonatomic,strong) UILabel *typeLabel;

- (id)initCell:(NSString *)reuseIdentifier;

@end
