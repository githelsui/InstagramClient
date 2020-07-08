//
//  TimelineViewController.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/6/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

#import "TimelineViewController.h"
#import "LoginController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "DetailViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchPosts) userInfo:nil repeats:true];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //    [query whereKey:@"likesCount" greaterThan:@0];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)logoutTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [cell setCell];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    if ([segue.identifier isEqualToString:@"DetailSegue"]){
    Post *post = self.posts[indexPath.row];
    NSLog(@"post being passed %@", post);
    DetailViewController *detailController = [segue destinationViewController];
    detailController.post = post;
    }
}


@end
