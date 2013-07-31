//
//  DetailViewController.m
//  Map
//
//  Created by Ryo Suzuki on 7/23/13.
//  Copyright (c) 2013 Mitakalab. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController
{
    MKMapView *mapView;
    CLLocationManager *locationManager;
}


#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

	CLLocationCoordinate2D coordinate = newLocation.coordinate;

    NSLog(@"%f", coordinate.latitude);
    NSLog(@"%f", coordinate.longitude);
    
	[mapView setCenterCoordinate:coordinate animated:YES];

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
