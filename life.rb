require 'matrix'

class Matrix
  public :rows

  def map_with_index
    Matrix[
      *rows.map.with_index do |row, row_idx|
        row.map.with_index do |o, col_idx|
          yield o, row_idx, col_idx
        end
      end
    ]
  end

  def translate(row_count, col_count)
    Matrix[
      *rows.map do |row|
        row.rotate(row_count)
      end.rotate(col_count)
    ]
  end
end

class Board
  attr_reader :width, :height

  def self.random(size)
    board = Matrix.build(size) { rand(10) == 0 ? 1 : 0 }
    new(board)
  end

  def self.parse(board_string)
    new(Matrix[board_string.split("\n").map { |row| row.split.map(&:to_i) }])
  end

  def initialize(board)
    @width = board.column_size
    @height = board.row_size
    @board = board
  end

  def next
    board_state = neighbor_counts.map_with_index do |count, row, col|
      count == 3 || count == 4 && @board[row, col] == 1 ? 1 : 0
    end

    Board.new(board_state)
  end

  def to_s
    @board.rows.map do |row|
      row.map do |n|
        n == 1 ? "B" : "·"
      end.join(" ")
    end.join("\n")
  end

  def neighbor_counts
    [-1,0,1].product([-1,0,1]).map do |row, col|
      @board.translate(row, col)
    end.reduce(:+)
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
