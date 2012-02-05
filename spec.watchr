def run_spec_test(m)
  fname = m.to_s.split('/')[-1].split('.')[0]+".spec.coffee"
  puts "======= Tests run #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
  if File.exist?("test/#{fname}")
  	print `mocha -c --reporter list -r should --ignore-leaks --growl test/#{fname}`
  end
end

watch("(server|test)(/.*)+.coffee") {|m|
	run_spec_test(m)
	# run_spec_test(m.split('/')[-1].split('.')[0]+".spec.coffee")
}
