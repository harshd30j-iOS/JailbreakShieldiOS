require 'xcodeproj'

project_path = File.expand_path('~/Desktop/JailbreakShield/JailbreakShield.xcodeproj')
project = Xcodeproj::Project.open(project_path)

project.files.each do |ref|
  filename = File.basename(ref.path.to_s)
  ref.path = filename
  ref.source_tree = '<group>'
end

project.save
puts "✅ All paths flattened."
