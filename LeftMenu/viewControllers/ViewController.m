//
//  ViewController.m
//  CocoaPodsTest
//
//  Created by Mac on 2017/4/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "BaseNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled=YES;
    scrollView.contentSize=CGSizeMake(screenWidth*3, screenHeight);

    
    
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [scrollView addSubview:imageView1];
    imageView1.image=[UIImage imageNamed:@"10.jpeg"];

    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    [scrollView addSubview:imageView2];
    imageView2.image=[UIImage imageNamed:@"9.jpeg"];

    
    UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(screenWidth*2, 0, screenWidth, screenHeight)];
    [scrollView addSubview:imageView3];
    imageView3.image=[UIImage imageNamed:@"11.jpg"];

    
    //禁止侧滑手势和tableView同时滑动
    BaseNavigationController *navController = (BaseNavigationController *)self.navigationController;
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:navController.leftEdgeGesture];
    
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 250, 100, 100)];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 addTarget:self action:@selector(aaaaaa1) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button1];
    [button1 setTitle:@"点击push" forState:UIControlStateNormal];


}


- (void)aaaaaa1 {
    
    NSLog(@"self.navigationController   %@",self.navigationController);
    
    SecondViewController *viewC=[[SecondViewController alloc]init];
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
