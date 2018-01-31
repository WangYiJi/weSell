//
//  CitysViewController.m
//  WyjDemo
//
//  Created by Alex on 16/4/15.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "CitysViewController.h"
#import "CityCell.h"
#import "ResponseCountry.h"
#import "UITableView+CustomCell.h"
#import "Utils.h"
#import "UploadUserInfoEntity.h"
#import "NetworkEngine.h"
#import "CategoryAndCountryInfo.h"

@interface CitysViewController ()
{
    NSInteger iCityType;
}
@property (nonatomic,strong) CountryInfo *chooseContryInfo;
@property (strong,nonatomic) ProvinceOrStateInfos *chooseProvince;//选中省份
@property (strong,nonatomic) CityInfo *chooseCity;//选中城市

@end

@implementation CitysViewController
@synthesize cityArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityArr = [[CategoryAndCountryInfo getInstance] countryInfo].responseCountryInfoArray;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *cellIdentify = @"CityCell";
        CityCell *cell = (CityCell *)[tableView customdq:cellIdentify];
        
        switch (iCityType) {
            case cityType_Country:
            {
                if (cityArr.count > 0) {
                    CountryInfo *c = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = c.displayName;
                }
            }
                break;
            case cityType_Province:
            {
                if (cityArr.count > 0) {
                    ProvinceOrStateInfos *pro = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = pro.displayName;
                }
            }
                break;
            case cityType_City:
            {
                if (cityArr.count > 0) {
                    CityInfo *city = [cityArr objectAtIndex:indexPath.row];
                    cell.lblName.text = city.displayName;
                }
            }
                break;
            default:
                break;
        }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iCityType == cityType_Country) {
        self.chooseContryInfo = [cityArr objectAtIndex:indexPath.row];
        if (self.chooseContryInfo.provinceOrStateInfos.count > 0) {
            iCityType = cityType_Province;
            cityArr = self.chooseContryInfo.provinceOrStateInfos;
            [tableView reloadData];
            return;
        }else {
            //选中国家
//            _lblSXCity.text = self.chooseContryInfo.displayName;
//            [self hideCityView];
            return;
        }
    }else if (iCityType == cityType_Province) {
        self.chooseProvince = [cityArr objectAtIndex:indexPath.row];
        if (self.chooseProvince.cities.count > 0) {
            iCityType  = cityType_City;
            cityArr = self.chooseProvince.cities;
            [tableView reloadData];
            return;
        }else {
            //选中省份
//            _lblSXCity.text = self.chooseProvince.displayName;
//            [self hideCityView];
            return;
        }
    }else if (iCityType == cityType_City) {
        //选中城市了
        self.chooseCity = [cityArr objectAtIndex:indexPath.row];
        
        [self updateUserLocation:self.chooseCity.displayName];
        
        return;
    }
}

-(void)updateUserLocation:(NSString*)userLocationId
{
    [[NSUserDefaults standardUserDefaults] setValue:userLocationId forKey:@"localCityId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"chooseCity"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
