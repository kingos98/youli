//
//  BirthdayCellNew.m
//  youli
//
//  Created by ufida on 13-2-27.
//
//

#import "BirthdayCellNew.h"

@implementation BirthdayCellNew
{
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

    }
    return self;
}

- (void)setBirthday:(Birthday *)birthday {
    if(birthday!=nil)
    {
        [self addCellBg:birthday];
        [self addPhoto];
        [self addNameLabel:birthday];
        [self addDateLabel:birthday];
        [self addCountDownLabel:birthday];
        [self addTypeLabel:birthday];
    }
}

- (void)addPhoto{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14,8,50,50)];
    [imageView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    [self.contentView addSubview:imageView];
}

-(void)addCellBg:(Birthday *)birthday{
    UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(8, 3, 304, 60)];
    if([birthday.countDown intValue]<=7)
    {
        imgBg.image = [UIImage imageNamed:@"BirthdayCellBg1.png"];
    }
    else if([birthday.countDown intValue]<=14)
    {
        imgBg.image = [UIImage imageNamed:@"BirthdayCellBg2.png"];
    }
    else
    {
        imgBg.image = [UIImage imageNamed:@"BirthdayCellBg3.png"];
    }
    [self.contentView addSubview:imgBg];
    
    if([birthday.countDown intValue]==0)
    {
        UIImageView *imgToday=[[UIImageView alloc]initWithFrame:CGRectMake(231, 3, 80, 59)];
        imgToday.image = [UIImage imageNamed:@"today.png"];
        [self.contentView addSubview:imgToday];
    }
}

- (void)addNameLabel:(Birthday*)birthday{
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 17, 90, 15)];
    nameLabel.text = birthday.name;
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    nameLabel.textColor = [UIColor colorWithRed:0.31 green:0.30 blue:0.30 alpha:1];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:nameLabel];
}

- (void)addDateLabel:(Birthday*)birthday{
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, 150, 15)];
    dateLabel.text =birthday.date;
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    dateLabel.textColor = [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
    dateLabel.textAlignment = UITextAlignmentLeft;
    dateLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:dateLabel];
}

- (void)addCountDownLabel:(Birthday*)birthday{
    
    if([birthday.countDown intValue]>0)
    {
        countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(252, 28, 40, 25)];
        countDownLabel.text = birthday.countDown;
        countDownLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
        countDownLabel.textColor = [UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1];
        countDownLabel.textAlignment = UITextAlignmentCenter;
        countDownLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:countDownLabel];
    }
}

- (void)addTypeLabel:(Birthday*)birthday{
    
    if([birthday.countDown intValue]>0)
    {
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, -2, 100, 25)];
        typeLabel.text = birthday.type;
        typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        typeLabel.textColor = [UIColor whiteColor];
        typeLabel.textAlignment = UITextAlignmentLeft;
        typeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:typeLabel];
    }
}

@end
