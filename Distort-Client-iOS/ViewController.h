//
//  ViewController.h
//  Distort-Client-iOS
//
//  Created by Jason Chiu on 12/7/19.
//  Copyright © 2019 Jason Chiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputDistortSID;
@property (weak, nonatomic) IBOutlet UIButton *buttonDistortCall;
@property (weak, nonatomic) IBOutlet UILabel *textDistortInfo;


@end

