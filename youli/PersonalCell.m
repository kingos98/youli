//
//  PersonalCell.m
//  youli
//
//  Created by ufida on 12-11-5.
//
//

#import "PersonalCell.h"

@implementation PersonalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cellbgView = [[UIView alloc] initWithFrame:self.frame];
        cellbgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_cell_bg.png"]];
        self.backgroundView = cellbgView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addPhoto];
        [self addNameLabel];
        [self addButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)addPhoto{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9,6,24,24)];
    [imageView setImage:[UIImage imageNamed:@"icon.jpeg"]];
    [self.contentView addSubview:imageView];
}

- (void)addNameLabel{
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 11, 150, 15)];
    friendLabel.text = @"天空之城 Fenng";
    friendLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    friendLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    friendLabel.textAlignment = UITextAlignmentLeft;
    friendLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:friendLabel];
}

- (void)addButton{
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nextImage = [[UIImage imageNamed:@"next.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    nextButton.frame = CGRectMake(260,2,26,27);
    [nextButton setBackgroundImage:nextImage forState:UIControlStateNormal];
    [self.contentView addSubview:nextButton];
}

@end
