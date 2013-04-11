class Board
  attr_reader :size

  def self.random(size)
    board = Array.new(size) do
      Array.new(size) { rand(2) }
    end
    new(board)
  end

  def initialize(board)
    @size = board.size
    @board = board
  end

  def next
    board_state = neighbor_counts.map do |row|
      row.map do |i|
        i == 3 || i == 4 ? 1 : 0
      end
    end

    Board.new(board_state)
  end

  def to_s
    @board.map do |row|
      row.map do |n|
        n == 1 ? "B" : "·"
      end.join(" ")
    end.join("\n")
  end

  def neighbor_counts
    (-1..1).map { |i| (-1..1).map { |j| [i, j] } }.flatten(1).map do |row, col|
      rotate_board(row, col)
    end.reduce(Array.new(@size) { Array.new(@size) { 0 } }) do |res, arr|
      each_coordinate do |row, col|
        res[row][col] += arr[row][col]
      end

      res
    end
  end

  def rotate_board(row_count, col_count)
    @board.map do |row|
      row.rotate(row_count)
    end.rotate(col_count)
  end

  def each_coordinate
    (0...size).each do |row|
      (0...size).each do |col|
        yield row, col
      end
    end
  end
end

b = Board.random(10)
loop do
  b = b.next
  puts b
  sleep 0.5
  system("clear")
end
