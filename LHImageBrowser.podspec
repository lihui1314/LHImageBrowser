#
# Be sure to run `pod lib lint LHImageBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LHImageBrowser'
  s.version          = '1.0.3'
  s.summary          = 'LHImageBrowser'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  LHImageBrowser 图片浏览器 类似朋友圈
                       DESC

  s.homepage         = 'https://github.com/lihui1314/LHImageBrowser.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lihui1314' => '15652628678@163.com' }
  s.source           = { :git => 'https://github.com/lihui1314/LHImageBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LHImageBrowser/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LHImageBrowser' => ['LHImageBrowser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
