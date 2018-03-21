Pod::Spec.new do |s|
  
  s.name         = "BSPKit"
  s.version      = "1.0.1"
  s.summary      = "Swift 不用官方SDK实现微信、支付宝支付."
  s.homepage     = "https://github.com/a1049145827/BSPKit"
  s.license      = "MIT"
  s.authors      = { "Bruce Liu" => "1049145827@qq.com"}
  
  s.platform     = :ios, "8.0"
  s.swift_version = "4.0"

  s.source       = { :git => "https://github.com/a1049145827/BSPKit.git", :tag => s.version }
  s.source_files = "BSPKit/*.swift"
  s.requires_arc = true

end