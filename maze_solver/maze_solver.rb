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

class Maze
  attr_reader :grid

  DELTAS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

  def self.from_file(file)
    grid = []
    File.open(file).each do |l|
      grid << l.chomp.split("").map do |val|
        Tile.create_tile(val)
      end
    end

    Maze.new(grid)
  end

  def valid_moves(pos)
    moves = []
    DELTAS.each do |delta|
      new_pos = [delta[0] + pos[0], delta[1] + pos[1]]
      next unless new_pos[0] >= 0 && new_pos[0] <= @width && new_pos[1] >=0 && new_pos[1] <= @height
      pos_class = self[new_pos]
      moves << new_pos if pos_class.is_a?(Space) or pos_class.is_a?(End)
    end
    moves
  end

  def initialize(grid)
    @grid = grid
    @width, @height = grid_size
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def grid_size
    [@grid[0].size, @grid.size]
  end

  def render
    @grid.each do |row|
      puts row.map { |tile| tile.to_s }.join("")
    end
  end

  def find_start
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        return [row_idx, col_idx] if tile.is_a?(Start)
      end
    end
  end

  def build_move_tree
    starting_node = PolyTreeNode.new(@start)
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



  def solve
    @start = find_start
    end_node = build_move_tree.bfs(end_pos)
  end
end

class Tile
  def self.create_tile(val)
    case val
    when "*"
      Wall.new("*")
    when " "
      Space.new(" ")
    when "S"
      Start.new("S")
    when "E"
      End.new("E")
    end
  end

  def initialize(val)
    @val = val
  end

  def to_s
    @val
  end
end

class Start < Tile
end

class End < Tile
end

class Wall < Tile
end

class Space < Tile
end

m = Maze.from_file('maze.txt')
s = m.find_start
p m.valid_moves([4,3])
