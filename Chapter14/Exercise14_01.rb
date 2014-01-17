#Even better profiling.

@profiling_on = false

def profile block_description, &block
  if @profile_on
    start_time = Time.now
    block.call
    duration = Time.now - start_time
    puts block_description+' : ' +duration.to_s+' seconds'
  end
end

profile ' 25000 doublings' do
  number = 1
  25000.times do
    number = number + number
  end
  puts number.to_s.length.to_s+' digits'
# That' s the number of digits in this HUGE number.
end

profile ' count to a million' do
  number = 0
  1000000.times do
    number = number + 1
  end
end