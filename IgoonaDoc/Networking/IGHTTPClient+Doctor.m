//
//  IGHTTPClient+Doctor.m
//  IgoonaDoc
//
//  Created by Porco Wu on 8/19/16.
//  Copyright © 2016 Porco. All rights reserved.
//

#import "IGHTTPClient+Doctor.h"
#import "IGDocMemberObj.h"
#import "IGPatientInfoObj.h"
#import "IGIncomeMemeberObj.h"
#import "IGFinancialDetailObj.h"
#import "IGPatientServiceObj.h"
#import "IGInvitedCustomerObj.h"

@implementation IGHTTPClient (Doctor)

-(void)requestForMyDetailInfoWithFinishHandler:(void (^)(BOOL, NSInteger, IGDocInfoDetailObj *))finishHandler{
    [self GET:@"php/doctor.php"
   parameters:@{@"action":@"getDetail"}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
          
          if(IGRespSuccess){
              IGDocInfoDetailObj *docInfo=[IGDocInfoDetailObj new];
              docInfo.dName=responseObject[@"name"];
              docInfo.dLevel=[responseObject[@"level"] integerValue];
              docInfo.dCityId=responseObject[@"city_id"];
              docInfo.dHospitalName=responseObject[@"hospital"];
              docInfo.dGender=[responseObject[@"sex"] integerValue];
              docInfo.dCityName=responseObject[@"city_name"];
              docInfo.dProvinceId=responseObject[@"province_id"];
              
              finishHandler(YES,0, docInfo);
          }else{
              NSInteger errCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errCode,nil);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem, nil);
      }];

}


-(void)requestToChangeMyInfo:(IGDocInfoDetailObj *)info finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"update_doctor",
                        @"name":info.dName,
                        @"iconIdx":info.dIconId,
                        @"isMale":@(info.dGender),
                        @"level":@(info.dLevel),
                        @"city":info.dCityId,
                        @"hospital":info.dHospitalName}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      finishHandler(YES,0);
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode);
                  }
                  
              }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem);
              }];

}



-(void)requestToChangeToWorkStatus:(NSInteger)status finishHandler:(void (^)(BOOL, NSInteger))handler{
    [self GET:@"php/doctor.php"
   parameters:@{@"action":@"change_working_state",
                @"state":@(status)}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if(IGRespSuccess){
              handler(YES,0);
          }else{
              NSInteger errCode=[responseObject[@"reason"] integerValue];
              handler(NO,errCode);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          handler(NO,IGErrorNetworkProblem);
      }];
    
}




-(void)requestForTeamInfoFinishHandler:(void (^)(BOOL, NSInteger, NSArray *))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"get_members"}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){

                      __block NSMutableArray *docs=[NSMutableArray array];
                      [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* dDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGDocMemberObj *doc=[IGDocMemberObj new];
                          doc.dId=dDic[@"id"];
                          doc.dName=dDic[@"name"];
                          doc.dStatus=[dDic[@"status"] integerValue];
                          [docs addObject:doc];
                      }];
                      
                      finishHandler(YES,0,docs);
                      
                  }else{
                       NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil);
              }];
}


-(void)requestToDeleteAssistant:(NSString *)docId finishHandler:(void (^)(BOOL, NSInteger))finishHandler{
    
    [IGHTTPCLIENT GET:@"php/doctor.php"
           parameters:@{@"action":@"delete_assistant",
                        @"id":docId}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  if(IGRespSuccess){
                      
                      finishHandler(YES,0);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode);
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem);
              }];
    
}

-(void)requestForMyPatientsWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSInteger, NSArray *, NSInteger))finishHandler{
    [self GET:@"php/doctor.php"
           parameters:@{@"action":@"get_patient_summary",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                  
                  if(IGRespSuccess){
                      
                      __block NSMutableArray *patients=[NSMutableArray array];
                      [responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* pDic, NSUInteger idx, BOOL * _Nonnull stop) {
                          IGPatientInfoObj *p=[IGPatientInfoObj new];
                          p.pId=pDic[@"id"];
                          p.pName=pDic[@"name"];
                          p.pIsMale=[pDic[@"is_male"] boolValue];
                          p.pAge=[pDic[@"age"] integerValue];
                          
                          [patients addObject:p];
                      }];
                      
                      NSInteger total=[responseObject[@"total"] integerValue];
                      
                      finishHandler(YES,0,patients,total);
                      
                  }else{
                      NSInteger errCode=[responseObject[@"reason"] integerValue];
                      finishHandler(NO,errCode,nil,0);
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  finishHandler(NO,IGErrorNetworkProblem,nil,0);
              }];

    
}




-(void)requestForIncomeMembersWithStartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSInteger, NSArray *, NSInteger))finishHandler{
    [self GET:@"php/doctor.php"
           parameters:@{@"action":@"get_income_members",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IGRespSuccess){
                     
                     __block NSMutableArray *incomeList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* mDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGIncomeMemeberObj *m=[IGIncomeMemeberObj new];
                         m.mId=mDic[@"doctor_id"];
                         m.mName=mDic[@"name"];
                         m.mStatus=[mDic[@"status"] integerValue];
                         
                         [incomeList addObject:m];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,0,incomeList,total);
                 }else{
                     NSInteger errCode=[responseObject[@"reason"] integerValue];
                     finishHandler(NO,errCode,nil,0);
                 }
                 
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,IGErrorNetworkProblem,nil,0);
             }];

}

-(void)requestForIncomeMembersLv2WithDoctorId:(NSString *)doctorId StartNum:(NSInteger)startNum finishHandler:(void (^)(BOOL, NSInteger, NSArray *, NSInteger))finishHandler{
    
    [self GET:@"php/doctor.php"
           parameters:@{@"action":@"get_level2_members",
                        @"doctorId":doctorId,
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IGRespSuccess){
                     
                     __block NSMutableArray *incomeList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* mDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGIncomeMemeberObj *m=[IGIncomeMemeberObj new];
                         m.mId=mDic[@"doctor_id"];
                         m.mName=mDic[@"name"];
                         m.mStatus=[mDic[@"status"] integerValue];
                         
                         [incomeList addObject:m];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,0,incomeList,total);
                 }else{
                     NSInteger errCode=[responseObject[@"reason"] integerValue];
                     finishHandler(NO,errCode,nil,0);
                 }
                 
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,IGErrorNetworkProblem,nil,0);
             }];

}





-(void)requestForFinancialDetailWithStartNum:(NSInteger)startNum finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *financialInfo,NSInteger total))finishHandler{
    [self GET:@"php/doctor.php"
           parameters:@{@"action":@"get_financial_detail",
                        @"start":@(startNum),
                        @"limit":@(20)}
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 if(IGRespSuccess){
                     
                     __block NSMutableArray *financialList=[NSMutableArray array];
                     [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* fDic, NSUInteger idx, BOOL * _Nonnull stop) {
                         IGFinancialDetailObj *f=[IGFinancialDetailObj new];
                         f.fName=fDic[@"name"];
                         f.fAmount=[fDic[@"amount"] integerValue];
                         f.fDate=fDic[@"date"];
                         
                         [financialList addObject:f];
                     }];
                     
                     NSInteger total=[responseObject[@"total"] integerValue];
                     
                     finishHandler(YES,0,financialList,total);
                 }else{
                     NSInteger errCode=[responseObject[@"reason"] integerValue];
                     finishHandler(NO,errCode,nil,0);
                 }
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 finishHandler(NO,IGErrorNetworkProblem,nil,0);
             }];
    

}


-(void)requestForPatientServicesWithStartNum:(NSInteger)startNum finishHandler:(void(^)(BOOL success,NSInteger errCode,NSArray *servicesInfo,NSInteger total))finishHandler{
    [self GET:@"php/doctor.php"
   parameters:@{@"action":@"get_services",
                @"start":@(startNum),
                @"limit":@(20)}
     progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@",responseObject);
         
         if(IGRespSuccess){
             
             __block NSMutableArray *servicesList=[NSMutableArray array];
             [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* sDic, NSUInteger idx, BOOL * _Nonnull stop) {
                 IGPatientServiceObj *s=[IGPatientServiceObj new];
                 s.sName=sDic[@"name"];
                 s.sLevel=[sDic[@"level"] integerValue];
                 s.sExpDate=sDic[@"date"];
                 
                 [servicesList addObject:s];
                 
             }];
             
             NSInteger total=[responseObject[@"total"] integerValue];
             
             finishHandler(YES,0,servicesList,total);
         }else{
             NSInteger errCode=[responseObject[@"reason"] integerValue];
             finishHandler(NO,errCode,nil,0);
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         finishHandler(NO,IGErrorNetworkProblem,nil,0);
     }];

}


-(void)requestForInvitedCustomersFinishHandler:(void(^)(BOOL success,NSInteger errCode, NSArray* customersInfo))finishHandler{
    [self GET:@"php/doctor.php"
   parameters:@{@"action":@"get_invited_customer"}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
          
          if(IGRespSuccess){
              
              NSMutableArray *customers=[NSMutableArray array];
              [(NSArray*)responseObject[@"data"] enumerateObjectsUsingBlock:^(NSDictionary* cDic, NSUInteger idx, BOOL * _Nonnull stop) {
                  IGInvitedCustomerObj *c=[IGInvitedCustomerObj new];
                  c.cId=cDic[@"id"];
                  c.cName=cDic[@"name"];
                  [customers addObject:c];
              }];
              
              finishHandler(YES,0,customers);
              
          }else{
              NSInteger errCode=[responseObject[@"reason"] integerValue];
              finishHandler(NO,errCode,nil);
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          finishHandler(NO,IGErrorNetworkProblem,nil);
      }];

}
@end
