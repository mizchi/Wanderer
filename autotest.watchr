def run_all_tests
  puts "======= Tests run #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  result_text = `mocha --reporter spec -r should --growl --ignore-leaks`
end

run_all_tests
watch("(server|client|test)(/.*)+.coffee") { |m| run_all_tests }
watch("(shared)(/.*)+.json") { |m| run_all_tests }
