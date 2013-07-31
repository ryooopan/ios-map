//
//  MasterViewController.m
//  Map
//
//  Created by Ryo Suzuki on 7/23/13.
//  Copyright (c) 2013 Mitakalab. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Foursquare2.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *venues;
    
    MKMapView *mapView;
    CLLocationManager *locationManager;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    self.tableView.tableHeaderView = mapView;
    mapView.showsUserLocation = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
	[locationManager startUpdatingLocation];
}

-(void)setupMapForLocatoion:(CLLocation*)newLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    NSLog(@"longitude : %f, latitude %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
	[mapView setCenterCoordinate:newLocation.coordinate animated:YES];
    
	MKCoordinateRegion zoom = mapView.region;
	zoom.span.latitudeDelta = 0.005;
	zoom.span.longitudeDelta = 0.005;
	[mapView setRegion:zoom animated:YES];
    
    [locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    [self setupMapForLocatoion:newLocation];
}

-(void)getVenuesForLocation:(CLLocation*)location{
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:nil
									 intent:intentCheckin
                                     radius:@(500)
                                 categoryId:nil
								   callback:^(BOOL success, id result){
                                       NSLog(@"%@", result);
									   if (success) {
										   NSDictionary *dict = result;
                                           venues = [dict valueForKeyPath:@"response.venues"];
                                           [self.tableView reloadData];
									   }
								   }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [venues[indexPath.row] valueForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.venue = venues[indexPath.row];
    
}

@end
