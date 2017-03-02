//
//  ViewController.h
//  Calculator
//
//  Created by VCS on 2/28/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *collection;

- (IBAction)onEqualsPressed:(id)sender;
- (IBAction)onButtonActionPressed:(UIButton *)sender;
- (IBAction)onButtonNumberPressed:(UIButton *)sender;

//@property IBOutlet UIButton* ad;
@end

