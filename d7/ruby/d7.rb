class Tree
  attr_reader :leafs
  def initialize(leafs)
    @leafs = leafs.reduce({}) { |acc, leaf| acc[leaf.name] = leaf; acc }
    assemble!
  end

  def root
    @root ||= leafs.find { |name, leaf| leaf.parent.nil? }
  end

  private
  def assemble!
    leafs.each do |parent_name, parent_leaf|
      parent_leaf.kids.each do |kid_name|
        leaf = leafs[kid_name]
        leaf.add_parent parent_leaf
      end
    end
  end
end

class Leaf
  attr_reader :name, :weight, :kids, :parent
  def initialize(line)
    @name, @weight, *@kids = line.scan(/(\w+)/).flatten
  end

  def add_parent(parent)
    @parent = parent
  end
end

def from_file(path)
  File.read path
end


test_leafs = from_file("test").each_line.map{ |line| Leaf.new line }
test_tree = Tree.new(test_leafs)

input_leafs = from_file("input").each_line.map { |line| Leaf.new line }
input_tree = Tree.new(input_leafs)

p test_tree.root
p input_tree.root
