//
//  RCIViewController.m
//  ReproCacheIssue
//
//  Created by Ankur Oberoi on 6/25/13.
//  Copyright (c) 2013 Ankur Oberoi. All rights reserved.
//

#import "RCIViewController.h"

@interface RCIViewController ()

@property (nonatomic) int number;

@end

@implementation RCIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.number = 0;
    
    
    // start a loop to send request every half second
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(sendRequest)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest
{
    NSURL* url = [NSURL URLWithString:@"http://reprocacheissue.herokuapp.com/endpoint"];
    
    
    // NOTE: explicitly setting cachePolicy to storage not allowed
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:5.0];
    [request setValue:[NSString stringWithFormat:@"%d", self.number] forHTTPHeaderField:@"X-RCI-I"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *responseError) {
       if (!responseError) {
           NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           
           NSLog(@"Response success! Number: %@", responseString);
                                              
       } else {
           NSLog(@"Response error: %@", responseError);
       }
       
       self.number++;
   }];

}

@end
