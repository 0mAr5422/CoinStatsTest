//
//  ImageAndVideoViewController.swift
//  CoinStatsTest
//
//  Created by Omar Nader on April/25/22.
//

import UIKit
import WebKit


final class ImageAndVideoViewController : UIViewController , WKUIDelegate {
    private var scrollView : UIScrollView! = nil
    private var imageView : UIImageView! = nil
    
    private var imageURL : String?
    private var videoURL : String?
    private var webView: WKWebView!
    init(with imageURL : String? , videoURL : String?) {
        self.imageURL = imageURL
        self.videoURL = videoURL
        
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("failed to initalize ImageAndVideoViewController with coder")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let imageURL = imageURL {
            configureScrollView()
            
            
            imageView.setImageFromDownloadURL(from: imageURL)
            
            
            return
        }
        if let videoURL = videoURL {
            guard let url = URL(string: videoURL) else {return}
            
            let myRequest = URLRequest(url: url)
            
            webView.load(myRequest)
        }
        
        
    }
    //MARK: webView Configuration
    override func loadView() {
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          webView.uiDelegate = self
          view = webView
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        if let _ = imageURL {
            imageView.alpha = 1
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        if let _ = imageURL {
            imageView.alpha = 0
        }
    }
    
}
extension ImageAndVideoViewController {
    
    private func configureScrollView(){
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        configureImageView()
    }
    
    private func configureImageView(){
        imageView = UIImageView(frame: scrollView.bounds)
        scrollView.addSubview(imageView)
        imageView.autoresizingMask = [.flexibleWidth ,. flexibleHeight]
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        
    }
}
extension ImageAndVideoViewController : UIScrollViewDelegate {
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
