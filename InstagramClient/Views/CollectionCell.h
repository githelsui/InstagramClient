//
//  CollectionCell.h
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *preView;
@property (nonatomic, strong) Post *post;
- (void)setCell;
@end

NS_ASSUME_NONNULL_END
