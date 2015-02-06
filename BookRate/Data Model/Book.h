//
//  Book.h
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic) int ID;
@property (nonatomic, strong) NSString *title;

+ (Book *) bookFromData:(NSDictionary *) data;

- (id) initWithData:(NSDictionary *) data;

@end
