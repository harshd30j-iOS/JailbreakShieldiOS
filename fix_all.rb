require 'xcodeproj'
p = Xcodeproj::Project.open('JailbreakShield.xcodeproj')
p.targets.first.build_configurations.each do |c|
  c.build_settings['DEFINES_MODULE'] = 'YES'
  c.build_settings['MODULEMAP_FILE'] = ''
  puts "✅ #{c.name}: DEFINES_MODULE=YES"
end
p.save
