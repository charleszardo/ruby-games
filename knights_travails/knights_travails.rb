module Searchable
  def dfs(target_value = nil, &prc)
    return self if self.value == target_value

    prc ||= Proc.new { |node| node.value == target_value}

    return self if prc.call(self)

    children.each do |child|
      result = child.dfs(&prc)
      return result unless result.nil?
    end

    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      current_node = queue.shift
      if current_node.value == target_value
        return current_node
      else
        queue += current_node.children
      end
    end
  end
end

class PolyTreeNode
  include Searchable

  attr_accessor :value
  attr_reader :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(node)
    return if self.parent == node

    if @parent
      @parent._children.delete(self)
    end

    @parent = node
    @parent._children << self unless self.parent.nil?
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def children
    @children.dup
  end

  def remove_child(child)
    if child && !self.children.include?(child)
      raise "Tried to remove node that isn't a child"
    end

    child.parent = nil
  end

  protected
  def _children
    @children
  end
end

class KnightPathFinder
  attr_reader :visited_positions

  DELTAS = [[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]]

  def self.valid_moves(pos)
    moves = []
    DELTAS.each do |delta|
      new_pos = [delta[0] + pos[0], delta[1] + pos[1]]
      moves << new_pos if new_pos.all? { |loc| loc >= 0 && loc <= 7 }
    end
    moves
  end

  def initialize(starting_pos)
    @starting_pos = starting_pos
    @visited_positions = [starting_pos]
  end
  
  def reset
    @visited_positions = [@starting_pos]
  end

  def new_move_positions(pos)
    moves = KnightPathFinder.valid_moves(pos).select { |move| !@visited_positions.include?(move) }
    @visited_positions.concat(moves)
    moves
  end

  def build_move_tree
    starting_node = PolyTreeNode.new(@starting_pos)
    queue = [starting_node]
    until queue.empty?
      current_node = queue.shift
      current_pos = current_node.value
      new_move_positions(current_pos).each do |move|
        move_node = PolyTreeNode.new(move)
        current_node.add_child(move_node)
        queue << move_node
      end
    end
    starting_node
  end

  def find_path(end_pos)
    end_node = build_move_tree.bfs(end_pos)
    if !end_node
      puts "No path exists!"
      return
    end

    path = []
    until end_node.nil?
      path << end_node.value
      end_node = end_node.parent
    end
    
    reset
    path.reverse
  end
end

kpf = KnightPathFinder.new([0,0])

p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
