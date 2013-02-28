//
//  SRSpecificationsCell.m
//  SRCustomTableViews
//
//  Created by sailon ransom on 8/22/12.
//  Copyright (c) 2012 sailon ransom. All rights reserved.
//

#import "BirthdayCell.h"
#import "Birthday.h"

@interface BirthdayCell ()

@end

@implementation BirthdayCell{
@private
    __strong Birthday *_birthday;
}

@synthesize birthday = _birthday;
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize countDownLabel;
@synthesize typeLabel;

- (id)initCell:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addPhoto];
    }
    return self;
}

- (void)setBirthday:(Birthday *)birthday {
    if(birthday!=nil)
    {
        [self addNameLabel:birthday];
        [self addDateLabel:birthday];
        [self addCountDownLabel:birthday];
        [self addTypeLabel:birthday];
    }
}

- (void)addPhoto{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14,17,50,50)];
    [imageView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    [self.contentView addSubview:imageView];
}

- (void)addNameLabel:(Birthday*)birthday{
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 26, 90, 15)];
    nameLabel.text = birthday.name;
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    nameLabel.textColor = [UIColor colorWithRed:0.31 green:0.30 blue:0.30 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:nameLabel];
}

- (void)addDateLabel:(Birthday*)birthday{
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 46, 150, 15)];
    dateLabel.text =birthday.date;
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    dateLabel.textColor = [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
    dateLabel.textAlignment = UITextAlignmentLeft;
    dateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:dateLabel];
}

- (void)addCountDownLabel:(Birthday*)birthday{
    countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(252, 41, 40, 25)];
    countDownLabel.text = birthday.countDown;
    countDownLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
    countDownLabel.textColor = [UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1];
    countDownLabel.textAlignment = UITextAlignmentCenter;
    countDownLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:countDownLabel];
}

- (void)addTypeLabel:(Birthday*)birthday{
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 8, 100, 25)];
    typeLabel.text = birthday.type;
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = UITextAlignmentLeft;
    typeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:typeLabel];
}

@end
