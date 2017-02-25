#
# Be sure to run `pod lib lint TNSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TNSlider'
  s.version          = '0.1.0'
  s.summary          = 'A control like UISlider but show current value on the thumb.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TNSlider is a control for selecting a single value from a continous range of values like UISlider. The different is TNSlider show current selected value on the indicator (or thumb), that make you have more room for your important contents but still let user know what is the selected value of the slider.
                       DESC

  s.homepage         = 'https://github.com/tiennth/TNSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tien Nguyen' => 'thanhtien2302@gmail.com' }
  s.source           = { :git => 'https://github.com/tiennth/TNSlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/tiennth'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TNSlider/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TNSlider' => ['TNSlider/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
