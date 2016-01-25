Pod::Spec.new do |s|
  s.author              = { 'MiPassport' => 'mipassport@mi.com' }
  s.homepage            = 'http://mi.com'
  s.summary             = "小米账号授权SDK"
  s.name                = "MiPassport"
  s.version             = "1.0.0"
  s.platform            = :ios, "7.0"
  s.resource            = 'MiPassport/sdk/SDK/MiPassport.bundle'
  s.source              = { :git => "https://github.com/VianPan/MiPassport.git", :tag => "1.0.0" }
  s.source_files        = 'MiPassport/sdk/**/*.{h,m}'
  s.vendored_libraries  = 'MiPassport/sdk/SDK/MiPassport.framework'
  s.frameworks          = 'UIKit', 'Foundation', 'CoreGraphics'
  s.license             = { :type => 'LGPL', :text => <<-LICENSE
                                                   ® 1998 - 2014 Tencent All Rights Reserved.
                                                   LICENSE
                          }
end
