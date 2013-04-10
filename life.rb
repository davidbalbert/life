class Board
  attr_reader :size

  def initialize(size)
    @size = size
    @board = Array.new(size) do |i|
      Array.new(size) { |i| rand(2) }
    end
  end

  def next
    new_board = Board.new(size)
    each_coordinate do |row, col|
    end
  end

  def each_coordinate
    @board.each_index do |row|
      @board[row].each_index do |col|
        yield(row, col)
      end
    end
  end

  def to_s
    @board.map do |row|
      row.map do |n|
        n == 1 ? "B" : "·"
      end.join(" ")
    end.join("\n")
  end

  private
  def []=(row, col, val)
    @board[row][col] = val
  end
end

b = Board.new(10)
puts b
