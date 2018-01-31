//
//  LocationManger.h
//  CarBaDa
//
//  Created by Alex on 6/9/15.
//  Copyright (c) 2015 wyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>
@optional
-(void)lmGetCityNameDelegate;
-(void)lmGetCoordinateDelegate;
-(void)lmGetLocationFaild:(NSString*)sError;
@end

@interface LocationManger : NSObject
<
    CLLocationManagerDelegate
>
{
    
}

@property (nonatomic,strong) CLLocationManager *lManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) NSString *sCityName;
@property (nonatomic,strong) NSString *sCountryCode;
@property (nonatomic,strong) NSString *sPostalCode;
@property (nonatomic,strong) NSString *sProvinceOrStateCode;
@property (nonatomic,strong) NSString *streetLine1;
@property (nonatomic,strong) NSString *streetLine2;
@property (nonatomic,assign) float fLatitude;
@property (nonatomic,assign) float fLongitude;
@property (nonatomic,assign) NSInteger iAllow;//0 没开始 1允许 2不允许
@property (nonatomic,weak) id<LocationManagerDelegate> delegate;
@property (nonatomic,assign) CLLocationCoordinate2D currentCoordinate;

+(LocationManger*)getInstance;
+(LocationManger*)getInstanceWithDelegate:(id)delegate;

-(void)startUpdataLocation;

@end
