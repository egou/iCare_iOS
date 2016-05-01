//
//  IGRootViewController.h
//  Iggona
//
//  Created by porco on 15/12/17.
//  Copyright © 2015年 Porco. All rights reserved.
//

#import <UIKit/UIKit.h>

/**************************     app VC architecture      ************************/
/*                                                                              */
/*                                              (present)                       */
/*                     RootViewController  ----------------- MainVC             */
/*                       /             \                                        */
/*              (Child1)/      (Child2) \                                       */
/*                     /                 \                                      */
/*              firstLoadingVC            LoginVC                               */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

@interface IGRootViewController : UIViewController

@end
