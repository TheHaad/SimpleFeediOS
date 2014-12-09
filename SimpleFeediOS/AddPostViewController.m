//
//  AddPostViewController.m
//  SimpleFeediOS
//
//  Created by Fahad Muntaz on 2014-12-09.
//
//

#import "AddPostViewController.h"
#import "APIManager.h"

@interface AddPostViewController()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyTextField;

@end

@implementation AddPostViewController

- (IBAction)submitButtonTapped {
    if (self.titleTextField.text && self.bodyTextField.text) {
        [[APIManager sharedManager] addNewPost:self.titleTextField.text withBody:self.bodyTextField.text];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        UIAlertView *validationFailedAlert = [[UIAlertView alloc] initWithTitle:@"Please Enter Content" message:@"One or more fields are missing content. Please add content to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [validationFailedAlert show];
    }
}

@end
