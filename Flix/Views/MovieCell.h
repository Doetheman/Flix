//
//  movieCell.h
//  Flix
//
//  Created by Dorian Holmes on 6/27/18.
//  Copyright © 2018 Dorian Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabe;


@end
