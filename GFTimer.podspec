Pod::Spec.new do |s|
  s.name         = 'GFTimer'
  s.summary      = 'A timer which use GCD to implement it.'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'linguofang' => '913868456@qq.com' }
  s.homepage     = 'https://github.com/913868456/GCDTimer'
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => 'https://github.com/913868456/GCDTimer.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'GCDTimer/**/*.{h,m}'
  s.public_header_files = 'GCDTimer/**/*.{h}'

end
