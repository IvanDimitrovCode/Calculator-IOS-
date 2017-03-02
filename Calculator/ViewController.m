//
//  ViewController.m
//  Calculator
//
//  Created by VCS on 2/28/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

@property  NSMutableString *userInputFirst;
@property  NSMutableString *userInputSecond;
@property  NSString *userInputOperation;
@property  NSMutableArray *operationsDone;
@property  NSMutableString *currentCellContent;
@property  BOOL isActionTaken;
@property  BOOL isNewCellCreated;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInputFirst = [[NSMutableString alloc] init];
    self.userInputSecond = [[NSMutableString alloc] init];
    self.currentCellContent = [[NSMutableString alloc] init];
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
   
    
    _isActionTaken = false;
    self.operationsDone = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender {
    UITableViewCell *cell = (UITableViewCell*)sender.view;
    
//    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
    NSString *clipBoardContent = cell.textLabel.text;
    long index= [clipBoardContent rangeOfString: @"="].location;
    
    NSLog(@"%ld",index);
    clipBoardContent  = [clipBoardContent substringFromIndex:index+2];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = clipBoardContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    [self setUserInput:("")];

//    self.userInput = [self.userInput stringByAppendingString:@""]
//    [self.userInput appendString:(@"0")];
//  NSLog(@"%@", _userInput);
// [self.userInputFirst appendString:(sender.titleLabel.text)];

- (IBAction)onEqualsPressed:(id)sender {
    
    if ([self.userInputFirst length] > 0 && [self.userInputSecond length] > 0 && self.isActionTaken) {
        long first = [self.userInputFirst longLongValue];
        long second = [self.userInputSecond longLongValue];
        if(first == 0 || second == 0) {
            return;
        }
        long  result;
        if ([self.userInputOperation isEqualToString: @"/"]){
            result = first / second;
        } else if ([self.userInputOperation isEqualToString: @"*"]) {
            result = first * second;
        } else if ([self.userInputOperation isEqualToString: @"-"]) {
            result = first - second;
        } else if ([self.userInputOperation isEqualToString: @"+"]) {
            result = first + second;
        }
        [self.currentCellContent appendString:[NSString stringWithFormat:@"= %ld",result]];
        [self.userInputSecond setString:@""];
        [self.userInputFirst setString:@""];
        [self.tableView reloadData];
        self.currentCellContent = [[NSMutableString alloc] init];
        self.isNewCellCreated = false;
        self.isActionTaken = false;
    }
}

- (IBAction)onButtonActionPressed:(UIButton *)sender {
    self.userInputOperation = sender.titleLabel.text;
    if(!self.isActionTaken){
        [self.currentCellContent appendString:sender.titleLabel.text];
    } else {
        NSString *s  = [self.currentCellContent substringToIndex:self.currentCellContent.length - 1];
        [self.currentCellContent setString:s];
        [self.currentCellContent appendString:sender.titleLabel.text];
    }
    [self.tableView reloadData];
    self.isActionTaken = true;
}

- (IBAction)onButtonNumberPressed:(UIButton *)sender {
      if (self.isActionTaken) {
          [self.userInputSecond appendString:sender.titleLabel.text];
      }
      else {
          if(!self.isNewCellCreated){
              self.currentCellContent = [[NSMutableString alloc] init];
              [self.operationsDone addObject: self.currentCellContent];
              NSIndexPath *newRow = [NSIndexPath indexPathForRow:self.operationsDone.count -1 inSection:0];
              [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newRow] withRowAnimation:UITableViewRowAnimationTop];
              self.isNewCellCreated = true;
          }
          [self.userInputFirst appendString:sender.titleLabel.text];
      }
    [self.currentCellContent appendString:sender.titleLabel.text];
    [self.operationsDone replaceObjectAtIndex:self.operationsDone.count-1 withObject:self.currentCellContent];
    [self.tableView reloadData];
}

// ARRAY
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.operationsDone.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"a";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell addGestureRecognizer:self.lpgr];
    cell.textLabel.text = [self.operationsDone objectAtIndex:indexPath.row];
    return cell;
}

@end
