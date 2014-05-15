//
//  JTCInformationInputViewController.h
//  PrimasDXII
//
//  Created by Tomohisa Takaoka on 5/13/14.
//
//

#import <UIKit/UIKit.h>
#import <SECoreTextView/SETextView.h>

@class JTCInformationInputViewController;
typedef void (^JTCInformationInputViewblockResultAndData)(BOOL result, id data);
typedef void (^JTCInformationInputViewAdditionalformat)(JTCInformationInputViewController*vc, SETextView * textView);
typedef void (^JTCInformationInputViewblockValidate)(JTCInformationInputViewController* vc,id data, JTCInformationInputViewblockResultAndData validationCompleted);

@interface JTCInformationInputViewController : UIViewController
@property (nonatomic, copy) NSString * originalText;
@property (nonatomic, copy) NSString * topTitle;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic, copy) JTCInformationInputViewblockResultAndData completed;
@property (nonatomic, copy) JTCInformationInputViewAdditionalformat viewFormatter;
@property (nonatomic) BOOL allowEnter;
@property NSString * legalCharactors;
@property NSArray * arrayNGWords;
@property (nonatomic, copy) JTCInformationInputViewblockValidate validation;
@property (nonatomic) NSArray * validators;
+(JTCInformationInputViewblockValidate)commonKatakanaValidator;
+(JTCInformationInputViewblockValidate)commonEmailValidator;

+(JTCInformationInputViewblockValidate)mistakenValidatorWithWrongDomain:(NSString*)wrong rightDomain:(NSString*)right appName:(NSString*)appName;

+(JTCInformationInputViewAdditionalformat) commonEmailTextFormatter;
+(JTCInformationInputViewAdditionalformat) commonPhoneNumberTextFormatter;
+(JTCInformationInputViewAdditionalformat) commonNameTextFormatter;
+(JTCInformationInputViewAdditionalformat) commonNameJPPhoneticTextFormatter;
@end
