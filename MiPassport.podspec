Pod::Spec.new do |s|
  s.name         = "MiPassport"
  s.version      = "1.0.0"
  s.license      = "MIT"
  s.platform     = :ios, "7.0"
  s.resource  = "sdk/SDK/MiPassport.bundle"
  s.source       = { :git => "https://github.com/VianPan/MiPassport.git", :tag => "1.0.0" }
  s.source_files  = "sdk/SDK", "sdk/SDK/*.{h,m}"
  s.vendored_libraries = 'sdk/SDK/MiPassport.framework'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
end
