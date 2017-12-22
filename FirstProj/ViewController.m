//
//  ViewController.m
//  FirstProj
//
//  Created by Up & Up on 12/19/17.
//  Copyright © 2017 Up & Up. All rights reserved.
//

#import "ViewController.h"
#import "Firebase.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [[GIDSignIn sharedInstance] signInSilently];
}

- (IBAction)signOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
