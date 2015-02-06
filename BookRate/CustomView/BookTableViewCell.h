//
//  BookTableViewCell.h
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface BookTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *coverImage;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblAuthor;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

+ (BookTableViewCell *) loadCell;
+ (NSString *) indentifier;

- (void) setBook:(Book *) book;

@end
