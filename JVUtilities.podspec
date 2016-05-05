

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
s.source = { :git => "https://github.com/joninsky/JVUtilities.git", :tag => s.version.to_s, :commit => "110b23cff06bf1024cfda1221ebfadb7cd4fd1a4" }

s.platform = :ios, '9.3'
s.requires_arc = true
#s.ios.vendored_frameworks = 'Frameworks/Pebblebee.framework'
s.source_files = "JVUtilities/**/*"
end