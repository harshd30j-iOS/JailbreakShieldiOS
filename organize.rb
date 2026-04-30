require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

main_group = project.main_group['JailbreakShield'] || project.main_group

groups = {
  'Detection'        => ['HDJailbreakDetection.h',         'HDJailbreakDetection.m'],
  'SecurityUI'       => ['HDSecurityBlockViewController.h', 'HDSecurityBlockViewController.m',
                         'HDSecurityBlockWindow.h',          'HDSecurityBlockWindow.m'],
  'ScreenProtection' => ['ScreenProtectionManager.h',       'ScreenProtectionManager.m'],
  'Swift'            => ['JailbreakShieldNew.swift']
}

groups.each do |group_name, files|
  group = main_group[group_name] || main_group.new_group(group_name, group_name)
  files.each do |filename|
    ref = main_group.files.find { |f| f.path&.include?(filename) }
    next unless ref
    ref.move(group)
  end
end

project.save
puts "Done! Groups created successfully."
