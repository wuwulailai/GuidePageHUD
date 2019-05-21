//
//  GuidePageView.swift
//  GuidePageHUD
//
//  Created by wubaolai on 2019/5/20.
//  Copyright © 2019 wubaolai. All rights reserved.
//

import UIKit
import CHIPageControl

class GuidePageView: UIView {

    /// 右滑进入主题，default: false
    public var isSlipToHomeView: Bool = false
    
    /// 隐藏跳过按钮
    private var isSkipBtnHidden: Bool = false
    
    /// 隐藏立即体验按钮
    private var isStartBtnHidden: Bool = false
    
    /// 隐藏登录按钮
    private var isLoginBtnHidden: Bool = false
    
    /// 数据源
    private var imageArray: Array<String>?
    
    var startCompletion: (() -> ())?
    var loginCompletion: (() -> ())?
    let pageControlHeight: CGFloat = 40.0
    let startHeigth: CGFloat = 30.0
    let loginHeight: CGFloat = 40.0
    /// 是否正在做滑入动作
    private var isSliping: Bool = false
    
    // MARK: - life cycle
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 引导页
    ///
    /// - Parameters:
    ///   - frame: 引导页大小
    ///   - images: 引导页图片（gif/png/jpeg...）注意：gif图不可放在Assets中，否则加载不出来（建议引导页的图片都不要放在Assets文件中，因为使用imageName加载时，系统会缓存图片，造成内存暴增）
    ///   - isSkipBtnHidden: 是否隐藏跳过按钮
    ///   - isStartBtnHidden: 是否隐藏立即体验按钮
    ///   - loginCompletion: 登录回调
    ///   - startCompletion: 立即体验回调
    public convenience init(frame: CGRect = UIScreen.main.bounds,
                            images: Array<String>,
                            isSkipBtnHidden: Bool = true,
                            isStartBtnHidden: Bool = false,
                            isLoginBtnHidden: Bool = true,
                            loginCompletion: (() -> ())? = nil,
                            startCompletion: (() -> ())?) {
        self.init(frame: frame)
        
        self.imageArray       = images
        self.isSkipBtnHidden  = isSkipBtnHidden
        self.isStartBtnHidden = isStartBtnHidden
        self.isLoginBtnHidden = isLoginBtnHidden
        self.startCompletion  = startCompletion
        self.loginCompletion  = loginCompletion
        
        setupSubviews(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: - setup
    private func setupSubviews(frame: CGRect) {
        let size = UIScreen.main.bounds.size
        guideScrollView.frame = frame
        guideScrollView.contentSize = CGSize.init(width: frame.size.width * CGFloat(imageArray?.count ?? 0) + 50.0, height: frame.size.height)
        self.addSubview(guideScrollView)
        
        skipButton.frame = CGRect.init(x: size.width - 70.0 , y: 40.0, width: 50.0, height: 24.0)
        skipButton.isHidden = isSkipBtnHidden
        self.addSubview(skipButton)
        
        pageControl.frame = CGRect(x: 0.0, y: size.height - pageControlHeight, width: size.width, height: pageControlHeight)
        pageControl.numberOfPages = imageArray?.count ?? 0
        self.addSubview(pageControl)
        
        guard imageArray != nil, imageArray?.count ?? 0 > 0 else { return }
        for index in 0..<(imageArray?.count ?? 1) {
            let name        = imageArray![index]
            let imageFrame  = CGRect.init(x: size.width * CGFloat(index), y: 0.0, width: size.width, height: size.height)
            let filePath    = Bundle.main.path(forResource: name, ofType: nil) ?? ""
            let data: Data? = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath), options: Data.ReadingOptions.uncached)
            var view: UIView
            // 暂不支持gif，后续加上
//            let type = GifImageOperation.checkDataType(data: data)
//            if type == DataType.gif {   // gif
//                view = GifImageOperation.init(frame: imageFrame, gifData: data!)
//            } else {                    // 其它图片
                // Warning: 假如说图片是放在Assets中的，使用Bundle的方式加载不到，需要使用init(named:)方法加载。
                view = UIImageView(frame: imageFrame)
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
                (view as! UIImageView).image = (data != nil ? UIImage(data: data!) : UIImage.init(named: name))
//            }
            // 添加“立即体验”按钮和登录/注册按钮
            if imageArray?.last == name {
                view.isUserInteractionEnabled = true
                if !isStartBtnHidden {
                    let y = size.height - pageControlHeight - startHeigth
                    let width = size.width * 0.35
                    startButton.frame = CGRect.init(x: (size.width - width) * 0.5, y: y, width: width, height: startHeigth)
                    startButton.alpha = imageArray?.count == 1 ? 1.0 : 0.0
                    view.addSubview(startButton)
                }
                
                if !isLoginBtnHidden {
                    let y = size.height - pageControlHeight - startHeigth
                    let w = size.width * 0.6
                    logtinButton.frame = CGRect.init(x: (size.width - w) * 0.5, y: y - loginHeight - 20, width: w, height: loginHeight)
                    logtinButton.alpha = imageArray?.count == 1 ? 1.0 : 0.0
                    view.addSubview(logtinButton)
                }
            }
            guideScrollView.addSubview(view)
        }
    }
    
    /// 滚动条
    private lazy var guideScrollView: UIScrollView = {
        let view = UIScrollView();
        view.backgroundColor = UIColor.clear;
        view.bounces = false;
        view.isPagingEnabled = true;
        view.showsHorizontalScrollIndicator = false;
        view.delegate = self;
        return view
    }()
    
    /// 指示器
    public lazy var pageControl: CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo()
        pageControl.radius = 4
        pageControl.padding = 8
        pageControl.tintColor = .lightGray
        pageControl.currentPageTintColor = UIColor.init(red: 211.0, green: 176.0, blue: 114.0, alpha: 1)
        return pageControl
    }()
    
    /// 跳过按钮
    public lazy var skipButton: UIButton = {
        let skipButton = UIButton(type: .custom)
        skipButton.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        skipButton.layer.cornerRadius = 5.0
        skipButton.layer.masksToBounds = true
        skipButton.setTitle("跳 过", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.titleLabel?.sizeToFit()
        skipButton.addTarget(self, action: #selector(skipButtonTaped), for: .touchUpInside)
        return skipButton
    }()
    
    /// 登录注册按钮
    public lazy var logtinButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("注册/登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.sizeToFit()
        loginButton.backgroundColor = UIColor.init(red: 177.0/255.0, green: 126.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        loginButton.addTarget(self, action: #selector(loginButtonTaped), for: .touchUpInside)
        return loginButton
    }()
    
    /// 立即体验按钮
    public lazy var startButton: UIButton = {
        let startButton = UIButton(type: .custom)
        startButton.setTitle("随便看看 ＞", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        startButton.setTitleColor(UIColor.init(red: 177.0/255.0, green: 126.0/255.0, blue: 71.0/255.0, alpha: 1.0), for: .normal)
        startButton.titleLabel?.sizeToFit()
        startButton.addTarget(self, action: #selector(startButtonTaped), for: .touchUpInside)
        return startButton
    }()
    
    // MARK: - actions
    private func removeGuideViewFromSupview() {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /// 点击“跳过”按钮事件，立即退出引导页
    @objc private func skipButtonTaped() {
        if self.startCompletion != nil {
            self.startCompletion!()
        }
        self.removeGuideViewFromSupview()
    }
    
    /// 点击“立即体验”按钮事件，退出引导页
    @objc private func startButtonTaped() {
        if self.startCompletion != nil {
            self.startCompletion!()
        }
        self.removeGuideViewFromSupview()
    }
    
    /// 点击登录注册按钮
    @objc private func loginButtonTaped() {
        if self.loginCompletion != nil {
            self.loginCompletion!()
        }
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1.5) {
            DispatchQueue.main.async {
                self.removeGuideViewFromSupview()
            }
        }
    }
    
}

// MARK: - <UIScrollViewDelegate>
extension GuidePageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isSlipToHomeView else { return }
        guard isSliping == false else { return }
        
        let totalWidth = UIScreen.main.bounds.size.width * CGFloat((imageArray?.count ?? 1) - 1)
        let offsetX = scrollView.contentOffset.x - totalWidth
        if offsetX > 30 {
            isSliping = true
            UIView.animate(withDuration: 1.0, animations: {
                self.guideScrollView.alpha = 0.0
                var frame = self.guideScrollView.frame
                frame.origin.x = -UIScreen.main.bounds.size.width
                self.guideScrollView.frame = frame
            }) { (_) in
                self.isSliping = false
                self.startButtonTaped()
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        // 设置指示器
        pageControl.progress = Double.init(page)
        
        // 显示“立即体验”按钮
        if !isStartBtnHidden, (imageArray?.count ?? 0) - 1 == page {
            UIView.animate(withDuration: 1.0, animations: {
                self.startButton.alpha  = 1.0
                self.logtinButton.alpha = 1.0
            })
        }
    }
}
