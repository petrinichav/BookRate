//
//  BookTableViewCell.m
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import "BookTableViewCell.h"
#import "Book.h"
#import "DispatchTools.h"
#import "DataSource.h"

@implementation BookTableViewCell

+ (BookTableViewCell *) loadCell
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:self options:NULL];
    BookTableViewCell *cell = [objects objectAtIndex:0];
    return cell;
}

+ (NSString *) indentifier
{
    return @"BookCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBook:(Book *) book
{
    self.lblAuthor.text = book.author;
    self.lblTitle.text = book.title;
    
    self.coverImage.image = nil;
    if ([book.imgPath length] != 0)
    {
        [self.indicator startAnimating];
        
        __block UIImage *image = nil;
        __weak BookTableViewCell *weak_self = self;
        DispatchTask *task = [DispatchTask taskWithExecuteBlock:^(DispatchTask *newTask) {
            image = [[DataSource source] cashedImageWithoutRequestForURL:[NSURL URLWithString:book.imgPath]];
        } andCompletitionBlock:^(DispatchTask *item)
                              {
                                  weak_self.coverImage.image = image;
                                  [weak_self.indicator stopAnimating];
                              }];
        [[DispatchTools Instance] addTask:task];
    }
   
}

@end
