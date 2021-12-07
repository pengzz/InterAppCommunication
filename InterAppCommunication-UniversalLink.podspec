Pod::Spec.new do |s|
  s.name         = "InterAppCommunication-UniversalLink"
  s.version      = "2.0"
  s.summary      = "x-callback-url made easy. 新增加「Universal Link」苹果通用链接方式。"
  s.description  = "x-callback-url made easy.   新增加「Universal Link」苹果通用链接方式。"
  s.platform     = :ios, '5.0'
  #s.homepage     = "https://github.com/tapsandswipes/InterAppCommunication"
  #s.author       = { "Antonio Cabezuelo Vivo" => "antonio@tapsandswipes.com" }
  #s.source       = { :git => "https://github.com/tapsandswipes/InterAppCommunication.git", :tag => '1.0' }
  s.homepage     = "https://github.com/pengzz/InterAppCommunication"
  s.author       = { "pengzz" => "pzz1284@163.com" }
  s.source       = { :git => "https://github.com/pengzz/InterAppCommunication.git", :branch => "pzz", :tag => s.version.to_s }
  s.source_files = 'InterAppCommunication/**/*.{h,m}'
  s.requires_arc = true
  s.license      = { :type => 'MIT', :file => 'LICENSE.markdown' }
end
