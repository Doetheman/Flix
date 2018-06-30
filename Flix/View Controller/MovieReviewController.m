//
//  MovieReviewController.m
//  Flix
//
//  Created by Dorian Holmes on 6/27/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//
#import "MovieCell.h"
#import "MediaViewController.h"
#import "DetailViewController.h"
#import "MovieReviewController.h"
#import "UIImageView+AFNetworking.h" //more methods :D
@interface MovieReviewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl; //Refresh variable
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@end

@implementation MovieReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init]; //initialize refresh control
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];//add refresh control to table behind the first cell
    }

- (void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          // TODO: Get the array of movies
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
             [self.loading startAnimating];
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Store the movies in a property to use elsewhere
            
            NSLog(@"%@", dataDictionary);
            self.movies = dataDictionary[@"results"];
            for ( NSDictionary *movie in self.movies ) {
                NSLog(@"%@", movie[@"title"]);
            }
           
            // TODO: Reload your table view data
            [self.tableView reloadData];
            // Start the activity indicator
          
            
        }
        [self.refreshControl endRefreshing];
        // Stop the activity indicator
        // Hides automatically if "Hides When Stopped" is enabled
        [self.loading stopAnimating];    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];

    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabe.text =movie[@"overview"];
    //Movie images
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString]; //Checks url
    cell.posterView.image = nil; //Rid of previous
    [cell.posterView setImageWithURL:posterURL]; //Adds in image in cells
    //cell.textLabel.text = movie[@"title"];
   
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
    
}

@end
