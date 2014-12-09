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

- (void)addNewPost:(NSString *)title withBody:(NSString *)body {
    
    NSString *requestString = @"https://www.corellianengineering.pw/newPost";
    NSURL* requestUrl = [NSURL URLWithString:requestString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    NSString *postBodyValues = [NSString stringWithFormat:@"email=testuserone@gmail.com&pwd=password12345&title=%@&body=%@",title, body];
    [request setHTTPBody:[postBodyValues dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

/* FM - Found Certificate Pinning examples on the following sites:
 https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning
 http://www.wireharbor.com/ssl-pinning-in-ios-devices/
 
 Required: Depending on the certificate used for the website, I needed to convert the
 certificate to .der format with the following command in terminal:
 openssl x509 -in mycertfile.pem -outform der -out cert.der
 
 */

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:
(NSURLProtectionSpace*)space
{
    return [[space authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:
(NSURLAuthenticationChallenge *)challenge
{
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust])
    {
        do
        {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            if(nil == serverTrust)
                break; /* failed */
            
            OSStatus status = SecTrustEvaluate(serverTrust, NULL);
            if(!(errSecSuccess == status))
                break; /* failed */
            
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            if(nil == serverCertificate)
                break; /* failed */
            
            CFDataRef serverCertificateData = SecCertificateCopyData(serverCertificate);
            if(nil == serverCertificateData)
                break; /* failed */
            
            NSData *cert1 = CFBridgingRelease(SecCertificateCopyData(serverCertificate));
            
            NSString *file = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
            NSData* cert2 = [NSData dataWithContentsOfFile:file];
            
            if(nil == cert1 || nil == cert2)
                break; /* failed */
            
            const BOOL equal = [cert1 isEqualToData:cert2];
            if(!equal)
                break; /* failed */
            
            // The only good exit point
            return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]
                          forAuthenticationChallenge: challenge];
        } while(0);
        
        // Bad dog
        return [[challenge sender] cancelAuthenticationChallenge: challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error = nil;
    if ([connection.currentRequest.URL.description isEqualToString:@"https://www.corellianengineering.pw/allPosts"]) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if(!error) {
            if (self.delegate) {
                [self.delegate feedItemsDownloaded:jsonArray];
            }
        }
    } else if ([connection.currentRequest.URL.description isEqualToString:@"https://www.corellianengineering.pw/newPost"]) {
           NSDictionary *jsonMessageDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if(!error) {
            if (self.delegate) {
                [self.delegate addPostStatus:jsonMessageDictionary];
            }
        }
    }

}

@end
