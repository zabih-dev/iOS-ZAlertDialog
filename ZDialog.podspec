#
# Be sure to run `pod lib lint ZDialog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZDialog'
  s.version          = '0.2.0'
  s.summary          = 'ZDialog lib for easy to show a dialog like as alert dialog'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ZAlertDialog is simple to show an alert dialog with support multi line for the title and message is scrollable if you set the long message.
                       DESC

  s.homepage         = 'https://github.com/zabih1420/ZAlertDialog'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zabih' => 'zabih1420@gmail.com' }
  s.source           = { :git => 'https://github.com/zabih1420/ZAlertDialog.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'

  s.source_files = 'ZDialog/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZDialog' => ['ZDialog/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
