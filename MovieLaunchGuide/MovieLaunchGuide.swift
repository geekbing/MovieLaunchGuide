//
//  MovieLaunchGuide.swift
//  MovieLaunchGuide
//
//  Created by Bing on 7/11/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class MovieLaunchGuide: UIViewController
{
    // 集合试图
    var collectionView: UICollectionView!
    
    // 引导图片
    var guideImages: [UIImage]
    
    // 引导视频
    var guideMoviePaths: [String]
    
    // 引导视频播放结束后的闭包
    var playFinished: (() -> ())
    
    // 页控制器
    var pageControl: UIPageControl!

    // 视频是否播放完毕
    private var isMovieFinished = false
    
    // 构造方法
    init(guideImages: [UIImage], guideMoviePaths: [String], playFinished: ()->())
    {
        self.guideImages = guideImages
        self.guideMoviePaths = guideMoviePaths
        self.playFinished = playFinished
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.mainScreen().bounds.size
        
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        collectionView.registerClass(MovieLaunchGuideCell.classForCoder(), forCellWithReuseIdentifier: "MovieLaunchGuideCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.pagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // 初始化页控件
        let width: CGFloat = 120.0
        let height: CGFloat = 30.0
        let x: CGFloat = (UIScreen.mainScreen().bounds.size.width - width) * 0.5
        let y: CGFloat =  UIScreen.mainScreen().bounds.size.height - 30 - 20
        pageControl = UIPageControl(frame: CGRect(x: x, y: y, width: width, height: height))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        view.addSubview(pageControl)
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: .finishedPlay, name: "PlayFinishedNotify", object: nil)
    }
    
    func finishedPlay()
    {
        isMovieFinished = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        pageControl.numberOfPages = guideImages.count
    }
    
    deinit
    {
        pageControl.removeFromSuperview()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let finishedPlay = #selector(MovieLaunchGuide.finishedPlay)
}

extension MovieLaunchGuide: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return guideMoviePaths.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieLaunchGuideCell", forIndexPath: indexPath) as! MovieLaunchGuideCell
        
        cell.coverImage = guideImages[indexPath.item]
        cell.moviePath = guideMoviePaths[indexPath.item]

        return cell
    }
}

extension MovieLaunchGuide: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.item ==  guideMoviePaths.count - 1 && isMovieFinished
        {
            // 执行回调
            playFinished()
        }
    }
}

extension MovieLaunchGuide: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let page = Int(scrollView.contentOffset.x / collectionView!.bounds.width + 0.5)
        pageControl.currentPage = page
    }
}