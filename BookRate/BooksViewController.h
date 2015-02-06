//
//  BooksViewController.h
//  BookRate
//
//  Created by Alex Petrinich on 2/4/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

@end

