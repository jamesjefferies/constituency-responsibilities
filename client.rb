require "mcp"

stdio_transport = MCP::Client::Stdio.new(
  command: "bundle",
  args: ["exec", "ruby", "server.rb"],
  env: { "API_KEY" => "my_secret_key" },
  read_timeout: 30
)
client = MCP::Client.new(transport: stdio_transport)

# Perform the MCP initialization handshake before sending any requests.
client.connect

# List available tools.
tools = client.tools
tools.each do |tool|
  puts "Tool: #{tool.name} - #{tool.description}"
end

# Call a specific tool.
response = client.call_tool(
  tool: tools.first,
  arguments: { message: "Hello, world!" }
)
puts response

# Close the transport when done.
stdio_transport.close