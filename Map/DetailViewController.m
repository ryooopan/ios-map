//
//  DetailViewController.m
//  Map
//
//  Created by Ryo Suzuki on 7/23/13.
//  Copyright (c) 2013 Mitakalab. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
{
    MKMapView *mapView;
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
	[locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
	CLLocationCoordinate2D coordinate = newLocation.coordinate;
	
	[mapView setCenterCoordinate:coordinate animated:NO];

	MKCoordinateRegion zoom = mapView.region;
	zoom.span.latitudeDelta = 0.005;
	zoom.span.longitudeDelta = 0.005;
	[mapView setRegion:zoom animated:YES];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
