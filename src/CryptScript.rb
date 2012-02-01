# CryptScript
#!/usr/bin/env ruby
#
require 'rubygems'
require 'win32ole'
require 'encryptor'

@key = '1234567890'
@secret_key = Digest::SHA256.hexdigest(@key)

#~ # Subroutines
def crypt(scr)
	txt = File.readlines(scr).to_s
	ctxt = Encryptor.encrypt(txt, :key => @secret_key)
	scrx = "#{scr}x"
	File.open(scrx, "w") do |f|
		f.puts ctxt
	end
	puts "Encrypted file: #{scrx}"
	File.delete(scr)
end

def decrypt(scrx, key)
	ctxt = File.readlines(scrx).to_s.strip
	scr = scrx[0..-2]
	dtxt = Encryptor.decrypt(ctxt, :key => @secret_key)
	File.open(scr, "w") do |f|
		f.puts dtxt
	end
	puts "#{key} | #{@key} => #{key == @key}"
	if key == @key
		puts "Encrypted file: #{scr}"
	else
		puts "Run encrypted file: #{scr}"
		shell = WIN32OLE.new("Wscript.Shell")
		shell.run scr, 1, true
		shell = nil
		#~ system("start #{scr}")		
		File.delete(scr) if !shell
	end
end

#~ # Main program

if ARGV.length > 0
	
	scr = ARGV[0]
	if ARGV[1]
		key = ARGV[1].strip
	else
		key = ""
	end
	
	if scr[-1..-1] != "x"
		#~ # Encrypt script file
		crypt(scr)	
	else	
		#~ # Decrypt or run script
		decrypt(scr, key)	
	end

else
	
	puts "\n*** CryptScript (Script en-/decoder) ***"
	puts "-" * 45
	puts "(C) 2012 Andreas Weber (ruby.gruena.net)\n\n"
	puts "Usage:"
	puts "\t1) Encryption:\t'CryptScript test.cmd' => test.cmdx"
	puts "\t2) Run script:\t'CryptScript test.cmdx'"
	puts "\t3) Decryption:\t'CryptScript test.cmdx [key]' => test.cmd\n\n"
	puts "More informations: ruby.gruena.net => Projects\n\n"

end
