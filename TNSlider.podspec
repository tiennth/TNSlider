Pod::Spec.new do |s|
  s.name             = 'TNSlider'
  s.version          = '0.2.0'
  s.summary          = 'A control like UISlider but show current value on the thumb.'
  s.description      = "TNSlider is a control for selecting a single value from a continous range of values like UISlider. The different is TNSlider show current selected value on the indicator (or thumb), that make you have more room for your important contents but still let user know what is the selected value of the slider."
  s.homepage         = 'https://github.com/tiennth/TNSlider'
  # s.screenshots     = 'https://github.com/tiennth/TNSlider/blob/master/Screenshot_1.png', 'https://github.com/tiennth/TNSlider/blob/master/Screenshot_2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tien Nguyen' => 'thanhtien2302@gmail.com' }
  s.source           = { :git => 'https://github.com/tiennth/TNSlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/tiennth'
  s.ios.deployment_target = '8.0'
  s.source_files = 'TNSlider/Sources/*.swift'

end
