#!/usr/bin/env ruby 
require 'openssl'
require 'socket'

if ARGV.length < 2
  puts "need more arguments"
  puts "usage ./generate_ca.rb key.pem ca.pem"
  exit 1
end

root_key = OpenSSL::PKey::RSA.new 2048 # the CA's public/private key
ca = OpenSSL::X509::Certificate.new
ca.version = 2
ca.serial = 0
ca.issuer = OpenSSL::X509::Name.parse "/C=TH/DC=#{Socket.gethostname}/CN=ndid"
ca.subject = ca.issuer
ca.public_key = root_key.public_key
ca.not_before = Time.now
ca.not_after = ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
ef = OpenSSL::X509::ExtensionFactory.new
ef.subject_certificate = ca
ef.issuer_certificate = ca
ca.add_extension ef.create_extension("basicConstraints","CA:TRUE")
ca.add_extension ef.create_extension("keyUsage","keyCertSign,digitalSignature")
ca.add_extension ef.create_extension("extendedKeyUsage","serverAuth,clientAuth")
ca.add_extension ef.create_extension("subjectKeyIdentifier","hash")
ca.add_extension ef.create_extension("authorityKeyIdentifier","keyid:always")
ca.sign root_key, OpenSSL::Digest::SHA256.new

File.open(ARGV[0], "wb") { |f| f.print root_key.to_pem }
File.open(ARGV[1], "wb") { |f| f.print ca.to_pem }

