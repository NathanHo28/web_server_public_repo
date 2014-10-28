require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do    
                                         # Server runs forever
	client = server.accept                          # Wait for a client to connect. Accept returns a TCPSocket

	request_headers = []
	while (line = client.gets)
		line.chomp!
  		break if line.empty?                        # Read the request and collect it until it's empty
  		request_headers << line
  	end
 	puts request_headers                                      # Output the full request to stdout

 	filename = request_headers[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '') #strips everything but the file extension.

 	response_headers = [] #-->These are the headers (in an arrray) which we give back to the browswer.

 	if File.exists?(filename)
 		response_headers << "HTTP/1.1 200 OK" #-->Telling the browser it's okay if this file is found
 		response = File.read(filename)
 		if filename =~ /.css/		#unsure what the tilde does in this situation...
 			filetype = "text/css"
 		elsif filename =~ /.html/
 			filetype = "text/html"
 		elsif filename =~ /.png/
 			filetype = "image/png"
 				
 		else 
 			filetype = "text/plain"
 		end

 	response_headers << "Content-Type: #{filetype}" #-->
 		
 	else
 		response_headers << "HTTP/1.1 404 Not Found"
 		response_headers << "Content-Type: text/plain"
 		response = "File Not Found"
 	end

	response_headers << "Content-Length: #{response.size}"
	response_headers << "Connection: close"
 
	headers = response_headers.join("\r\n") 

	puts
	puts "HEADERS: #{headers}"

	result = [headers, response].join("\r\n\r\n")

	puts
	puts "RESULT: #{result}"

 	client.puts(result)
  	client.close                                      # Disconnect from the client
end