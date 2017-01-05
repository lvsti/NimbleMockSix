Pod::Spec.new do |s|
  s.name = 'NimbleMockSix'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'Nimble matchers for MockSix'
  s.description = <<-DESC
With NimbleMockSix, you can easily make expectations on method invocations on MockSix mock objects in Swift.
DESC
  s.homepage = 'https://github.com/lvsti/NimbleMockSix'
  s.social_media_url = 'https://twitter.com/cocoagrinder/'
  s.authors = { 'Tamas Lustyik' => 'elveestei@gmail.com' }
  s.source = { :git => 'https://github.com/lvsti/NimbleMockSix.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '8.4'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.2'
  s.source_files = 'NimbleMockSix/*.{swift,h}'
  s.public_header_files = 'NimbleMockSix/NimbleMockSix.h'
  
  s.dependency 'MockSix', '~> 0.1'
  s.dependency 'Nimble', '~> 5.1.1'
  s.frameworks = 'MockSix', 'Nimble'
end

