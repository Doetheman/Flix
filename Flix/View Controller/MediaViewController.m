//
//  MediaViewController.m
//  
//
//  Created by Dorian Holmes on 6/29/18.
//

#import "MediaViewController.h"


@interface MediaViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *TrailerWebView;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movie[@"id"]];
    NSURL *url = [NSURL URLWithString:urlString];
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
            
            NSLog(@"%@", dataDictionary);
            
            NSString *urlString = [NSString stringWithFormat:@"https://www.youtube.com/embed/%@%@", dataDictionary[@"results"][0][@"key"], @"/ecver=2"];
            // Convert the url String to a NSURL object.
            NSURL *trailerURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            // Load Request into WebView.
            [self.TrailerWebView loadRequest:request];
        }
    }];

    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
