//
//  Created by zabih atashbarg on 9/27/18.
//  Copyright © 2018 Zabih. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 9.0, *)
open class ZAlertDialog : ZDialog {
    
    private let titleSize:CGFloat = 20
    private lazy var titleTextView:UITextView = {
        let view = UITextView()
        view.setDefaule()
        view.text = "Title"
        view.text = ""
//        view.textAlignment = .left
        view.textColor = titelTextColor
        view.font = .boldSystemFont(ofSize: titleSize)
        view.backgroundColor = UIColor.magenta
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let messageSize:CGFloat = 14
    private lazy var messageTextView:UITextView = {
        let view = UITextView()
        view.setDefaule()
        view.text = "Text of message"
        view.text = ""
        view.textAlignment = .left
        view.textColor = messageTextColor
        view.font = .systemFont(ofSize: messageSize)
        //        view.backgroundColor = .blue
        return view
    }()
    
    
    
    private let buttonsContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private lazy var okButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("OK", for: .normal)
        btn.addTarget(self, action: #selector(handleOkButton), for: .touchUpInside)
//        btn.backgroundColor = .lightGray
        return btn
    }()
    
    private lazy var cancelButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("لغو", for: .normal)
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        btn.isHidden = false
        //        btn.backgroundColor = .lightGray
        return btn
    }()
    
    
    private let alertContentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let titleContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.backgroundColor = .clear
        return view
    }()

    private let messageContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    
    public var titelTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    public var messageTextColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    
    //important change value here => change reset value ****
    private let cellId = "cellId"
    private let cellHeight: CGFloat = 45
    private let cellSpacingHeight:CGFloat = 5
    
    private var isCancelable = true
    private var onOkButtonClickListener:(() -> ())?
    private var onCancelButtonClickListener:(() -> Void?)?
    private var titleForOkButton:String?
    private var titleForCancelButton:String?
    private var isShowHeader = true
    private var isShowButtons = true
    
    private let buttonsHeight:CGFloat = 40
    private var buttonsHeightConstranit:NSLayoutConstraint?
    private let isDebug = true
    
    private var isScrollableTitleText = false
    
    
    
    
    
    public func setHiddenButtons(isHidden:Bool = true) -> ZAlertDialog {
        DispatchQueue.main.async {
            self.buttonsHeightConstranit?.constant = isHidden ? 0 : self.buttonsHeight
            self.buttonsContainerView.isHidden = isHidden
        }
        return self
    }
    
    
    public func setOkButton(_ title:String) -> ZAlertDialog {
        titleForOkButton = title
        okButton.setTitle(title, for: .normal)
        return self
    }
    

    public func setOkButton(_ title:String = "NOT_SET", onTapListener:@escaping ()-> ()) -> ZAlertDialog {
        if title != "NOT_SET" {
            self.titleForOkButton = title
            self.okButton.setTitle(title, for: .normal)
        }
        
        self.okButton.isHidden = false
        self.onOkButtonClickListener = onTapListener
        return self
    }
    
    public func setCancelButton(_ title:String) -> ZAlertDialog {
        titleForCancelButton = title
        cancelButton.isHidden = false
        cancelButton.setTitle(title, for: .normal)
        return self
    }
    
    public func setCancelButton(_ title:String,_ onTapListener:@escaping ()-> ()) -> ZAlertDialog {
        if title != "NOT_SET" {
            self.titleForCancelButton = title
            self.cancelButton.setTitle(title, for: .normal)
        }

        cancelButton.isHidden = false
        self.onCancelButtonClickListener = onTapListener
        return self
    }
    
    
    public func setTitle(_ title:String) -> ZAlertDialog {
        titleTextView.text = title
        return self
    }
    
    public func setMessage(_ message:String) -> ZAlertDialog {
        messageTextView.text = message
        return self
    }
    
    
    
    public func setHiddenCancelButton() -> ZAlertDialog {
        cancelButton.isHidden = true
        return self
    }
    
    
    
    
    
    
    override open func onSetupHeaderView(_ headerView: UIView) {}
    
    
    open func onSetupAlertContentView(_ contentView:UIView){}
    
    
    private var contentView:UIView?
    
    
    override open func onSetupContentView(_ contentView: UIView) {
        super.onSetupContentView(contentView)
//        print("------- ddd onSetupContentView in alert -------------")
        
        self.contentView = contentView
        onSetupAlertContentView(self.alertContentView)
        
        contentView.addSubview(scrollView)
        contentView.addSubview(buttonsContainerView)
        
        scrollView.addSubview(scrollContainerView)
        
        if isScrollableTitleText {
            scrollContainerView.addSubview(titleContainerView)
        } else {
            contentView.addSubview(titleContainerView)
        }
        
        scrollContainerView.addSubview(messageContainerView)
        scrollContainerView.addSubview(alertContentView)
        
        
//        for sub in scrollView.subviews {
//            print("--------------- ddd sub.subviews.count=", sub.subviews.count)
//        }
//        print("--- ddd onSetupContentView scrollView.subviews.count=", scrollView.subviews.count , "scrollView.subviews[0].subviews.count=" , scrollView.subviews[0].subviews.count)
        
        titleContainerView.addSubview(titleTextView)
        messageContainerView.addSubview(messageTextView)
        buttonsContainerView.addSubview(okButton)
        buttonsContainerView.addSubview(cancelButton)
        
        
        contentView.addConstraintsWithFormat("H:|[v0]|", views: scrollView)
        contentView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: buttonsContainerView)
        
        if isScrollableTitleText {
            contentView.addConstraintsWithFormat("V:|[v0]-5-[v1]-5-|", views: scrollView, buttonsContainerView)
        }
        else {
            contentView.addConstraintsWithFormat("V:|[v0]-5-[v1]-5-[v2]-5-|", views: titleContainerView, scrollView, buttonsContainerView)
        }
        
        
        contentView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: titleContainerView)
        contentView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: messageContainerView)
        contentView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: alertContentView)
        
        if isScrollableTitleText {//
            contentView.addConstraintsWithFormat("V:|-5-[v0]-4-[v1]-2-[v2]", views: titleContainerView, messageContainerView, alertContentView)
        }
        else {
            contentView.addConstraintsWithFormat("V:|-5-[v0]-2-[v1]", views: messageContainerView, alertContentView)
        }
        
        
        
        scrollHeightConstraint = NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: maxHeight)
        contentView.addConstraint(scrollHeightConstraint!)
        
        
        onSetupTitleContentView(titleContainerView: titleContainerView, titleTextView: titleTextView)
        onSetupMessageContentView(messageContainerView: messageContainerView, messageTextView: messageTextView)
        
        contentView.addConstraintsWithFormat("H:[v0]-16-[v1]-16-|", views: cancelButton, okButton)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: okButton)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: cancelButton)
        
        
        
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        
        buttonsHeightConstranit = NSLayoutConstraint(item: buttonsContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonsHeight)
        contentView.addConstraint(buttonsHeightConstranit!)
        
        
        
        if titleTextView.text.count == 0 {
            titleTextView.font = UIFont.systemFont(ofSize: 0)
        }else{
            titleTextView.font = UIFont.systemFont(ofSize: titleSize)
        }
        
        if messageTextView.text.count == 0 {
            messageTextView.font = UIFont.systemFont(ofSize: 0)
        }else {
            messageTextView.font = UIFont.systemFont(ofSize: messageSize)
        }
        
        
        if titleForOkButton == nil {
            let title = isRTL_ ?? false ? "تایید" : "OK"
            okButton.setTitle(title, for: .normal)
        }

//        if titleForCancelButton == nil {
//            let title = isRTL_ ?? false ? "لغو" : "Cancel"
//            cancelButton.setTitle(title, for: .normal)
//        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.okButton.isHidden = false
            self.cancelButton.isHidden = false
        }
        
        
    }
    
    
    
    
    
    open func onSetupTitleContentView(titleContainerView: UIView, titleTextView: UITextView) {
        if titleTextView.text != "" {
            titleContainerView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: titleTextView)
            titleContainerView.addConstraintsWithFormat("V:|-5-[v0]|", views: titleTextView)
        }
    }
    
    open func onSetupMessageContentView(messageContainerView: UIView, messageTextView: UITextView) {
        messageContainerView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: messageTextView)
        messageContainerView.addConstraintsWithFormat("V:|-5-[v0]|", views: messageTextView)
    }
    
    
    open func onSetupTextContainerView(textContainerView: UIView, titleTextView: UITextView, messageTextView: UITextView) {
        
        textContainerView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: messageTextView)
        
        if titleTextView.text == "" {
            textContainerView.addConstraintsWithFormat("V:|-5-[v0]|", views: messageTextView)
        }else {
            textContainerView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: titleTextView)
            textContainerView.addConstraintsWithFormat("V:|-5-[v0]-2-[v1]|", views: titleTextView, messageTextView)
        }
        
//        let titleHeight = titleTextView.frame
//        let messageHeight = messageTextView.frame
//        print("---- dddd6 111 --- titleHeight.frmae=", titleHeight, "messageHeight=", messageHeight)
    }
    
    
    
    
    
    
    
    
    private lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .red
        sv.backgroundColor = .clear
        return sv
    }()
    
    private lazy var scrollContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.backgroundColor = .clear
        return view
    }()
    
    private var scrollHeightConstraint:NSLayoutConstraint?
    private var subLayoutCount = 0
    
    
    //**
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("------ ddd6 -------- viewDidLayoutSubviews ------------------***")
        subLayoutCount += 1
        view.layoutIfNeeded()
        alertContentView.layoutIfNeeded()
        titleContainerView.layoutIfNeeded()
        messageContainerView.layoutIfNeeded()
        
        //
//        print("--------- ddd6 ----------------------------------------------***")
//        let titleMessageHeight = titleTextView.frame.height + messageTextView.frame.height + 7//margin
        
        updateScrollViewContentSize(scrollView, bottomMargin: 0, isDelay: false)
        scrollHeightConstraint?.constant = scrollView.contentSize.height
//        print(isDebug,"----- ddd6 afterUpdateScrollView.frame=",scrollView.frame, "contentSize=",scrollView.contentSize)
        
//        let allAlertContentHeight = scrollView.contentSize.height
//        print(isDebug,"---- ddd6 ---- 111 titleMessageHeight=", titleMessageHeight, "allHeiht=", allAlertContentHeight , "  maxHeight=",maxHeight)
        
        updateBottomConstraint()
        
        if rootDialogHeight > maxHeight {
            let titleHeight = isScrollableTitleText ? 0 : titleContainerView.frame.height
            scrollHeightConstraint?.constant = maxHeight - rootHeaderHeight - titleHeight
            updateBottomConstraint()
        }
        
        
//        print(isDebug,"---- ddd6 ---- 222 scrollHeightConstraint=",scrollHeightConstraint?.constant ?? "-", "maxHeight=",maxHeight)
        
//        let title = titleTextView.frame
//        let message = messageTextView.frame
//        print(isDebug,"-------- dddd6 222 Subviews ----- count=",subLayoutCount, "frmae=", title, message, "scroll",scrollView.frame ,"alertContent=",alertContentView.frame,"titleView=",titleContainerView.frame, "contentView",contentView?.frame ?? "0", "rootDialog=",rootDialogView.frame, rootDialogHeight, rootHeaderHeight)
//        let _ = ""
        
    }//
    

    
    
    
    
    override open func onDismissDialog() {
        if isOkButtonClick {
            self.onOkButtonClickListener?()
        }
        if isCancelButtonClick {
            self.onCancelButtonClickListener?()
        }
    }
    
    
    
    override open func onResetAllValues() {
        super.onResetAllValues()

        cancelId = 0
        isOkButtonClick = false
        isCancelButtonClick = false

        onOkButtonClickListener = nil
        onCancelButtonClickListener = nil

        titleForOkButton = nil
        titleForCancelButton = nil

        isCancelable = true
        isShowHeader = true
        isShowButtons = true
    }
    
    
    
    private var cancelId = 0
    private var isOkButtonClick = false
    private var isCancelButtonClick = false
    
    
    public func handleDismiss(_ cancelId: Int){
//        print(isDebug,"---- ddd handleDismiss ",cancelId,"isOkButtonClick=",isOkButtonClick)
        self.cancelId = cancelId
//        print(isDebug,"---- ddd alert isKeyboardShowing",self.isKeyboardShowing)
        dismissDialog()
    }
    
    
    private func handleShowDialogConform(_ cancelId: Int){
//        print(isDebug,"---- ddd handleShowDialogConform")
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            //            self.rootDialogView.alpha = 1
            self.cancelId = cancelId
            
        }, completion: nil)
    }
    
    @objc private func handleOkButton(){
//        print(isDebug,"---- ddd handleOkButton")
        self.isOkButtonClick = true
        self.isCancelButtonClick = false
        self.handleDismiss(self.cancelId)
    }
    
    @objc private func handleCancelButton(){
//        print(isDebug,"---- ddd handleCancelButton")
        self.isCancelButtonClick = true
        self.isOkButtonClick = false
        handleDismiss(cancelId)
    }
    
    
}









