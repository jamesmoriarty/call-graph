class Foo
  def self.x
    Bar.new.y
  end
end

class Bar
  def y
    1 + 1
  end
end
