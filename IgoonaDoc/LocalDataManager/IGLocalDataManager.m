//
//  IGLocalDataManager.m
//  FMDBTest
//
//  Created by porco on 16/4/4.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGLocalDataManager.h"
#import "FMDB.h"
#import "IGMsgDetailObj.h"
#import "IGTaskObj.h"


static NSString * const IGDoneTaskTableName=@"IGDoneTaskTableName";
static NSString * const IGIconInfoTableName=@"IGIconInfoTableName";

@interface IGLocalDataManager()

@property (nonatomic,strong) FMDatabase *database;
@property (nonatomic,copy) NSString *doctorId;

@end


@implementation IGLocalDataManager
+(instancetype)sharedManager
{
    static IGLocalDataManager *manager=nil;
    static dispatch_once_t IGLocalDataManager_token;
    
    dispatch_once(&IGLocalDataManager_token, ^{
        manager=[[IGLocalDataManager alloc] init];
    });
    
    return manager;
}


-(void)connectToDataRepositoryWithDocId:(NSString*)docId
{
    NSAssert(docId.length>0, @"doc ID is empty");
    self.doctorId=docId;
    
    //make dir if needed
    NSString *userDir=[self p_pathForUserDirWithFilename:@""];
    if(![[NSFileManager defaultManager] fileExistsAtPath:userDir]){
        
        BOOL createDirSuccess= [[NSFileManager defaultManager] createDirectoryAtPath:userDir withIntermediateDirectories:YES   attributes:nil error:nil];
        if(!createDirSuccess)
            NSLog(@"create userDir directory failed");
    }
    
    
    //connect to database
    [self.database close];  //先关掉上次数据库
    
    self.database=[FMDatabase databaseWithPath:[self p_pathForUserDirWithFilename:@"task.db"]];
    
    NSLog(@"db path:%@",[self p_pathForUserDirWithFilename:@"task.db"]);
    
    if(![self.database open])
    {
        NSLog(@"%d: %@", [self.database lastErrorCode], [self.database lastErrorMessage]);
    }
    
}

-(void)disconnect
{
    [self.database close];
    self.database=nil;
    self.doctorId=@"";
}

-(NSArray*)loadAllLocalMessagesDataWithPatientId:(NSString *)patientId
{
    NSString *tableName=[NSString stringWithFormat:@"p%@",patientId];
    if(![self.database tableExists:tableName])
    {
        return @[];
    }
    
    

    NSString *queryStr=[NSString stringWithFormat:@"select * from %@ order by id desc",tableName];
    
    NSMutableArray *allData=[NSMutableArray array];
    FMResultSet *rs=[self.database executeQuery:queryStr];
    while ([rs next]) {
        IGMsgDetailObj *msg=[[IGMsgDetailObj alloc] init];
        msg.mId=[rs stringForColumn:@"id"];
        msg.mSessionId=[rs stringForColumn:@"session_id"];
        msg.mIsOut=[rs boolForColumn:@"is_out"];
        msg.mTime=[rs stringForColumn:@"time"];
        msg.mText=[rs stringForColumn:@"content_text"];
        msg.mAudioDuration=[rs intForColumn:@"audio_duration"];
        
        if(msg.mText.length==0){
            //先读音频
            NSString *audioName=[NSString stringWithFormat:@"%@.mp4",msg.mId];
            NSString *audioPath=[self p_pathForAudioDirWithPatientId:patientId filename:audioName];
            if([[NSFileManager defaultManager] fileExistsAtPath:audioPath]){
                msg.mAudioData=[NSData dataWithContentsOfFile:audioPath];
            }
            
            //再读图片
            if(msg.mAudioData.length>0==NO){
                NSString *imgName=[NSString stringWithFormat:@"%@.jpg",msg.mId];
                NSString *imgPath=[self p_pathForImageDirWithPatientId:patientId filename:imgName];
                if([[NSFileManager defaultManager] fileExistsAtPath:imgPath]){
                    msg.mThumbnail=[NSData dataWithContentsOfFile:imgPath];
                }
            }
        }
        
        [allData addObject:msg];
    }

    return allData;
}



-(void)saveMessagesData:(NSArray *)messagesData withPatientId:(NSString *)patientId
{
    //create table if needed
    NSString *tableName=[NSString stringWithFormat:@"p%@",patientId];
    if(![self.database tableExists:tableName])
    {
        NSString *createTableSQL=[NSString stringWithFormat:@"create table %@ (id integer primary key, session_id text, is_out integer, time text, content_text text, audio_duration integer)",tableName];
        [self.database executeUpdate:createTableSQL];
    }

    
    [self.database beginTransaction];
    
    for(IGMsgDetailObj *msg in messagesData)
    {
        NSString *queryStr=[NSString stringWithFormat:@"replace into %@ (id, session_id, is_out, time, content_text, audio_duration) values (?, ?, ?, ?, ?, ?)",[NSString stringWithFormat:@"p%@",patientId]];
        [self.database executeUpdate:queryStr,
         msg.mId,
         msg.mSessionId,
         @(msg.mIsOut),
         msg.mTime,
         msg.mText,
         @(msg.mAudioDuration)];//注意参数必需为object

        
        if(msg.mText.length>0)//文字
            continue;
        
        
        if(msg.mAudioData.length>0){          //音频
            
            //make dir if needed
            NSString *audioDir=[self p_pathForAudioDirWithPatientId:patientId filename:@""];
            if(![[NSFileManager defaultManager] fileExistsAtPath:audioDir]){
                
                BOOL createDirSuccess= [[NSFileManager defaultManager] createDirectoryAtPath:audioDir withIntermediateDirectories:YES   attributes:nil error:nil];
                if(!createDirSuccess)
                    NSLog(@"create audio directory failed");
            }
            
            NSString *audioName=[NSString stringWithFormat:@"%@.mp4",msg.mId];
            NSString *audioPath=[audioDir stringByAppendingPathComponent:audioName];
            
            [msg.mAudioData writeToFile:audioPath atomically:YES];
            
        }else if(msg.mThumbnail.length>0){          //图片
            
            //make dir if needed
            NSString *imgDir=[self p_pathForImageDirWithPatientId:patientId filename:@""];
            if(![[NSFileManager defaultManager] fileExistsAtPath:imgDir]){
                
                BOOL createDirSuccess= [[NSFileManager defaultManager] createDirectoryAtPath:imgDir withIntermediateDirectories:YES   attributes:nil error:nil];
                if(!createDirSuccess)
                    NSLog(@"create img directory failed");
            }
            
            
            NSString *imgName=[NSString stringWithFormat:@"%@.jpg",msg.mId];
            NSString *imgPath=[imgDir stringByAppendingPathComponent:imgName];
            
            [msg.mThumbnail writeToFile:imgPath atomically:YES];
        }
    }
    
    [self.database commit];

}


-(void)clearAllMessageDataWithPatientId:(NSString *)patientId
{
    NSString *tableName=[NSString stringWithFormat:@"p%@",patientId];
    NSString *queryStr=[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
    [self.database executeUpdate:queryStr];
}



-(NSArray*)loadAllDoneTasks{
    
    if(![self.database tableExists:IGDoneTaskTableName])
    {
        return @[];
    }
    
    NSString *queryStr=[NSString stringWithFormat:@"select * from %@ order by end_time desc",IGDoneTaskTableName];
    
    NSMutableArray *allData=[NSMutableArray array];
    
    FMResultSet *rs=[self.database executeQuery:queryStr];
    while ([rs next]) {
        IGTaskObj *t=[IGTaskObj new];
        t.tId=[rs stringForColumn:@"id"];
        t.tHandleTime=[rs stringForColumn:@"end_time"];
        t.tDueTime=[rs stringForColumn:@"due_time"];
        t.tMemberId=[rs stringForColumn:@"member_id"];
        t.tMemberName=[rs stringForColumn:@"member_name"];
        t.tMemberIconId=[rs stringForColumn:@"member_icon_id"];
        t.tMsg=[rs stringForColumn:@"message"];
        t.tType=[rs intForColumn:@"type"];
        t.tStatus=[rs intForColumn:@"status"];
        
        [allData addObject:t];
    }
    
    return allData;
}

-(void)saveDoneTasks:(NSArray*)donetasks{
    
    //create table if needed
    if(![self.database tableExists:IGDoneTaskTableName])
    {
        NSString *createTableSQL=[NSString stringWithFormat:@"create table %@ (id integer primary key, end_time text, due_time text, member_id text, member_name text, member_icon_id text, message text, type integer, status integer)",IGDoneTaskTableName];
        [self.database executeUpdate:createTableSQL];
    }

    
    [self.database beginTransaction];
    
    for(IGTaskObj *task in donetasks)
    {
        NSString *queryStr=[NSString stringWithFormat:@"replace into %@ (id, end_time, due_time, member_id, member_name, member_icon_id, message, type, status) values (?, ?, ?, ?, ?, ?, ?, ?, ?)",IGDoneTaskTableName];
        [self.database executeUpdate:queryStr,
         task.tId,
         task.tHandleTime,
         task.tDueTime,
         task.tMemberId,
         task.tMemberName,
         task.tMemberIconId,
         task.tMsg,
         @(task.tType),
         @(task.tStatus)];//注意参数必需为object
    }
    
    [self.database commit];
    
}


-(void)clearAllDoneTasks{
    NSString *queryStr=[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",IGDoneTaskTableName];
    [self.database executeUpdate:queryStr];
}




-(void)saveIconId:(NSString*)iconId withPatientId:(NSString*)patientId{
    //create table if needed
    if(![self.database tableExists:IGIconInfoTableName])
    {
        NSString *createTableSQL=[NSString stringWithFormat:@"create table %@ (id text primary key, icon_id text)",IGIconInfoTableName];
        [self.database executeUpdate:createTableSQL];
    }
    
    
    [self.database beginTransaction];
    
    
    
        NSString *queryStr=[NSString stringWithFormat:@"replace into %@ (id, icon_id) values (?, ?)",IGIconInfoTableName];
        [self.database executeUpdate:queryStr,
         patientId,
         iconId];//注意参数必需为object
    
    
    [self.database commit];
}

-(NSString*)loadIconIdWithPatientId:(NSString*)patientId{
    
    if(![self.database tableExists:IGIconInfoTableName])
    {
        return @"";
    }
    
    NSString *queryStr=[NSString stringWithFormat:@"select * from %@ where id ='%@'",IGIconInfoTableName,patientId];
    

    
    FMResultSet *rs=[self.database executeQuery:queryStr];
    if([rs next]) {
        
        
        return [rs stringForColumn:@"icon_id"];
        
        
    }
    
    return @"";
}

-(void)clearAllIconsInfo{
    NSString *queryStr=[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",IGIconInfoTableName];
    [self.database executeUpdate:queryStr];
}


#pragma mark - private methods

-(NSString*)p_pathForUserDirWithFilename:(NSString*)filename
{
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    return [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@/%@",self.doctorId,filename]];
}

-(NSString *)p_pathForAudioDirWithPatientId:(NSString*)patientId filename:(NSString*)filename
{
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@/audio/%@/%@",self.doctorId,patientId,filename]];
}

-(NSString*)p_pathForImageDirWithPatientId:(NSString*)patientId filename:(NSString*)filename
{
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@/image/%@/%@",self.doctorId,patientId,filename]];
}



@end
