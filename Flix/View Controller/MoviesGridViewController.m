//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Dorian Holmes on 6/28/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "Foundation/Foundation.h"
#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface MoviesGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    [self fetchMovies];
    

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing =5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing*(postersPerLine-1))/postersPerLine;
    CGFloat itemHeight = itemWidth * 2;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    // Stop the activity indicator
    // Hides automatically if "Hides When Stopped" is enabled
    [self.activityIndicator stopAnimating];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {

        self.filteredData = [self.movies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title contains[c] %@)",searchText]];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
    
}




- (void)fetchMovies{
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
  
    
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/106912/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // TODO: Get the array of movies
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            // TODO: Store the movies in a property to use elsewhere


            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            [self.collectionView reloadData];
        }
    }];
    [task resume];

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
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath: indexPath];
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString]; //Checks url
    cell.posterView.image = nil; //Rid of previous
    [cell.posterView setImageWithURL:posterURL]; //Adds in image in cells
    //cell.textLabel.text = movie[@"title"];
    cell.posterView.frame = CGRectMake(cell.posterView.frame.origin.x, cell.posterView.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filteredData.count;
    
}


@end
