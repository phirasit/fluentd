#!/usr/bin/env ruby

require 'openssl'
require 'socket'

if ARGV.length < 2
  puts "need more arguments"
  puts "usage ./generate_csr.rb name key.pem csr.pem"
  exit 1
end

key = OpenSSL::PKey::RSA.new 2048

csr = OpenSSL::X509::Request.new
csr.version = 2
csr.subject = OpenSSL::X509::Name.parse "/C=TH/CN=#{ARGV[0]}/DC=asdfasdf"
csr.public_key = key.public_key
csr.sign key, OpenSSL::Digest::SHA1.new

File.open(ARGV[1], "wb") { |f| f.print key.to_pem  }
File.open(ARGV[2], "wb") { |f| f.print csr.to_pem  }
