def run_all_tests
  puts "======= Tests run #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  result_text = `mocha --reporter dot -r should --ignore-leaks --growl`
  if result_text == ''
    `growlnotify -m "Error before Test"`
  end
end

run_all_tests
watch("(server|test)(/.*)+.coffee") { |m| run_all_tests }
watch("(shared)(/.*)+.json") { |m| run_all_tests }
