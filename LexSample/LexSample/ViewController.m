//
//  ViewController.m
//  LexSample
//
//  Created by LoftLabo on 2015/01/16.
//  Copyright (c) 2015年 LoftLabo. All rights reserved.
//

#import "ViewController.h"
#import "ShowDataViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)runAction:(id)sender {
    [self performSegueWithIdentifier:@"mySegue" sender:self];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mySegue"]) {
        ShowDataViewController *viewCon = segue.destinationViewController;
        viewCon.url_str = text_field.text;
    }
}
@end
