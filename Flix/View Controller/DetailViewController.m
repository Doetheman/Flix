//
//  DetailViewController.m
//  Flix
//
//  Created by Dorian Holmes on 6/28/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "MovieReviewController.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MediaViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MoviePoster;
@property (weak, nonatomic) IBOutlet UIImageView *TitleProfile;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailViewController
- (IBAction)Gesture:(id)sender {
    
    
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    //Checks url
    [self.MoviePoster setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString: backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    //Checks url
    [self.TitleProfile setImageWithURL:backdropURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    MediaViewController *mediaViewController = [segue destinationViewController];
    mediaViewController.movie = self.movie;
}


@end
