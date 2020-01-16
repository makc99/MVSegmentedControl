#
# Be sure to run `pod lib lint MVSegmentedControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MVSegmentedControl'
  s.version          = '0.1.0'
  s.summary          = 'The unofficial swift Segmented Control library for iOS.'
  s.description      = <<-DESC
A highly configurable Segmented Control that can be configure in style of iOS 12 or iOS 13 or other custom style.

* Layout implemented via constraints
* Ability to configure a control in iOS 12 or 13 or custom style.
* Designable into Interface Builder
                       DESC

  s.homepage         = 'https://github.com/makc99/MVSegmentedControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxim Matyukov' => 'maxim.matyukov@gmail.com' }
  s.source           = { :git => 'https://github.com/makc99/MVSegmentedControl.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'MVSegmentedControl/Classes/**/*.{swift}'

  s.frameworks = 'UIKit'
end
