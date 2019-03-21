//
//  VideoViewController.swift
//  SuperHero
//
//  Created by Gonzalo Giampietri on 06/03/2019.
//  Copyright © 2019 Gonzalo Giampietri. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: UIViewController  {

    @IBOutlet weak var videoView: UIView!
    let videoPlayerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
            pintall()
    }
    
    private func pintall(){
        
        guard let path = Bundle.main.path(forResource: "tr1", ofType:"mp4") else {
            print("Trailer not found")
            return
        }
        
        let width = videoView.frame.size.width
        let height = videoView.frame.size.height
        
        let frame = CGRect(x: 0 , y: height * 0.30, width: width , height: height * 0.25)
        
        videoPlayerViewController.view.frame = frame
        
        videoPlayerViewController.player = AVPlayer(url: URL(fileURLWithPath: path))
        
        videoView.addSubview(videoPlayerViewController.view)
        
        //videoPlayerViewController.view.frame = videoView.bounds
        //videoPlayerViewController.player?.play()
        
    }
    
}
