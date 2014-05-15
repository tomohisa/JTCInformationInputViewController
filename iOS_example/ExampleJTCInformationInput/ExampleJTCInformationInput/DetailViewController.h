//
//  DetailViewController.h
//  ExampleJTCInformationInput
//
//  Created by Tomohisa Takaoka on 5/15/14.
//  Copyright (c) 2014 Tomohisa Takaoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
