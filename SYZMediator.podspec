#
# Be sure to run `pod lib lint SYZMediator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SYZMediator'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SYZMediator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sundasheng1985/SYZMediator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sundasheng1985' => '641569408@qq.com' }
  s.source           = { :git => 'https://github.com/sundasheng1985/SYZMediator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  #s.default_subspec = 'source'
  s.subspec 'source' do |source|
      source.source_files = 'SYZMediator/Classes/**/*'
      source.public_header_files = 'SYZMediator/Classes/**/*.h'
  end

  #s.source_files = 'SYZMediator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SYZMediator' => ['SYZMediator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SYZUIBasekit'
  
  
end