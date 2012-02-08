watch("(server|test)(/.*)+.coffee") {|m|
  fname = m.to_s.split('/')[-1].split('.')[0]+".spec.coffee"
  puts "======= Tests run #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"

  if File.exist?("test/#{fname}")
  	result =  `mocha -c --reporter list -r should --ignore-leaks --growl test/#{fname}`
  	print result

  	dump = []
  	result.split("\n").map{|i|
  	  if !!/\s[0-9]+\)/.match(i)# || !!/TypeError/.match(i)
        `growlnotify -m "#{i}"`
  	  end 
  	}
  end
}
