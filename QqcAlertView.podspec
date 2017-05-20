Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "QqcAlertView"
  s.version      = "1.0.0"
  s.summary      = "QqcAlertView"
  s.homepage     = "https://github.com/xukiki/QqcAlertView"
  s.source       = { :git => "https://github.com/xukiki/QqcAlertView.git", :tag => "#{s.version}" }
  
  s.source_files  = ["QqcAlertView/*.{h,m}"]
  s.dependency "QqcModelPanel"

  
end
