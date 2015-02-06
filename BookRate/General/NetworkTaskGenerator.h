//
//  NetworkTaskGenerator.h
//  iPhoneGraduateApp
//
//    on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispatchTools.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"

@interface NetworkTaskGenerator : DispatchTask
{
    SBJsonWriter         *jsonWriter;
    SBJsonParser         *jsonParser;
    NSURL                *_url;
    NSURLConnection      *_connection;
    
    NSMutableString      *_data;//if bad data
}

@property BOOL           isSuccessful;
@property (readonly)     id _data;
@property NSInteger      statusCode;
@property (strong)       NSError *internetError;

+ (NetworkTaskGenerator *) booksTaskWithCompleteBlock:(DispatchBlock) completeBlock;
+ (NetworkTaskGenerator *) postCommentForBookID:(int) ID name:(NSString *) name comment:(NSString *) comment taskWithCompleteBlock:(DispatchBlock) completeBlock;

- (id) initWithURL:(NSURL *)url params:(NSMutableDictionary *)parametrs executeBlock:(DispatchBlock)_executeBlock andCompletitionBlock:(DispatchBlock)_completeBlock;

- (id) objectFromString;

- (BOOL) isInternetConnecting;
- (void) generateRequest;
- (void) generateRequestForUploadPhoto:(NSData *)imgData;

@end
