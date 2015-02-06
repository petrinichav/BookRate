//
//  FeedbackViewController.m
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import "FeedbackViewController.h"
#import "NetworkTaskGenerator.h"
#import "Book.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) sendTo:(id)sender
{
    if (![self fieldIsValid] || ![self commentIsValid])
    {
        return;
    }
    
    NetworkTaskGenerator *task = [NetworkTaskGenerator postCommentForBookID:self.book.ID
                                                                       name:self.tfName.text
                                                                    comment:self.tvComment.text
                                                      taskWithCompleteBlock:^(DispatchTask *item) {
                                                          NetworkTaskGenerator *rTask = (NetworkTaskGenerator *)item;
                                                          if (rTask.isSuccessful)
                                                          {
                                                              NSDictionary *response = [rTask objectFromString];
                                                              dbgLog(@"r = %@", response);
                                                              [self.navigationController popViewControllerAnimated:YES];
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
    [[DispatchTools Instance] addTask:task];
}

- (void) addTapRecognizer
{
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapR];
}

- (void) hideKeyboard:(UITapGestureRecognizer *) tapR
{
    [self.view removeGestureRecognizer:tapR];
    [self.view endEditing:YES];
}

#pragma mark - Validation

- (BOOL) fieldIsValid
{
    return [self.tfName.text length] > 0;
}

- (BOOL) commentIsValid
{
    return [self.tvComment.text length] >= 100;
}

- (void) showValidMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
//                                                     style:UIAlertActionStyleCancel
//                                                   handler:nil];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self fieldIsValid])
    {
        [self showValidMessage:@"Enter your name"];
    }
}

#pragma mark - Text view

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self addTapRecognizer];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![self commentIsValid])
    {
        [self showValidMessage:@"Enter more than 100 symbols in comment field"];
    }
}

@end
