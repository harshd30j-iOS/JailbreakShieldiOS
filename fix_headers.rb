require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
headers_phase = target.headers_build_phase

headers_phase.files.each do |build_file|
  build_file.settings = { 'ATTRIBUTES' => ['Public'] }
  puts "✅ Public: #{build_file.file_ref.path}"
end

project.save
puts "\n✅ All headers set to Public."
