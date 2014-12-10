//
//  ViewController.m
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import "FeedViewController.h"
#import "FeedItemCollectionViewCell.h"
#import "APIManager.h"

@interface FeedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, APIManagerDelegate>

@property (nonatomic, strong) NSArray *feedItems;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FeedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - UICollectionView Delegate, DataSource & DelegateFlowLayout Protocols

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 20, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedItemCollectionViewCell *cell = (FeedItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FeedItemCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *item = [self.feedItems objectAtIndex:indexPath.item];
    [cell updateTitle:[item objectForKey:@"title"] andBody:[item objectForKey:@"body"] andAuthor:[item objectForKey:@"author"]];
    
    return cell;
}

#pragma mark - APIManager

- (void)feedItemsDownloaded:(NSArray *)feedItems {
    self.feedItems = [NSArray arrayWithArray:feedItems];
    [self.collectionView reloadData];
}

- (void)addPostStatus:(NSDictionary *)message {
    NSString *alertTitle;
    NSString *alertMessage;
    if ([[message objectForKey:@"status"] intValue] == 200) {
        alertTitle = @"Post Added";
        alertMessage = @"Your post has been sucessfully submitted";
    } else {
        alertTitle = @"Post Failed";
        alertMessage = @"Your post submission could not be added";
    }
    
    UIAlertView *statusAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [statusAlert show];
}

- (void)securityComprimised {
    UIAlertView *statusAlert = [[UIAlertView alloc] initWithTitle:@"Security Compromised" message:@"Can't validate the security of the API" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [statusAlert show];
}

- (void)loadData {
    [APIManager sharedManager].delegate = self;
    [[APIManager sharedManager] loadFeedItems];
}

@end
