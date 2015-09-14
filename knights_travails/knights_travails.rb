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


class KnightPathFinder
  include Searchable
end
