class Tree
  attr_reader :leafs
  def initialize(leafs)
    @leafs = leafs.reduce({}) { |acc, leaf| acc[leaf.name] = leaf; acc }
    assemble!
  end

  def root
    @root ||= leafs.find { |_, leaf| leaf.parent.nil? }[1]
  end

  def self.from_file(path)
    Tree.new File.read(path).each_line.map{ |line| Leaf.new line }
  end

  private
  def assemble!
    leafs.each do |parent_name, parent_leaf|
      parent_leaf.find_kids leafs
      parent_leaf.kid_names.each do |kid_name|
        leaf = leafs[kid_name]
        leaf.add_parent parent_leaf
      end
    end
  end
end

class Leaf
  attr_reader :name, :weight, :kid_names, :kids, :parent
  def initialize(line)
    @name, @weight, *@kid_names = line.scan(/(\w+)/).flatten
    @weight = weight.to_i
  end

  def add_parent(parent)
    @parent = parent
  end

  def find_kids(leafs)
    @kids = kid_names.reduce([]) { |acc, name| acc << leafs[name] }
  end

  def siblings
    @siblings ||= parent && parent.kids - [self]
  end

  def balance(leaf = self)
    weights = leaf.kids_by_weight
    _, unbalanced = weights.find { |weight, names| names.length == 1 }

    if unbalanced
      balance unbalanced.first
    else
      target = leaf.siblings.first.deep_weight
      new_weight = leaf.weight - (leaf.deep_weight - target)
      { name: leaf.name, new_weight: new_weight }
    end
  end

  def deep_weight
    @dw ||= weight + kids.reduce(0) { |acc, kid| acc += kid.deep_weight }
  end

  def kids_by_weight
    kids.reduce({}) do |acc, kid|
      acc[kid.deep_weight] ||= []
      acc[kid.deep_weight] << kid
      acc
    end
  end
end

test_tree = Tree.from_file "test"
p test_tree.root.balance

input_tree = Tree.from_file "input"
p input_tree.root.balance
