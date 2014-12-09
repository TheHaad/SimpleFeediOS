//
//  FeedItemCollectionViewCell.h
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import <UIKit/UIKit.h>

@interface FeedItemCollectionViewCell : UICollectionViewCell

- (void)updateTitle:(NSString *)title andBody:(NSString *)body andAuthor:(NSString *)author;

@end
