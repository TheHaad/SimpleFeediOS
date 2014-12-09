//
//  APIManager.h
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import <Foundation/Foundation.h>

@protocol APIManagerDelegate <NSObject>
    - (void)feedItemsDownloaded:(NSArray *)feedItems;
@end

@interface APIManager : NSObject

@property (nonatomic, weak) id <APIManagerDelegate> delegate;
+ (APIManager *)sharedManager;
- (void)loadFeedItems;

@end
