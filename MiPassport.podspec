Pod::Spec.new do |s|
  s.author                 = { 'MiPassport' => 'mipassport@mi.com' }
  s.homepage               = 'http://mi.com'
  s.summary                = "小米账号授权SDK"
  s.name                   = "MiPassport"
  s.version                = "1.0.3"
  s.platform               = :ios, "7.0"
  s.vendored_frameworks    = 'sdk/SDK/MiPassport.framework'
  s.resource               = 'sdk/SDK/MiPassport.bundle'
  s.source                 = { :git => "https://github.com/VianPan/MiPassport.git", :tag => "#{s.version}" }
  s.frameworks             = 'UIKit', 'Foundation', 'CoreGraphics'
  s.license                = { :type => 'LGPL', :text => <<-LICENSE
                                                   ® 1998 - 2016 XiaoMi All Rights Reserved.
                                                   LICENSE
                          }
end
