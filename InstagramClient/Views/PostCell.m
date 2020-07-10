//
//  PostCell.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCell{
    self.captionView.text = self.post.caption;
    PFUser *user = self.post.author;
    [user fetchIfNeeded];
    self.usernameLabel.text = user[@"username"];
    self.iconView.layer.cornerRadius = 20;
    [self.post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.postView.image = image;
        }else{
            NSLog(@"Print error!!! %@", error.localizedDescription);
        }
    }];
    [user[@"icon"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.iconView.image = image;
        }
    }];
}

@end
