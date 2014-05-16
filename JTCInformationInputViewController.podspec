Pod::Spec.new do |s|
  s.name         = "JTCInformationInputViewController"
  s.version      = "0.1.1"
  s.summary      = "ViewController to input text and return to view"
  s.description  = <<-DESC
                   ViewController to input text and return to view
                   has validation and format feature.
                   You can use common formatter and/or validator but you can define those with blocks
                   DESC

  s.homepage     = "https://github.com/tomohisa/JTCInformationInputViewController"
  s.license      = "MIT"
  s.author             = { "Tomohisa Takaoka" => "tomohisa.takaoka@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => 'https://github.com/tomohisa/JTCInformationInputViewController.git', :tag => 'v0.1.1' }
  s.source_files  = 'lib/**/*.{h,m}'
  s.resources = 'lib/**/*.storyboard'
  s.framework = 'CoreGraphics'
  s.framework = 'UIKit'
  s.requires_arc = true
  s.dependency 'libextobjc', '~> 0.4'
  s.dependency 'BlocksKit', '~> 2.2'
  s.dependency 'SVProgressHUD', '~> 1.0'
  s.dependency 'SECoreTextView', '~> 0.8'
  s.dependency 'JTCCommon', '~> 0.1.0'

end
