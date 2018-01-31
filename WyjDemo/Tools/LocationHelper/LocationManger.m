//
//  LocationManger.m
//  CarBaDa
//
//  Created by Alex on 6/9/15.
//  Copyright (c) 2015 wyj. All rights reserved.
//

#import "LocationManger.h"

static LocationManger *locationInstance;

@implementation LocationManger
@synthesize lManager;
@synthesize geocoder;
@synthesize sCityName;
@synthesize delegate;
@synthesize fLatitude;
@synthesize fLongitude;
@synthesize sPostalCode;
@synthesize sProvinceOrStateCode;
@synthesize sCountryCode;
@synthesize streetLine1;
@synthesize streetLine2;
@synthesize iAllow;

+(LocationManger*)getInstance
{
    return [LocationManger getInstanceWithDelegate:nil];
}

+(LocationManger*)getInstanceWithDelegate:(id)delegate
{
    @synchronized(self) {
        if (!locationInstance) {
            locationInstance = [[LocationManger alloc] init];
            locationInstance.geocoder = [[CLGeocoder alloc] init];
        }
        if (delegate) {
            locationInstance.delegate = delegate;
        }
    }
    return locationInstance;
}

-(void)startUpdataLocation
{
    if (self.lManager) {
        [self.lManager stopUpdatingLocation];
        self.lManager.delegate=nil;
        self.lManager=nil;
    }
    
    self.lManager = [[CLLocationManager alloc] init];
    self.lManager.delegate=self;
    self.lManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    self.lManager.distanceFilter=100.0f;
    if ([self.lManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.lManager requestWhenInUseAuthorization];
    }
    [self.lManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    /*
     模拟地区反编译
        CLLocation *lItem = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(31.199985,121.396835)
                                                          altitude:0
                                                horizontalAccuracy:0
                                                  verticalAccuracy:0
                                                         timestamp:[NSDate date]];
     */

    CLLocation *lItem = [locations lastObject];
    if (self.delegate && [self.delegate respondsToSelector:@selector(lmGetCoordinateDelegate)]) {
        self.currentCoordinate = lItem.coordinate;
        [self.delegate lmGetCoordinateDelegate];
    }

    self.fLatitude = lItem.coordinate.latitude;
    self.fLongitude = lItem.coordinate.longitude;
    NSLog(@"Lat: %f  Lng: %f", lItem.coordinate.latitude, lItem.coordinate.longitude);
    [self getAddressByLatitude:lItem.coordinate.latitude longitude:lItem.coordinate.longitude];
    
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    self.iAllow = 1;
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [locationInstance.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //NSLog(@"详细信息:%@",placemark.addressDictionary);
        self.sCityName = placemark.locality;
        self.sCountryCode = placemark.ISOcountryCode;
        self.sPostalCode = placemark.postalCode;
        self.sProvinceOrStateCode = placemark.administrativeArea;
        self.streetLine1 = [NSString stringWithFormat:@"%@",placemark.subLocality];
        self.streetLine2 = [NSString stringWithFormat:@"%@",placemark.subLocality];
        if (self.delegate && [self.delegate respondsToSelector:@selector(lmGetCityNameDelegate)]) {
            [self.delegate lmGetCityNameDelegate];
        }

    }];
}

////实现逆地理编码的回调函数
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if(response.regeocode != nil)
//    {
//        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        self.sCityName = [response.regeocode.addressComponent.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
//        //直辖市处理
//        if (self.sCityName.length == 0) {
//            self.sCityName = [response.regeocode.addressComponent.province stringByReplacingOccurrencesOfString:@"市" withString:@""];
//        }
//        self.sAddress = response.regeocode.formattedAddress;
//        self.ego = response.regeocode.addressComponent;
//        //self.sSortAddress =
//        if (self.delegate && [self.delegate respondsToSelector:@selector(lmGetCityNameDelegate)]) {
//            [self.delegate lmGetCityNameDelegate];
//        }
//    }
//}

-(void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"searchRequest  %@",errInfo);
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    self.iAllow = 2;
    NSLog(@"didFailWithError %@",error.description);
    if (self.delegate && [self.delegate respondsToSelector:@selector(lmGetLocationFaild:)]) {
        [self.delegate lmGetLocationFaild:error.description];
    }
}

//- (void)search:(id)searchRequest error:(NSString *)errInfo __attribute__ ((deprecated("use -search:didFailWithError instead.")));


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.iAllow = 2;
    NSLog(@"Fail %@",error.description);
    if (self.delegate && [self.delegate respondsToSelector:@selector(lmGetLocationFaild:)]) {
        [self.delegate lmGetLocationFaild:error.description];
    }
}

@end
