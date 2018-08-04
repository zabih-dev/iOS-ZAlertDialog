//
//  Created by zabih atashbarg on 9/27/18.
//  Copyright © 2018 Zabih. All rights reserved.
//

import UIKit


public enum ZDialogPositionStyle {
    case center
    case bottom
}


@available(iOS 9.0, *)
open class ZDialog : UIViewController {
    //for later => add animation type for show and dismiss
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        checkLayoutDirection()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onSetupHeaderView(rootHeaderView)
        onSetupContentView(contentView)
        
        
        rootSetupViews()
        checkLayoutDirection()
        checkTextAligments(view: rootDialogView, isRTL: self.isRTL)
//        print(isDebug,"----- dddd ccc ",currentController ?? "")
    }
    
    
    
    
    open func checkLayoutDirection() {
        if let isRTL = isRTL {
            UIView.appearance().semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        }
    }
    
    
    
    open func checkTextAligments(view: UIView, isRTL:Bool?) {
        guard let isRTL = isRTL else {
            return
        }
        if let label = view as? UILabel {
            label.textAlignment = isRTL ? .right : .left
        }
        else if let text = view as? UITextView {
            text.textAlignment = isRTL ? .right : .left
        }
        else if let field = view as? UITextField {
            field.textAlignment = isRTL ? .right : .left
        }
        else if view.subviews.count > 0 {
            for sub in view.subviews {
                if sub.subviews.count > 0 {
                    checkTextAligments(view: sub, isRTL: isRTL)
                }
                else {
                    if let label = sub as? UILabel {
                        label.textAlignment = isRTL ? .right : .left
                    }
                    else if let text = sub as? UITextView {
                        text.textAlignment = isRTL ? .right : .left
                    }
                    else if let field = sub as? UITextField {
                        field.textAlignment = isRTL ? .right : .left
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        rootDialogView.layoutIfNeeded()
//        print(isDebug,"---------- ddd6 Subviews 000 -----",rootDialogView.frame,"HeightOfSubviews", hhh, "header",rootHeaderView.frame)
        
//        if rootDialogView.frame.height > maxHeight {
//
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.11) {
//            print("--- dddd6 --------------------------- async ---- frame=",self.rootDialogView.frame,"view=",self.view.frame)
//        }
    }
    
    
    
    public func showDialog(_ vc:UIViewController) {
        DispatchQueue.main.async {
            print("---- showDialog currentController=",vc)
            let vc2 = self
            vc2.providesPresentationContextTransitionStyle = true
            vc2.definesPresentationContext = true
            vc2.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc2.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.present(vc2, animated: false, completion: nil)
        }
    }
    
    
    
    
    private let dummyButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("button title", for: .normal)
        btn.backgroundColor = .green
        btn.backgroundColor = .clear
        btn.isHidden = false
        btn.titleLabel?.font = .systemFont(ofSize: 1)
        return btn
    }()
    
    private var isRefreshUI:Bool = false {
        didSet{
            let title = isRefreshUI ? "." : ","
            dummyButton.setTitle(title, for: .normal)
        }
    }
    
    
    private func addDummyButton(){
        view.addSubview(dummyButton)
        addConstraintsWithFormat("H:|[v0]|", views: dummyButton)
        addConstraintsWithFormat("V:|[v0(0)]", views: dummyButton)
    }
    
    private func refreshUI() {
        isRefreshUI = !isRefreshUI
    }
    
    
    
    
    private lazy var blackView = UIView()
    
    
    private lazy var rootHeaderView:UIView = {
        let view = UIView()
        return view
    }()
    
    
    public lazy var rootDialogView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.cornerRadius = 25
        return view
    }()
    
    
    private lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    //important change value here => change reset value ****
    public var bottomConstraint: NSLayoutConstraint?
    private var isCancelable = true
    private var onDismissListener:(() -> Void?)?
    private var isShowHeader = true
    
    private var keyboardFrame:CGRect?
    public var isKeyboardShowing = false
    public var bottonSpacing:CGFloat?
    
    private var positionStyle = ZDialogPositionStyle.center
    
    private var headerView:UIView?
    private let isDebug = true
    private var isRTL:Bool?
    public var isRTL_:Bool? {get {return self.isRTL}}
    
    
    //
    private var percentOfMaxHeight:CGFloat = 70
    public var maxHeight:CGFloat {get {return (percentOfMaxHeight * self.view.frame.height) / 100 }}
    public var rootDialogHeight:CGFloat {get {return rootDialogView.frame.height }}
    public var rootHeaderHeight:CGFloat {get {return rootHeaderView.frame.height }}
    
    
    
    
    
    @discardableResult
    open func setRTL(_ isRTL:Bool) -> ZDialog {
        self.isRTL = isRTL
        return self
    }
    
    ///max percent up to 80 => default is 70
    @discardableResult
    public func setPercentOnMaxHeight(_ percentOfMaxHeight:CGFloat) -> ZDialog {
        self.percentOfMaxHeight = percentOfMaxHeight > 80 ? 80 : percentOfMaxHeight
        return self
    }
    
    
    @discardableResult
    open func setPositionStyle(_ style:ZDialogPositionStyle) -> ZDialog {
        self.positionStyle = style
        return self
    }
    
    @discardableResult
    open func setOnDismissListener(_ value:@escaping ()-> ()) -> ZDialog {
        self.onDismissListener = value
        return self
    }
    
    
    @discardableResult
    open func setCancelable(_ isCancelable:Bool) -> ZDialog {
        self.isCancelable = isCancelable
        return self
    }
    
    
    @discardableResult
    open func setHiddenHeaderView() -> ZDialog {
        isShowHeader = false
        return self
    }
    
    
    @discardableResult
    open func setHeaderView(_ headerView:UIView) -> ZDialog {
        self.headerView = headerView
        return self
    }
    
    
    @discardableResult
    open func setDialogCornerRadius(_ radius:CGFloat) -> ZDialog {
        rootDialogView.cornerRadius = radius
        return self
    }
    
    
    public var currentController:UIViewController?
    
    
    
    
    
    
    open func onSetupContentView(_ contentView:UIView){}
    
    open func onSetupHeaderView(_ headerView:UIView){}
    
    open func onMeasureDialogWidth() ->CGFloat {
        var dialogWidth:CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            dialogWidth = 600
        }else if self.view.frame.width > 375 {
            dialogWidth = 350
        }else {
            dialogWidth = 280
        }
        return dialogWidth
    }
    
    
    open func onMeasureBottomConstrant(window:UIView, rootDialogView:UIView) ->CGFloat {
        if positionStyle == .center {
            let centerY = window.frame.height / 2
            contentView.layoutIfNeeded()
            rootDialogView.layoutIfNeeded()
            let constant = centerY - (rootDialogView.frame.height/2)
            
//            print(isDebug,"------- ddd6 onMeasureBottomConstrant centerY=", centerY, "rootDialogView=",rootDialogView.frame,"constant=" ,constant)
            
            //        rootDialogView.frame.origin.y = 0
            //        rootDialogView.alpha = 0
            
            return constant
        }
        
        return 0
    }
    
    
    open func onResetAllValues(){
        onDismissListener = nil
        isCancelable = true
        isShowHeader = true
        
        bottomConstraint?.constant = 0
//        view.frame.origin.y = 0
    }
    
    
    
    open func updateBottomConstraint(){
        if isKeyboardShowing {
            updateOriginY()
            return
        }
        
        rootDialogView.layoutIfNeeded()
//        print(isDebug,"----------- ddd6 updateBottomConstraint rootDialogView=" , rootDialogView.frame ,"isKeyboard=",isKeyboardShowing)
        
        bottomConstraint?.constant = -onMeasureBottomConstrant(window: view, rootDialogView: rootDialogView)
    }
    
    
    
    
    private func rootSetupViews(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification2), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification2), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        
        blackView.isUserInteractionEnabled = true
        blackView.backgroundColor = .red
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissBlackView)))
        
        
        
        view.addSubview(blackView)
        view.addSubview(rootDialogView)
        rootDialogView.addSubview(rootHeaderView)
        rootDialogView.addSubview(contentView)
        
        
        let dialogWidth = onMeasureDialogWidth()
        
        addConstraintsWithFormat("V:[v0]", views: rootDialogView)
        addConstraintsWithFormat("H:[v0(\(dialogWidth))]", views: rootDialogView)
        //
        self.rootDialogView.frame.origin.y = self.view.frame.height//*
        
        
        addConstraintsWithFormat("H:|[v0]|", views: contentView)
        
        if isShowHeader {
            addConstraintsWithFormat("H:|[v0]|", views: rootHeaderView)
            addConstraintsWithFormat("V:|[v0][v1]|", views: rootHeaderView, contentView)
            
            if let headerView = headerView , rootHeaderView.subviews.count == 0 {
                rootHeaderView.addSubview(headerView)
                addConstraintsWithFormat("H:|[v0]|", views: headerView)
                addConstraintsWithFormat("V:|[v0]|", views: headerView)
            }
            
            
        }else {
            addConstraintsWithFormat("V:|[v0]|", views: contentView)
        }
        
        
        view.addConstraint(NSLayoutConstraint(item: rootDialogView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        let constant = onMeasureBottomConstrant(window: view, rootDialogView: rootDialogView)
        
        bottomConstraint = NSLayoutConstraint(item: rootDialogView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -constant)
        view.addConstraint(bottomConstraint!)
        
        
        view.isUserInteractionEnabled = true
        view.endEditing(true)
//        view.setDefaultFont(view)
        view.backgroundColor = .clear//-----
        view.alpha = 1
        blackView.frame = view.frame
        blackView.alpha = 0
        rootDialogView.alpha = 1//

        
        UIView.animate(withDuration: 0.33, animations: {
            self.blackView.alpha = 1
        })
        onLoadShowDialogAnimation(rootDialogView)
        
        
//        UIView.animate(withDuration: 0.35, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//            self.blackView.alpha = 1
//            self.onAnimationShowDialog(self.rootDialogView)
//
////            self.refreshUI()
//            print("--- ddd frame.height=",self.rootDialogView.frame.height)
//            //                self.rootDialogView.frame.origin.y = 0//
//
//        }, completion: { (completed) in
//        })
    }
    
    
    
    ///anim move bottom to top
    private func ahowAnimationMoveBottom2Top(){
        rootDialogView.alpha = 0
        rootDialogView.frame.origin.y = rootDialogView.frame.origin.y + 250
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.rootDialogView.alpha = 1
            self.rootDialogView.frame.origin.y = self.rootDialogView.frame.origin.y - 250
        })
    }
    
    
    private func showScaleInAnimation(){
        self.rootDialogView.alpha = 0
        self.rootDialogView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.35) {
            self.blackView.alpha = 1
            self.rootDialogView.alpha = 1
            self.rootDialogView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    private func showScaleOutAnimation(){
        UIView.animate(withDuration: 0.35, animations: {
            self.view.alpha = 0
            self.blackView.alpha = 0
            self.rootDialogView.alpha = 0
            self.rootDialogView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }) { (finished) in
        }
    }
    
    //----------
    
    
    
    
    
    open func onLoadShowDialogAnimation(_ rootDialogView:UIView){
        showScaleInAnimation()
    }
    
    ///return duration of animation
    open func onLoadDismissAnimation(_ rootDialogView:UIView) -> TimeInterval {
        showScaleOutAnimation()
        return 0.33
    }
    
    
    
    
    @objc private func handleDismissBlackView() {
        if isCancelable {
            bottonSpacing = bottomConstraint?.constant
//            print(isDebug,"---- ddd isKeyboardShowing 111",self.isKeyboardShowing, "bottonSpacing" , bottonSpacing ?? 0)
            
            NotificationCenter.default.removeObserver(self)
            
            UIView.animate(withDuration: 0.33, animations: {
                self.blackView.alpha = 0
            })
            
            handleDismiss(animationDuration: onLoadDismissAnimation(self.rootDialogView))
            
        }
    }
    
    
    
    private func handleDismiss(animationDuration:TimeInterval){
//        print("----- ddd6 handleDismiss time=",animationDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration) {
//            print(self.isDebug,"----- dddd6 ccc dismiss",self.currentController ?? "")
            
            self.dismiss(animated: false, completion: {
                
                self.onDismissListener?()
                //
                self.onDismissDialog()
                
                self.onResetAllValues()
                
                NotificationCenter.default.removeObserver(self)
            })
        }
    }
    
    
    public func dismissDialog(){
        handleDismiss(animationDuration: onLoadDismissAnimation(rootDialogView))
    }
    
    
    open func onDismissDialog(){}
    
    
    
    @objc private func handleKeyboardNotification2(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            self.rootDialogView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            
            keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            isKeyboardShowing = notification.name == UIWindow.keyboardWillShowNotification
            
            updateOriginY()
            
        }
    }
    
    
    
    
    open func updateOriginY(){
        if let keyboardFrame = keyboardFrame {
            
            let dialogHeight = rootDialogView.frame.height
            let h1 = dialogHeight + keyboardFrame.height + 30
//            let dialogY = ZApp.height - h1
            let dialogY = self.view.frame.height - h1//*
            
//            print(isDebug,"---- dddd notification 000 rootDialogView.frame=",self.rootDialogView.frame, isKeyboardShowing)
//            print(isDebug,"---- dddd notification keyboardFrame=",keyboardFrame , "h1",h1,"dialogY=",dialogY)
            
            self.rootDialogView.frame.origin.y = isKeyboardShowing ? dialogY : 0
//            print(isDebug,"---- dddd notification rootDialogView.y=",rootDialogView.frame.origin.y)
        }
    }
    
    
    
    //
    public func updateScrollViewContentSize(_ scrollView:UIScrollView, bottomMargin:CGFloat=0, isDelay:Bool){
        if isDelay {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
                self.updateScrollViewContentSize(scrollView, bottomMargin: bottomMargin)
            }
        }
        else {
            updateScrollViewContentSize(scrollView, bottomMargin: bottomMargin)
        }
        
    }
    
    public func updateScrollViewContentSize(_ scrollView:UIScrollView, bottomMargin:CGFloat=0){
        let scrollView2 = scrollView

        if scrollView2.subviews.count == 0 {
            return
        }
        
        //for test => not
        scrollView2.contentSize.width = scrollView2.frame.width
        let containerView = scrollView2.subviews[0]
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView2.frame.width, height: scrollView2.frame.height)
        containerView.layoutIfNeeded()
        
        var findView = UIView()
        
        for sub in scrollView2.subviews {
            if sub.subviews.count > 0 {
                findView = sub
                break
            }
        }
        
        
        let contentHeight =  getHeightOfSubviews(findView)
        
        scrollView2.contentSize.height = contentHeight + bottomMargin
        //
        let width = scrollView2.frame.width
        let height = contentHeight
        scrollView2.subviews[0].frame = CGRect(x: 0, y: 0, width: width, height: height)
//        print("----- ddd updateScrollViewContentSize contentHeight=",contentHeight, "scrollView2.subviews.count", scrollView2.subviews.count, "scrollView2.subviews[0].subviews.count=", scrollView2.subviews[0].subviews.count)
        self.refreshUI()
    }
    
    
    
    
    
    public func getHeightOfSubviews(_ forView:UIView)->CGFloat {
        var contentHeight:CGFloat = 0
        var frames:[ZFrame] = []
        
        for view in forView.subviews {
            if let collectionView = view as? UICollectionView {
                let height = collectionView.getHeightOfContent()
                contentHeight += height
                frames.append(ZFrame(originY: collectionView.frame.origin.y, height: height))
            }else {
                contentHeight += view.frame.height
                frames.append(ZFrame(originY: view.frame.origin.y, height: view.frame.height))
            }
        }
        
        let sortedFrames = frames.sorted(by: { $0.originY < $1.originY })
        
        var margins:CGFloat = 0
        for index in 0..<sortedFrames.count {
            if index == 0 {
                margins += sortedFrames[0].originY
                continue
            }
            margins += (sortedFrames[index].originY - sortedFrames[index-1].originY) - sortedFrames[index-1].height
        }
        
        contentHeight += margins
        
        return contentHeight
    }
    
    
    
    private struct ZFrame {
        let originY:CGFloat
        let height:CGFloat
    }
    
    
}







    
    








