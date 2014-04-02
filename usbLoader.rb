require 'rubygems'
require 'bundler/setup'
require 'timeout'

Bundler.require(:default)

def main
  puts "You may plug in usb drives at any time... "
  puts "But DO NOT remove drives unit instructed"
  check_quit
  while true
    puts "Searching for Drives"
    usbDrives = OSXTools.attached_volumes.find_all {|v| v.bus_protocol == 'USB' && v.mount_point != ""}
    if usbDrives.count == 0
      puts "Safe to remove drives"
    else
      puts "Found #{usbDrives.count} new usb disks"
      usbDrives.each do |usbDrive|
        Dir.foreach('./filesToLoad') do |f|
          next if f.to_s=="." or f.to_s==".."
          puts "Copying #{f} to #{usbDrive.mount_point}/#{f}"
          FileUtils.cp("./filesToLoad/#{f}", "#{usbDrive.mount_point}/#{f}")
        end
        usbDrive.eject
      end
    end
    check_quit
  end
end

def check_quit
  puts "Press x to quit, or anykey to continue... continuing in 5 seconds"
  begin
    Timeout::timeout(5) do
      if gets =~ /x/
        exit
      end
    end
  rescue
  end
end

main
