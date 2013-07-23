//
//  DetailViewController.h
//  Map
//
//  Created by Ryo Suzuki on 7/23/13.
//  Copyright (c) 2013 Mitakalab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong,nonatomic)IBOutlet MKMapView* mapView;


@end
