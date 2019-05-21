//
//  ViewController.swift
//  GuidePageHUD
//
//  Created by wubaolai on 2019/5/20.
//  Copyright © 2019 wubaolai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 静态引导页
        self.setStaticGuidePage()
    }

    func setStaticGuidePage() {
        let imageNameArray = ["guideImage1.jpg","guideImage2.jpg","guideImage3.jpg",]
        let guidePageView = GuidePageView.init(images: imageNameArray) {
            
        }
        
        guidePageView.startButton.setTitle("立即开启", for: .normal)
        self.view.addSubview(guidePageView)
    }
//
//    #pragma mark - 设置APP静态图片引导页
//    - (void)setStaticGuidePage {
//    NSArray *imageNameArray = @[@"guideImage1.jpg",@"guideImage2.jpg",@"guideImage3.jpg",@"guideImage4.jpg",@"guideImage5.jpg"];
//    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
//    guidePage.slideInto = YES;
//    [self.navigationController.view addSubview:guidePage];
//    }
}

