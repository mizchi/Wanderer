def run_all_tests
  print 'clear'
  puts "Tests run #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  result_text = `mocha --reporter spec -r should --ignore-leaks`
  result = result_text.include? 'complete'
  `growlnotify -m "result: #{result_text}"`
  # if result
  #   `growlnotify -m "#{result_text}" Node Unit`
  # else
  #   `growlnotify -m 'All Unit Tests Passed' Node Unit`
  # end
end

run_all_tests
watch("(server|client|test)(/.*)+.coffee") { |m| run_all_tests }
@interrupted = false

# Ctrl-C
Signal.trap "INT" do
  if @interrupted
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5

    run_all_tests
    @interrupted = false
  end
end
