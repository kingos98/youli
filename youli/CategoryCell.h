//
//  CategoryCell.h
//  youli
//
//  Created by apple on 11/21/12.
//
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CategoryCell : UITableViewCell

@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) UIImageView *labelImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *nextImage;

- (id)initCell:(NSString *)reuseIdentifier;

@end
