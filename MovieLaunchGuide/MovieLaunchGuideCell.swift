//
//  MovieLaunchGuideCell.swift
//  MovieLaunchGuide
//
//  Created by Bing on 7/11/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MediaPlayer

class MovieLaunchGuideCell: UICollectionViewCell
{
    var coverImage: UIImage?
    {
        didSet
        {
            if let _ = coverImage
            {
                imageView.image = coverImage
            }
        }
    }
    var moviePath: String?
    {
        didSet
        {
            if let path = moviePath
            {
                moviePlayer.contentURL = NSURL(fileURLWithPath: path, isDirectory: false)
                moviePlayer.prepareToPlay()
            }
        }
    }
    
    private lazy var imageView : UIImageView =
    {
        let imageView = UIImageView(frame:self.moviePlayer.view.bounds)
        return imageView
    }()
    
    private lazy var moviePlayer : MPMoviePlayerController =
    {
        let player = MPMoviePlayerController()
        player.view.frame = self.contentView.bounds
        // 设置自动播放
        player.shouldAutoplay = true
        // 设置源类型
        player.movieSourceType = .File
        // 取消下面的控制视图: 快进/暂停等...
        player.controlStyle = .None
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .playerDisplayChange, name: MPMoviePlayerReadyForDisplayDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .playFinished, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        return player
        
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        // 将播放器和封面添加到视图
        self.contentView.addSubview(moviePlayer.view)
        moviePlayer.view.addSubview(imageView)
    }
    
    
    func playerDisplayChange()
    {
        if moviePlayer.readyForDisplay
        {
            moviePlayer.backgroundView.addSubview(imageView)
        }
    }
    
    func playFinished()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("PlayFinishedNotify", object: nil)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

private extension Selector
{
    static let playerDisplayChange = #selector(MovieLaunchGuideCell.playerDisplayChange)
    static let playFinished = #selector(MovieLaunchGuideCell.playFinished)
}