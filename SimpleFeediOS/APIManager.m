//
//  APIManager.m
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import "APIManager.h"

@interface APIManager()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end

@implementation APIManager

+ (id)sharedManager {
    static APIManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)loadFeedItems {
    
    NSString *requestString = @"https://www.corellianengineering.pw/allPosts";
    NSURL* requestUrl = [NSURL URLWithString:requestString];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0f];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(!error) {
        if (self.delegate) {
            [self.delegate feedItemsDownloaded:jsonArray];
        }
    }
}

@end
