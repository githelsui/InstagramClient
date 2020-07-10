//
//  CollectionCell.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//
#import <Parse/Parse.h>
#import "CollectionCell.h"
#import "Post.h"

@implementation CollectionCell

- (void)setCell{
    [self.post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.preView.image = image;
        }else{
            NSLog(@"Print error!!! %@", error.localizedDescription);
        }
    }];
}

@end
