//
//  Book.m
//  BookRate
//
//  Created by Alex Petrinich on 2/5/15.
//  Copyright (c) 2015 Alex Petrinich. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (Book *) bookFromData:(NSDictionary *) data
{
    return [[Book alloc] initWithData:data];
}

- (id) initWithData:(NSDictionary *) data
{
    self = [super init];
    if (self)
    {
        self.author = [data objectForKey:@"author"];
        self.imgPath = [data objectForKey:@"cover_image"];
        self.ID = [[data objectForKey:@"id"] intValue];
        self.title = [data objectForKey:@"title"];
    }
    
    return self;
}

@end
