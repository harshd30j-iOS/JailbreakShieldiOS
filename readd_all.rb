require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)
target = project.targets.first
base = File.expand_path('~/Desktop/JailbreakShield')

# Clear existing build phases
target.source_build_phase.files.to_a.each(&:remove_from_project)
target.headers_build_phase.files.to_a.each(&:remove_from_project)

# Use main_group directly
main = project.main_group

{
  'Detection'        => ['HDJailbreakDetection.h',         'HDJailbreakDetection.m'],
  'SecurityUI'       => ['HDSecurityBlockViewController.h', 'HDSecurityBlockViewController.m',
                         'HDSecurityBlockWindow.h',          'HDSecurityBlockWindow.m'],
  'ScreenProtection' => ['ScreenProtectionManager.h',       'ScreenProtectionManager.m'],
  'Swift'            => ['JailbreakShieldNew.swift']
}.each do |grp_name, files|
  grp = main.new_group(grp_name)
  grp.source_tree = '<group>'
  files.each do |f|
    full = "#{base}/#{f}"
    unless File.exist?(full)
      puts "❌ MISSING: #{full}"; next
    end
    ref = grp.new_file(full)
    ref.path = f
    ref.source_tree = '<group>'
    if f.end_with?('.m', '.swift')
      target.source_build_phase.add_file_reference(ref)
    else
      bf = target.headers_build_phase.add_file_reference(ref)
      bf.settings = { 'ATTRIBUTES' => ['Public'] }
    end
    puts "✅ #{grp_name}/#{f}"
  end
end

project.save
puts "\n✅ Done!"
