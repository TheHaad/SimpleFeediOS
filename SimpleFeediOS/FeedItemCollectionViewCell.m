//
//  FeedItemCollectionViewCell.m
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import "FeedItemCollectionViewCell.h"

@interface FeedItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation FeedItemCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = @"";
    self.bodyLabel.text = @"";
    self.authorLabel.text = @"";
}

- (void)updateTitle:(NSString *)title andBody:(NSString *)body andAuthor:(NSString *)author {
    self.titleLabel.text = title;
    self.bodyLabel.text = body;
    self.authorLabel.text = [NSString stringWithFormat:@"Author: %@", author];
}

@end
