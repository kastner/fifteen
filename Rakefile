require 'rubygems'
require 'open3'
require 'open-uri'

IPHONE = "iphone"
HEAVENLY = "/Developer/SDKs/iPhone/heavenly"
CC = "/usr/local/arm-apple-darwin/bin/gcc"
LD = CC
CXX = "/usr/local/arm-apple-darwin/bin/g++"
CFLAGS = "-fsigned-char"
CPPFLAGS = ""
LDFLAGS = "-Wl,-syslibroot,#{HEAVENLY} -lobjc \
  -framework CoreFoundation -framework Foundation \
  -framework UIKit -framework CoreGraphics"


TARGET = Dir.pwd[/[^\/]+$/]

def version
  info = open('skel/Info.plist').read
  match = info.match(/CFBundleVersion.+?<string>(.+?)</im)
  (match) ? match[1] : "1.0"
end

task :default => [:build_install_and_test]

task :clean do
  puts "Deleting #{TARGET}"
  File.delete(TARGET) if File.exists?(TARGET)
  `rm *.o`
  `rm *.zip` #cheap but works
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
  sh %Q{zip -9yr #{TARGET}-#{version}.zip #{TARGET}.app/}
end

task :copy_to_iphone do
  sh %Q{scp -rp #{TARGET}.app #{IPHONE}:/Applications}
end

task :test do
  sh %Q{ssh iphone /Applications/#{TARGET}.app/#{TARGET}}
end

task :run do
  Open3.popen3("ssh iphone") do |stdin, stdout, stderr|
    sleep 0.3
    stdin.puts "/Applications/#{TARGET}.app/#{TARGET}"
    sleep 0.3
    stdin.puts "ps ax | grep #{TARGET}.app | head -1 | awk '{print $1}'"
    sleep 0.2
    pid = stdout.gets
    broken = false;
    
    puts "pid = #{pid}"
    
    trap("INT") { broken = true }
    loop do
      if broken
        sh %Q{ssh iphone kill #{pid}}
        stdout.close
        break
      else
        puts stdout.gets  
      end
    end
  end
end

task :build_install_and_test => [:build, :package, :copy_to_iphone]