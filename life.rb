#!/usr/bin/env ruby
# encoding: utf-8

require 'matrix'

class Board < Matrix
  def self.random(size)
    build(size) { rand(10) == 0 ? 1 : 0 }
  end

  def self.parse(board_string)
    Board[board_string.split("\n").map { |row| row.split.map(&:to_i) }]
  end

  def next
    neighbor_counts.map.with_index do |count, idx|
      count == 3 || count == 4 && self[idx / column_size, idx % column_size] == 1 ? 1 : 0
    end
  end

  def to_s
    row_vectors.map do |row|
      row.map do |n|
        n == 1 ? "B" : "·"
      end.to_a.join(" ")
    end.join("\n")
  end

  def neighbor_counts
    [-1,0,1].product([-1,0,1]).map do |row, col|
      translate(row, col)
    end.reduce(:+)
  end

  def translate(row_count, col_count)
    Board[
      *row_vectors.map do |row|
        row.to_a.rotate(row_count)
      end.rotate(col_count)
    ]
  end
end

if __FILE__ == $0
  b = Board.random(40)
  system("clear")

  loop do
    puts b
    sleep 0.2
    system("clear")
    b = b.next
  end
end
