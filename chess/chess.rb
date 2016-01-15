require_relative 'piece'
require_relative 'board'
require_relative 'display'

b = Board.new
d = Display.new(b)
d.print
# b = Board.new
# b.print
#
# puts " "
# b[5,5] = "abc"
# b.print
# p b
# b.move([5,5], [1,1])
#
# puts " "
# b.print
# p b[5,5]