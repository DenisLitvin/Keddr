platform :ios, '9.0'

target 'Keddr' do
  use_frameworks!
  pod 'Kanna', '~> 2.1.0'  
  pod 'KeychainAccess'
  pod 'Pinner'
end

post_install do |installer|
	myTargets = ['Kanna']
	
	installer.pods_project.targets.each do |target|
		if myTargets.include? target.name
			target.build_configurations.each do |config|
				config.build_settings['SWIFT_VERSION'] = '3.2'
			end
		end
	end
end