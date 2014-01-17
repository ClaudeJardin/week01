#Better logger

@nested = 0
@nested_max = 0

def logger &block
  descriptions = ['outer block', 'some little block', 'teeny-tiny block']
  index = (@nested <= 2)? @nested : 2
  @nested = @nested + 1
  @nested_max = (@nested > @nested_max)? @nested : @nested_max
  output_string = (@nested < @nested_max)? 'yet another block' : descriptions[index]
  puts (' ' * (@nested - 1)) + 'Beginning "' + output_string + '"...'
  result = block.call
  puts (' ' * (@nested - 1)) + '..."' + output_string + '" finished, returning: ' + result.to_s
  @nested = @nested - 1
end

logger do
  logger do
    logger do
	  42
	end
    'lots of love'
  end
  logger do
    'I love Indian food!'
  end
  true
end