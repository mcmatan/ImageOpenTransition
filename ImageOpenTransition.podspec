Pod::Spec.new do |s|

s.name              = 'ImageOpenTransition'
s.version           = '0.1.7'
s.summary           = 'ImageOpenTransition'
s.homepage          = 'https://github.com/mcmatan/ImageOpenTransition'
s.ios.deployment_target = '8.0'
s.platform = :ios, '8.0'
s.license           = {
:type => 'MIT',
:file => 'LICENSE'
}
s.author            = {
'YOURNAME' => 'Matan'
}
s.source            = {
:git => 'https://github.com/mcmatan/ImageOpenTransition.git',
:tag => "#{s.version}" }

s.framework = "UIKit"
s.source_files      = 'ImageOpenTransition*' , 'Vendor/*', 'Resource/*', 'ImageOpenTransition/*'
s.requires_arc      = true

end

