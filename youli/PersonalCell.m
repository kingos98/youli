//
//  PersonalCell.m
//  youli
//
//  Created by ufida on 12-11-5.
//
//

#import "PersonalCell.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"

@implementation PersonalCell{
@private
    __strong Friend *_friend;
}

@synthesize friend = _friend;

- (id)initCell:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cellbgView = [[UIView alloc] initWithFrame:self.frame];
        cellbgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_cell_bg.png"]];
        self.backgroundView = cellbgView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addButton];
    }
    return self;
}

- (void)setFriend:(Friend *)friend {
    [self addPhoto:friend];
    [self addNameLabel:friend];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)addPhoto:(Friend *)friend{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,4,28,28)];
    if (friend) {
        if (friend.profileUrl) {
            NSURL *URL = [NSURL URLWithString:friend.profileUrl];
            [imageView setImageWithURL:URL];
        }
    }
    [self.contentView addSubview:imageView];
}

- (void)addNameLabel:(Friend *)friend{
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 11, 150, 15)];
    friendLabel.text = friend.name;
    friendLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    friendLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    friendLabel.textAlignment = UITextAlignmentLeft;
    friendLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:friendLabel];
}

- (void)addButton{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(263,3,36,36);
    UIImage *addImage = [[UIImage imageNamed:@"next.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [addButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [self.contentView addSubview:addButton];
}

@end
