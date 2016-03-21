//
//  ViewController.m
//  sqllitetest
//
//  Created by sriram on 3/21/16.
//  Copyright © 2016 sree. All rights reserved.
//

#import "ViewController.h"

#import "sqlite3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSURL* dbUrl = [fileMgr URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    dbUrl = [dbUrl URLByAppendingPathComponent:@"sree.sqlite"];
    
    const char *dbpath = [dbUrl absoluteString].UTF8String;
    
    sqlite3 *db;
    
    if(sqlite3_open(dbpath,&db) == SQLITE_OK){
        char *errMsg;
        
        //CREATE
        
        const char *create_table = "create table if not exists Images(ID integer primary key autoincrement, Name text)";
        
        if(sqlite3_exec(db, create_table, NULL, NULL, &errMsg) ==  SQLITE_OK) {
            NSLog(@"created table");
            
        }else{
            NSLog(@"could not create table");
        }
        
        //INSERT
        sqlite3_stmt *insert_stmt;
        const char *insert_table = "insert into Images (Name) values('bird')";
        
        sqlite3_prepare_v2(db, insert_table, -1, &insert_stmt, NULL);
        
        
        if(sqlite3_step(insert_stmt) == SQLITE_DONE) {
            NSLog(@"inserted");
            
        }
        
        sqlite3_finalize(insert_stmt);
        
        
        //QUERY BACK
        
        
        sqlite3_stmt * select_stmt;
        
        const char *select_table = "select name from Images";
        
        if(sqlite3_prepare_v2(db,select_table,-1,&select_stmt,NULL) == SQLITE_OK){
            
            while(sqlite3_step(select_stmt) == SQLITE_ROW){
                char * name = (char*) sqlite3_column_text(select_stmt,0);
                
                NSLog(@"%s",name);
            }
        };
        
        
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
