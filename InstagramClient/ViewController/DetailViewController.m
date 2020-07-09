//
//  DetailViewController.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *postView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtons];
    [self setDetails];
}

- (void)setDetails{
    self.captionLabel.text = self.post.caption;
    [self.post setDates: self.post];
    self.dateLabel.text = self.post.fullDate;
    PFUser *user = self.post.author;
    [user fetchIfNeeded];
    self.usernameLabel.text = user[@"username"];
    self.iconView.layer.cornerRadius = 20;
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post.likeCount];
    [self.post.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.postView.image = image;
        }else{
            NSLog(@"Print error!!! %@", error.localizedDescription);
        }
    }];
}

- (void)updateButtons{
    UIImage *favIcon;
    if(self.post.likedByUser){
        favIcon = [UIImage imageNamed:@"black-heart.png"];
    } else {
        favIcon = [UIImage imageNamed:@"heart.png"];
    }
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
            [self setDetails];
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
            [self setDetails];
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


- (IBAction)commentTapped:(id)sender {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
