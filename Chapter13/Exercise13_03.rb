#Make an OrangeTree class.

class OrangeTree
  def initialize
    @age = 0
	@orange_count = 0
	@orange_max = 0
	@height = 0
	@life = 10
	@is_dead = 0
  end
  
  def height
    @height = (is_dead == 0)? @height + 1 : @height - 1
  end
  
  def one_year_passes
    if @age == 0
	  srand 
	  @orange_max = rand(10) + 1
    else
      @orange_max = @orange_max + 1	
    end
	
	@age = (@age < @life)? @age + 1 : @age
	if @age >= @life
	  @is_dead = 1
	  @@orange_max = 0
	end
	@orange_count = @orange_max
	(@is_dead == 1)? 'The tree is dead!' : 'The tree grows!'
  end
  
  def count_the_oranges
    @orange_count
  end
  
  def pick_an_orange
    if @orange_count > 0
      @orange_count = @orange_count - 1
	  return 'Delicious orange!'
	end
	return 'No more orange this year!'
  end
  
  def dead?
    @is_dead == 1
  end
end

tree = OrangeTree.new
year = 0
while !tree.dead?
  year = year + 1
  puts tree.one_year_passes
  if !tree.dead?
    option = 1
    while option != 3
      print 'Options: 1)Count the orange. 2)Pick an orange. 3)Quit: '
      option = gets.chomp.to_i
	  if ![1, 2, 3].include?(option)
	    puts 'Invalid option!'
      elsif option == 1
	    puts 'The count is ' + tree.count_the_oranges.to_s + '!'
	  else
	    puts tree.pick_an_orange
	  end
	end
  end
end
