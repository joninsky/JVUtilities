


Pod::Spec.new do |s|
s.name = "JVUtilities"
s.version = "0.1.0"
s.summary = "Molularized things that I find useful."
s.description = <<-DESC
Networking, Notificaitons, Tutorials, and other custom stuff.
DESC

s.homepage = "https://github.com/joninsky/JVUtilities"
s.license = 'MIT'
s.author = { "Jon Vogel" => "joninsky@gmail.com" }
#s.source = { :git => "https://github.com/PebbleBee/pb-ios-framework-bluetooth.git", :tag => s.version.to_s" }

s.platform = :ios
s.requires_arc = true
#s.ios.vendored_frameworks = 'Frameworks/Pebblebee.framework'
s.source_files = "JVUtilities/**/*"
end