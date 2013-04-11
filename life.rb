class Board
  attr_reader :size

  def self.random(size)
    board = Array.new(size) do
      Array.new(size) { rand(10) == 0 ? 1 : 0 }
    end
    new(board)
  end

  def self.parse(board_string)
    new(board_string.split("\n").map { |row| row.split.map(&:to_i) })
  end

  def initialize(board)
    if board.size != board[0].size
      raise "The board has to be square!"
    end

    @size = board.size
    @board = board
  end

  def next
    board_state = neighbor_counts.zip(@board).map do |row, old_row|
      row.zip(old_row).map do |c, old_i|
        if c == 3 || c == 4 && old_i == 1
          1
        else
          0
        end
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
    translated_matricies.reduce(Array.new(@size) { Array.new(@size) { 0 } }) do |res, arr|
      each_coordinate do |row, col|
        res[row][col] += arr[row][col]
      end

      res
    end
  end

  def translated_matricies
    [-1,0,1].product([-1,0,1]).map do |row, col|
      rotate_board(row, col)
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

b = Board.random(40)
system("clear")

loop do
  puts b
  sleep 0.2
  system("clear")
  b = b.next
end
