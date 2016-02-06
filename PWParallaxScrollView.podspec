Pod::Spec.new do |s|
  s.name         = "PWParallaxScrollView"
  s.version      = "1.2.0"
  s.summary      = "PWParallaxScrollView is a library for creating sliding menus with parallax effect inspired by the WWF app"
  s.homepage     = "http://www.github.com/wpsteak/PWParallaxScrollView"
  s.screenshots  = "https://raw.githubusercontent.com/wpsteak/PWParallaxScrollView/master/screenshot.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "wpsteak" => "wpsteak@gmail.com" }
  s.source       = {
    :git => "https://github.com/wpsteak/PWParallaxScrollView.git",
    :tag => s.version
  }
  s.source_files = 'PWParallaxScrollView/*.{h,m}'
  s.requires_arc = true

  s.subspec 'ObjC' do |ss|
    ss.source_files = '*.{h,m}'
  	ss.public_header_files = '*.h'
  end

  s.subspec 'Swift' do |ss|
  	ss.ios.deployment_target = '8.0'
    ss.source_files = '*.swift'
  end


end
