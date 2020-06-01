#!/usr/bin/env ruby

require 'openssl'
require 'socket'

if ARGV.length < 4
  puts "need more arguments"
  puts "usage ./generate_cert.rb ca.key ca.cert csr.cert cert.pem"
  exit 1
end

ca_key = OpenSSL::PKey::RSA.new File.read ARGV[0]
ca_cert = OpenSSL::X509::Certificate.new File.read ARGV[1]
csr = OpenSSL::X509::Request.new File.read ARGV[2]

raise 'CSR verification failed' unless csr.verify csr.public_key

cert = OpenSSL::X509::Certificate.new
cert.version = 2
cert.serial = 0
cert.not_before = Time.now
cert.not_after = cert.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity

cert.subject = csr.subject
cert.issuer = ca_cert.subject
cert.public_key = csr.public_key

ef = OpenSSL::X509::ExtensionFactory.new nil, cert
ef.subject_certificate = cert
ef.issuer_certificate = ca_cert

cert.add_extension ef.create_extension("basicConstraints","CA:FALSE")
cert.add_extension ef.create_extension("keyUsage","digitalSignature")
cert.add_extension ef.create_extension("extendedKeyUsage","clientAuth")
cert.add_extension ef.create_extension("subjectKeyIdentifier", "hash")

cert.sign ca_key, OpenSSL::Digest::SHA256.new

File.open(ARGV[3], "wb") { |f| f.print cert.to_pem }

