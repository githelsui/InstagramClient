//
//  PostCell.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

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
//    self.usernameLabel.text = self.post.author[@"username"];
//    [self.postView setImage:self.post.image];
    self.iconView.layer.cornerRadius = 15;
}

@end
