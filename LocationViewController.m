//
//  LocationViewController.m
//  Template 1
//
//  Created by Rafael on 05/12/13.
//  Copyright (c) 2013 Rafael Colatusso. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // asks location access in the first time
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

#pragma mark -
#pragma MKMapKit Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
    // zoom and center on user location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 8000, 8000);
    [self.mapView setRegion:region animated:NO];
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
