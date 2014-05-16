//
//  JTCInformationInputViewController.m
//  PrimasDXII
//
//  Created by Tomohisa Takaoka on 5/13/14.
//
//

#import "JTCInformationInputViewController.h"
#import <extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SECoreTextView/SETextView.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <JTCCommon/JTCCommon.h>

@interface JTCInformationInputViewController () <UITextViewDelegate,SETextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet SETextView *textView;
@property (weak, nonatomic) IBOutlet UIView *textBaseView;
@property (nonatomic) NSMutableArray * notifications;
@property (copy,nonatomic) JTCInformationInputViewblockResultAndData validatorChaignBlock;
@end

@implementation JTCInformationInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textView.delegate = self;
    self.textView.editable = YES;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textBaseView.layer.masksToBounds = YES;
    self.textBaseView.layer.cornerRadius = 10.0;
    self.notifications = @[].mutableCopy;
    @weakify(self);
    [self.notifications addObject:[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        CGRect frame = [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:[[note.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]*0.0 animations:^{
            self_weak_.constraintBottom.constant = frame.size.height + 10;
            [self_weak_.view layoutIfNeeded];
            [self_weak_.textBaseView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }]];
    self.textView.keyboardType = self.keyboardType;
    self.textView.text = self.originalText;
    self.title = self.topTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self);
    if (self.viewFormatter) {
        self.viewFormatter(self_weak_, self_weak_.textView);
    }
    [self.textView becomeFirstResponder];
    self.textView.selectedRange = NSMakeRange(self.textView.text.length, 0);
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(JTCInformationInputViewblockValidate)commonKatakanaValidator {
    return ^(JTCInformationInputViewController* vc,id data, JTCInformationInputViewblockResultAndData validationCompleted) {
        NSString * str = [data stringByConvertingHiraganaToKatakana];
        if ([str isAllKatakanaOrSpace]) {
            validationCompleted(YES,str);
        }else{
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];
            [SVProgressHUD showErrorWithStatus:@"カタカナで入力してください。"];
        }
    };
}
+(JTCInformationInputViewblockValidate)mistakenValidatorWithWrongDomain:(NSString*)wrong rightDomain:(NSString*)right appName:(NSString*)appName{
    return [^(JTCInformationInputViewController* vc,id data, JTCInformationInputViewblockResultAndData validationCompleted) {
        if ([data containsString:wrong]) {
            [UIAlertView bk_showAlertViewWithTitle:appName message:[NSString stringWithFormat:@"%@というドメインは存在しません。%@ではないですか？",wrong,right] cancelButtonTitle:@"再入力" otherButtonTitles:@[@"変更する",@"そのまま使用する"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==0) {
                    validationCompleted(NO,data);
                }
                if (buttonIndex==1) {
                    validationCompleted(YES,[data stringByReplacingOccurrencesOfString:wrong withString:right]);
                }
                if (buttonIndex==2) {
                    validationCompleted(YES,data);
                }
            }];
        }else{
            validationCompleted(YES,data);
        }
    } copy];
}
+(JTCInformationInputViewblockValidate)commonEmailValidator {
    return [^(JTCInformationInputViewController* vc,id data, JTCInformationInputViewblockResultAndData validationCompleted) {
        if ([data isValidEmail]) {
            validationCompleted(YES,data);
        }else{
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setForegroundColor:[UIColor lightGrayColor]];
            [SVProgressHUD showErrorWithStatus:@"メールアドレスの形式が正しくありません。正しいメールアドレスを入力してください。"];
        }
    } copy];
}
+(JTCInformationInputViewAdditionalformat) commonEmailTextFormatter {
    return [^ (JTCInformationInputViewController*vc, SETextView* textView) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.keyboardType = UIKeyboardTypeEmailAddress;
        vc.arrayNGWords = @[@"mailto:"];
        vc.allowEnter = NO;
        vc.legalCharactors = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&`+-*/’^{}_.@";
    } copy];
}
+(JTCInformationInputViewAdditionalformat) commonPhoneNumberTextFormatter {
    return [^ (JTCInformationInputViewController*vc, SETextView* textView) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.keyboardType = UIKeyboardTypeNumberPad;
        vc.allowEnter = NO;
        vc.legalCharactors = @"0123456789";
    } copy];
}
+(JTCInformationInputViewAdditionalformat) commonNameTextFormatter {
    return [^ (JTCInformationInputViewController*vc, SETextView* textView) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        textView.keyboardType = UIKeyboardTypeDefault;
        vc.keyboardType = UIKeyboardTypeDefault;
        vc.allowEnter = NO;
    } copy];
}
+(JTCInformationInputViewAdditionalformat) commonNameJPPhoneticTextFormatter {
    return [^ (JTCInformationInputViewController*vc, SETextView* textView) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        textView.keyboardType = UIKeyboardTypeDefault;
        vc.keyboardType = UIKeyboardTypeDefault;
        vc.allowEnter = NO;
    } copy];
}
+(JTCInformationInputViewAdditionalformat) commonFreeTextFormatter {
    return [^ (JTCInformationInputViewController*vc, SETextView* textView) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        textView.keyboardType = UIKeyboardTypeDefault;
        vc.keyboardType = UIKeyboardTypeDefault;
        vc.allowEnter = YES;
    } copy];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ((!self.allowEnter) && [text containsString:@"\n"]) {
        [self actionDone:self];
        return NO;
    }
	return YES;
}

- (void) textViewDidChange:(SETextView *)textView {
    [self.arrayNGWords enumerateObjectsUsingBlock:^(NSString * ngWord, NSUInteger idx, BOOL *stop) {
        if ([textView.text containsString:ngWord]) {
            textView.text = [textView.text stringByReplacingOccurrencesOfString:ngWord withString:@""];
        }
    }];
}

#pragma mark - Actions;

-(IBAction)actionDone:(id)sender {
    @weakify(self);
    if (self.validation) {
        self.validation(self_weak_,self_weak_.textView.text.copy, ^(BOOL result, id data){
            if (result) {
                self_weak_.completed(YES, data);
                [self_weak_.navigationController popViewControllerAnimated:YES];
            }
        });
    }else if (self.validators.count){
        __block NSInteger index=0;
        self_weak_.validatorChaignBlock = ^(BOOL result, id data) {
            if (result) {
                index++;
                if (index < self_weak_.validators.count) {
                    [self_weak_ validatorChain:index data:data];
                }else{
                    self_weak_.completed(YES, data);
                    [self_weak_.navigationController popViewControllerAnimated:YES];
                }
            }
        };
        [self_weak_ validatorChain:index data:self_weak_.textView.text.copy];
    }else{
        self.completed(YES,self.textView.text.copy);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)validatorChain:(NSInteger)index data:(id)data {
    @weakify(self);
    JTCInformationInputViewblockValidate validator = self.validators[index];
    @weakify(_validatorChaignBlock);
    validator(self_weak_,data,_validatorChaignBlock_weak_);
}
+(JTCInformationInputViewController *)createController {
    return [[UIStoryboard storyboardWithName:NSStringFromClass([JTCInformationInputViewController class]) bundle:nil] instantiateInitialViewController];
}

@end
