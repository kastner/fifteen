require 'rubygems'
require 'net/ssh'
require 'open3'

IPHONE = "iphone"
HEAVENLY = "/Developer/SDKs/iPhone/heavenly"
CC = "/usr/local/arm-apple-darwin/bin/gcc"
LD = CC
CXX = "/usr/local/arm-apple-darwin/bin/g++"
CFLAGS = "-fsigned-char"
CPPFLAGS = ""
LDFLAGS = "-Wl,-syslibroot,#{HEAVENLY} -lobjc -framework CoreGraphics -framework GraphicsServices -framework CoreFoundation -framework Foundation -framework UIKit -framework PhotoLibrary -framework MusicLibrary"


TARGET = Dir.pwd[/[^\/]+$/]

task :default => [:build_install_and_test]

task :clean do
  puts "Deleting #{TARGET}"
  File.delete(TARGET) if File.exists?(TARGET)
  `rm *.o`
end

o_files = []

FileList["*.m"].to_a.each do |m|
  o_file = m.gsub(/m$/,'o')
  o_files << o_file
  task o_file.to_sym => [m] do
    sh %Q{#{CC} -c #{CFLAGS} #{CPPFLAGS} #{m} -o #{o_file}}
  end
end

task :build => o_files do
  sh %Q{#{LD} #{LDFLAGS} -o #{TARGET} #{Dir["*.o"].join " "}}
end

task :package do
  `mkdir -p #{TARGET}.app`
  FileList["skel/*"].to_a.each do |f|
    `cp #{f} #{TARGET}.app/`
  end
  `cp #{TARGET} #{TARGET}.app/`
end

task :release => ["package"] do
  sh %Q{zip -r #{TARGET}.zip #{TARGET}.app/}
end

task :copy_to_iphone do
  sh %Q{scp -rp #{TARGET}.app #{IPHONE}:/Applications}
end

task :test do
  sh %Q{ssh iphone /Applications/#{TARGET}.app/#{TARGET}}
end

task :build_install_and_test => [:build, :package, :copy_to_iphone]