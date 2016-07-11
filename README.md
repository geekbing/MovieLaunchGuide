# MovieLaunchGuide
MovieLaunchGuide是一个视频动画启动引导页Swift项目

###效果如下：

![image](https://github.com/geekbing/MovieLaunchGuide/blob/master/MovieLaunchGuide.gif)

###使用方式：
<pre><code>// 配置本地视频的封面图片和视频路径
var images = [UIImage]()
var paths = [String]()
for i in 0..<4
{
	images.append(UIImage(named: "guide\(i)")!)
	paths.append(NSBundle.mainBundle().pathForResource("guide\(i)", ofType: "mp4")!)
}
        
window = UIWindow(frame: UIScreen.mainScreen().bounds)
window?.backgroundColor = UIColor.whiteColor()
window?.rootViewController = MovieLaunchGuide(guideImages: images, guideMoviePaths: paths, playFinished: { 
	[unowned self] in
	self.window?.rootViewController = UINavigationController(rootViewController: Main())
})
window?.makeKeyAndVisible()
</code></pre>