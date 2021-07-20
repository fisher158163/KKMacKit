Pod::Spec.new do |spec|
  spec.name         = 'KKMacKit'
  spec.version      = '1.0.1'
  spec.license      = 'GPL'
  spec.summary      = 'Common tools for macOS cocoa development.'
  spec.homepage     = 'https://github.com/hughkli/KKMacKit'
  spec.author       = 'Li Kai'
  spec.source           = { :git => 'git@github.com:hughkli/KKMacKit.git', :tag => spec.version.to_s }
  spec.requires_arc = true
  spec.source_files = 'src/**/*'
  spec.osx.deployment_target  = '10.14'
  spec.dependency  'SnapKit'
end
