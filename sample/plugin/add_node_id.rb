def add_node_id
  # extract name from CN
  subject = @conn.socket.ssl_handler.peer_cert.subject.to_s
  node_id = subject.split('/').detect {
    |x| x.start_with? "CN="
  }
  if !node_id.nil?
    idx = node_id.index('=') + 1
    @record[:ndid_node_id] = node_id[idx..node_id.length]
  end
end
