//
//  FeedbackViewController.h
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface FeedbackViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *tfName;
@property (nonatomic, weak) IBOutlet UITextView  *tvComment;

@property (nonatomic, weak) Book *book;

- (IBAction) sendTo:(id)sender;

@end
