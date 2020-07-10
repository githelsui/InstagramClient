//
//  ProfileViewController.m
//  InstagramClient
//
//  Created by Githel Lynn Suico on 7/7/20.
//  Copyright © 2020 Githel Lynn Suico. All rights reserved.
//

#import "ProfileViewController.h"
#import "DetailViewController.h"
#import "CollectionCell.h"
#import "Post.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *numPosts;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = PFUser.currentUser;
    [self.currentUser fetchIfNeeded];
    [self fetchOwnPost];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
}

- (void)fetchOwnPost{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.currentUser];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self renderProfile];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.collectionView reloadData];
    }];
}

- (void)renderProfile{
    self.nameLabel.text = self.currentUser[@"username"];
    self.numPosts.text = [NSString stringWithFormat:@"%lu Posts", (unsigned long)self.posts.count];
    self.iconView.layer.cornerRadius = 35;
    if(self.currentUser[@"icon"]){
        [self.currentUser[@"icon"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.iconView.image = image;
            }else{
                NSLog(@"Print error!!! %@", error.localizedDescription);
            }
        }];
    }
}

- (IBAction)iconTapped:(id)sender {
    [self initCamera];
}

- (void)initCamera{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    CGSize size = CGSizeMake(400.0, 400.0);
    UIImage *editedImage = [self resizeImage:originalImage withSize:size];
    // Do something with the images (based on your use case)
    [self postImage:editedImage];
}

- (void)postImage:(UIImage *)icon{
    self.currentUser[@"icon"] = [Post getPFFileFromImage: icon];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            [self.iconView setImage:icon];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [cell setCell];
    NSLog(@"%s", " being called");
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.bounds.size.width/3, self.collectionView.bounds.size.width/3);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        NSLog(@"post being passed %@", post);
        DetailViewController *detailController = [segue destinationViewController];
        detailController.post = post;
    }
}


@end
