#Grandfather clock

def each_tick seconds, &block 
  while true
    sleep(seconds)
	block.call
  end
end

each_tick 60 * 60 do
  puts ' DONG!'
end