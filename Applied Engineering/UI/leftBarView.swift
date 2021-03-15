//
//  leftBarView.swift
//  Applied Engineering
//
//  Created by Richard Wei on 3/7/21.
//

import Foundation
import UIKit

class leftBarViewController : UIViewController{
    
    internal var topView : UIView = UIView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        renderTopView();
        renderList();
        
        self.view.backgroundColor = .cyan;
    }
    
    private func renderTopView(){
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.height / 8));
        
        topView.backgroundColor = .brown;
        
        self.view.addSubview(topView);
    }
    
    private func renderList(){
        
    }
}
