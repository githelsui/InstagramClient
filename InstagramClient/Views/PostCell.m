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
    self.dateLabel.text = self.post.timeAgo;
    [self updateLikes];
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

-(void)updateLikes{
    UIImage *favIcon;
    if(self.post.likedByUser){
        favIcon = [UIImage imageNamed:@"black-heart.png"];
    } else {
        favIcon = [UIImage imageNamed:@"heart.png"];
    }
    self.likeCount.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    [self.likeButton setImage:favIcon forState:UIControlStateNormal];
}

- (void)likePost{
    self.post.likeCount = @([self.post.likeCount intValue] + [@1 intValue]);
    self.post.likedByUser = YES;
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            UIImage *favIcon =  [UIImage imageNamed:@"black-heart.png"];
            [self.likeButton setImage:favIcon forState:UIControlStateNormal];
            [self updateLikes];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
            if(self.post.likeCount > 0)
                self.post.likeCount = @([self.post.likeCount intValue] - [@1 intValue]);
            self.post.likedByUser = NO;
        }
    }];
}

- (void)unlikePost{
    self.post.likeCount = @([self.post.likeCount intValue] - [@1 intValue]);
    self.post.likedByUser = NO;
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            UIImage *favIcon =  [UIImage imageNamed:@"heart.png"];
            [self.likeButton setImage:favIcon forState:UIControlStateNormal];
            [self updateLikes];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
            self.post.likeCount = @([self.post.likeCount intValue] + [@1 intValue]);
            self.post.likedByUser = YES;
        }
    }];
}

- (IBAction)likeTapped:(id)sender {
    if(self.post.likedByUser){
        [self unlikePost];
    } else {
        [self likePost];
    }
}

@end
