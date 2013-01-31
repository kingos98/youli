//
//  IZValueSelectorView.m
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import "IZValueSelectorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation IZValueSelectorView {
    UITableView *contentTableView;
    CGRect selectionRect;
}

@synthesize shouldBeTransparent = _shouldBeTransparent;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if (contentTableView == nil) {
        [self createContentTableView];
    }
    [super layoutSubviews];
}

- (void)createContentTableView {
    UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectorRect"]];
    selectionRect = [self.dataSource rectForSelectionInSelector:self];
    selectionImageView.frame = selectionRect;
    if (self.shouldBeTransparent) {
        selectionImageView.alpha = 0.7;
    }    
    if (self.horizontalScrolling) {
        //In this case user might have created a view larger than taller
        contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.width)];        
    }
    else {
        contentTableView = [[UITableView alloc] initWithFrame:self.bounds];
    }    
    if (self.debugEnabled) {
        contentTableView.layer.borderColor = [UIColor blueColor].CGColor;
        contentTableView.layer.borderWidth = 1.0;
        contentTableView.layer.cornerRadius = 10.0;
        contentTableView.tableHeaderView.layer.borderColor = [UIColor blackColor].CGColor;
        contentTableView.tableFooterView.layer.borderColor = [UIColor blackColor].CGColor;
    }    
    // Initialization code
    CGFloat OffsetCreated;    
    //If this is an horizontal scrolling we have to rotate the table view
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
        contentTableView.transform = rotateTable;        
        OffsetCreated = contentTableView.frame.origin.x;
        contentTableView.frame = self.bounds;
    }
    contentTableView.backgroundColor = [UIColor clearColor];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;    
    if (self.horizontalScrolling) {
        contentTableView.rowHeight = [self.dataSource rowWidthInSelector:self];
    }
    else {
        contentTableView.rowHeight = [self.dataSource rowHeightInSelector:self];
    }    
    if (self.horizontalScrolling) {
        contentTableView.contentInset = UIEdgeInsetsMake( selectionRect.origin.x ,  0,contentTableView.frame.size.height - selectionRect.origin.x - selectionRect.size.width - 2*OffsetCreated, 0);
    }
    else {
        contentTableView.contentInset = UIEdgeInsetsMake( selectionRect.origin.y, 0, contentTableView.frame.size.height - selectionRect.origin.y - selectionRect.size.height  , 0);
    }
    contentTableView.showsVerticalScrollIndicator = NO;
    contentTableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentTableView];
    [self addSubview:selectionImageView];    
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.dataSource numberOfRowsInSelector:self];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    NSArray *contentSubviews = [cell.contentView subviews];
    //We the content view already has a subview we just replace it, no need to add it again
    //hopefully ARC will do the rest and release the old retained view
    if ([contentSubviews count] >0 ) {
        UIView *contentSubV = [contentSubviews objectAtIndex:0];
        //This will release the previous contentSubV
        [contentSubV removeFromSuperview];        
        UIView *viewToAdd = [self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        contentSubV = viewToAdd;
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:contentSubV];
    }
    else {        
        UILabel *viewToAdd = (UILabel *)[self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        //This is a new cell so we just have to add the view        
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:viewToAdd];
    }
    if (self.debugEnabled) {
        cell.layer.borderColor = [UIColor greenColor].CGColor;
        cell.layer.borderWidth = 1.0;
    }    
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = rotateTable;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == contentTableView) {
        [contentTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:indexPath.row];
    }
}

#pragma mark Scroll view methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell {    
    CGRect selectionRectConverted = [self convertRect:selectionRect toView:contentTableView];        
    NSArray *indexPathArray = [contentTableView indexPathsForRowsInRect:selectionRectConverted];    
    CGFloat intersectionHeight = 0.0;
    NSIndexPath *selectedIndexPath = nil;    
    for (NSIndexPath *index in indexPathArray) {
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [contentTableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    if (selectedIndexPath!=nil) {
        //As soon as we elected an indexpath we just have to scroll to it
        [contentTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath.row];
    }
}

- (void)reloadData {
    [contentTableView reloadData];
}

@end
