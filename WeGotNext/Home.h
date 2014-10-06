//
//  Home.h
//  WeGotNext
//
//  Created by Nick Zayatz on 6/2/14.
//  Copyright (c) 2014 Nick Zayatz and Charlie Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface Home : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocation *currentLocation;
    MKCoordinateRegion viewRegion;
}
   
@property (weak, nonatomic) IBOutlet MKMapView *Map;

@end
