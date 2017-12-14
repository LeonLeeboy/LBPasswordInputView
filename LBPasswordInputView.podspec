
Pod::Spec.new do |s|
  s.name             = 'LBPasswordInputView'
  s.version          = '1.0.0'
  s.summary          = 'like alipay passWord page,when input password'

  s.description      = <<-DESC
                            we can use it ,when our project needs password textfield
                       DESC

  s.homepage         = 'https://github.com/LeonLeeboy/LBPasswordInputView'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'j1103765636@iCloud.com' => '1103765636@qq.com' }
  s.source           = { :git => 'https://github.com/LeonLeeboy/LBPasswordInputView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LBPasswordInputView/Classes/**/*'

   s.frameworks = 'UIKit', 'Foundation'

end
