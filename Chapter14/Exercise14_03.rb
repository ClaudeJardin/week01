#Program logger

def logger block_description, &block
  puts 'Beginning "' + block_description + '"...'
  result = block.call
  puts '..."' + block_description + '" finished, returning: ' + result.to_s
end

logger 'outer block' do
  logger 'some little block' do
    logger 'yet another block' do
	  5
	end
    'I like Thai food!'
  end
  false
end