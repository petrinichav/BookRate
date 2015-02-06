//
//  NetworkTaskGenerator.m
//  iPhoneGraduateApp
//
//    on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkTaskGenerator.h"
#import "Reachability.h"
#import "LoadingView.h"
#import "AppDelegate.h"

@implementation NetworkTaskGenerator
@synthesize _data;
@synthesize isSuccessful;
@synthesize statusCode;

+ (NetworkTaskGenerator *) initTaskWithcompleteBlock:(DispatchBlock) completeBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@init", SERVER_URL]];
    
    NetworkTaskGenerator *task = [[NetworkTaskGenerator alloc] initWithURL:url params:nil executeBlock:^(DispatchTask *item) {
        if ([(NetworkTaskGenerator *)item isInternetConnecting])
            [(NetworkTaskGenerator *)item  generateRequest];
        else
            [(NetworkTaskGenerator *)item finishNetworkTask];
    } andCompletitionBlock:completeBlock];
    
    return AUTORELEASE(task);
}

+ (NetworkTaskGenerator *) booksTaskWithCompleteBlock:(DispatchBlock) completeBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@books.json", SERVER_URL]];
    
    NetworkTaskGenerator *task = [[NetworkTaskGenerator alloc] initWithURL:url params:nil executeBlock:^(DispatchTask *item) {
        if ([(NetworkTaskGenerator *)item isInternetConnecting])
            [(NetworkTaskGenerator *)item  generateGetRequest];
        else
            [(NetworkTaskGenerator *)item finishNetworkTask];
    } andCompletitionBlock:completeBlock];
    
    return AUTORELEASE(task);
}

+ (NetworkTaskGenerator *) postCommentForBookID:(int) ID name:(NSString *) name comment:(NSString *) comment taskWithCompleteBlock:(DispatchBlock) completeBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@book/:", SERVER_URL]];
    
    NSDictionary *params = @{@"book_id":@(ID), @"name":name, @"comment":comment};
    
    NetworkTaskGenerator *task = [[NetworkTaskGenerator alloc] initWithURL:url params:(NSMutableDictionary *)params executeBlock:^(DispatchTask *item) {
        if ([(NetworkTaskGenerator *)item isInternetConnecting])
            [(NetworkTaskGenerator *)item  generateRequest];
        else
            [(NetworkTaskGenerator *)item finishNetworkTask];
    } andCompletitionBlock:completeBlock];
    
    return AUTORELEASE(task);
}

#pragma mark - Head logic

- (BOOL) isInternetConnecting
{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    BOOL isConnect;
    if (status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        isConnect = YES;
    }
    else
    {
        isConnect = NO;
        isSuccessful = NO;
//        [[AlertModule instance] createAlertWithType:InternetError buttons:1 withCancelBlock:^(UIAlertView *_alert) {
//            
//        } completeBlock:^(UIAlertView *_alert) {
//            
//        }];
//        [[AlertModule instance] showAlert];
    }
    
    return isConnect;
}

- (void) requestIsSuccess
{
    if (self.statusCode == 200)
    {
        isSuccessful = YES;
    }
    else
    {
        isSuccessful = NO;
    }
}

-(void) finishNetworkTask
{
    if(_connection)
    {
        dbgLog(@"%@ finised",[self description]);
        RELEASE(_connection);
        _connection = nil;
    }
    [super finishNetworkTask];
}

- (NSMutableString *) generateRequestBody
{
    NSMutableString *requestBody = [NSMutableString string];
    int counter = 0;
    for (NSString * key in [params allKeys])
    {
        if (counter == [[params allKeys] count]-1)
        {
            [requestBody appendFormat:@"%@=%@", key, [params objectForKey:key]];
        }
        else
        {
            [requestBody appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }
        counter++;
    }

    return requestBody;
}

- (void) generateRequest
{
    dbgLog(@"URL = %@", _url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableString *requestBody = [self generateRequestBody];
    [request setHTTPBody:[requestBody  dataUsingEncoding:NSUTF8StringEncoding]];
    
    dbgLog(@"body = %@ method = %@", requestBody, [request HTTPMethod]);
    dbgLog(@"headers = %@",request.allHTTPHeaderFields);

    
    dbgLog(@"headers = %@",request.allHTTPHeaderFields);
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:(id)self];
    [_connection start];

    RELEASE(request);
}

- (void) generateGetRequest
{
    dbgLog(@"URL = %@", _url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    dbgLog(@"headers = %@",request.allHTTPHeaderFields);
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:(id)self];
    [_connection start];
    
    RELEASE(request);

}

- (id) initWithURL:(NSURL *)url params:(NSMutableDictionary *)parametrs executeBlock:(DispatchBlock)_executeBlock andCompletitionBlock:(DispatchBlock)_completeBlock
{
    self = [super initNetworkTaskWithExecuteBlock:_executeBlock andCompletitionBlock:^(DispatchTask *item) {
        [LoadingView hide];
        _completeBlock(item);
    }];
    if (self)
    {
        [LoadingView showInView:APPDelegate.window];
        
        _url = RETAIN(url);
        [params addEntriesFromDictionary:parametrs];
        isNetwork = YES;
        
        jsonWriter = [[SBJsonWriter alloc] init];
        jsonParser = [[SBJsonParser alloc] init];    
        
        _data      = [[NSMutableString alloc] init];
        
    }
    return self;
}


- (id) objectFromString
{
    return [jsonParser objectWithString:_data];
}

#pragma mark URLConeection Delegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    dbgLog(@"authMethod = %@", challenge.protectionSpace.authenticationMethod);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
                           forAuthenticationChallenge:challenge];
        }
    else 
        {
             [challenge.sender cancelAuthenticationChallenge:challenge];
        }
   
    dbgLog(@"challenge.error = %@ challenge-response = %@", challenge.error, challenge.failureResponse);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(_connection!=connection)
    {
        return;
    }
    isSuccessful = NO;
    dbgLog(@"%@ error = %@",[self description], error);
    self.internetError = error;
    [self finishNetworkTask];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(_connection!=connection)
    {
        return;
    }
    NSString *localiz = [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]];
    dbgLog(@"response = %d local = %@", [(NSHTTPURLResponse*)response statusCode], localiz);
           
    if([(NSHTTPURLResponse*)response statusCode]==200)
    {
        isSuccessful = YES;        
    }else
    {
        isSuccessful = NO;
        self.statusCode = [(NSHTTPURLResponse*)response statusCode];       
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if(_connection!=connection)
    {
        return;
    }
    
    if(self.isCancelled)
    {
        [self finishNetworkTask];
    }else
    {
        
        if (data != nil)
        {
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dbgLog(@"response = %@", response);
            [_data appendString:response];  
            
            RELEASE(response);
        }
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_connection!=connection)
    {
        return;
    }
//    [self requestIsSuccess];
    [self finishNetworkTask];
}


@end
