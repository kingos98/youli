//
//  CategoryCell.m
//  youli
//
//  Created by apple on 11/21/12.
//
//

#import "CategoryCell.h"
#import "Category.h"

@implementation CategoryCell{
@private
    __strong Category *_category;
}

@synthesize category = _category;

- (id)initCell:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addPhoto];
        [self addNext];
    }
    return self;
}

- (void)setCategory:(Category *)category {
    [self addNameLabel:category];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)addPhoto{
    self.labelImage = [[UIImageView alloc] initWithFrame:CGRectMake(19,14,19,17)];
    [self.labelImage setImage:[UIImage imageNamed:@"unselected.png"]];
    [self.contentView addSubview:self.labelImage];
}

- (void)addNameLabel:(Category *)category{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 11, 72, 21)];
    self.nameLabel.text = category.name;
    self.nameLabel.tag=category.index;
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.nameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLabel];
}

- (void)addNext{
    self.nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(175,14,10,17)];
    [self.nextImage setImage:[UIImage imageNamed:@"pointerunselect.png"]];
    [self.contentView addSubview:self.nextImage];
}

@end
