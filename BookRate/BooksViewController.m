//
//  BooksViewController.m
//  BookRate
//
//  Created by Alex Petrinich on 2/4/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import "BooksViewController.h"
#import "FeedbackViewController.h"
#import "NetworkTaskGenerator.h"
#import "BookTableViewCell.h"
#import "Book.h"

@interface BooksViewController ()

@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic) int selectedIndex;

@end

@implementation BooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.books = [NSMutableArray array];
    
    NetworkTaskGenerator *booksTask = [NetworkTaskGenerator booksTaskWithCompleteBlock:^(DispatchTask *item) {
        NetworkTaskGenerator *responseTask = (NetworkTaskGenerator *) item;
        if (responseTask.isSuccessful)
        {
            NSArray *books = [responseTask objectFromString];
            for (NSDictionary *bookData in books)
            {
                Book *book = [Book bookFromData:bookData];
                [self.books addObject:book];
            }
            [self.table reloadData];
            dbgLog(@"BOOKS - %@", books);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No completed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
    }];
    [[DispatchTools Instance] addTask:booksTask];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BookFeedback"]) {
        FeedbackViewController *vc = segue.destinationViewController;
        vc.book = [self.books objectAtIndex:self.selectedIndex];
    }
}

#pragma mark - Table

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = [BookTableViewCell indentifier];
    BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell)
    {
        cell = [BookTableViewCell loadCell];
    }
    Book *book = [self.books objectAtIndex:indexPath.row];
    [cell setBook:book];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = (int)indexPath.row;
    [self performSegueWithIdentifier:@"BookFeedback" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
