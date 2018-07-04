# DUMLsploit

Known exploits that can be *pushed* via DUML upgrade process. 

TarAndFeather.rb - exploits system() and popen() of "rm" command on unsanatized file names. 

Initial manifestation found by jan2642, dji_sys shown to execute system("rm %s") and system("rm -rf %s") depending on AC and firmware version

![jan2642 system exploit](https://github.com/MAVProxyUser/DUMLsploit/blob/master/TarAndFeatherSystem.png?raw=true)

Secondary manifestation found by hostile, dji_sys shown to execute popen() on file names passed to the dji_verify command. 

![hostile popen exploit](https://github.com/MAVProxyUser/DUMLsploit/blob/master/TarAndFeatherPopen.png?raw=true)
