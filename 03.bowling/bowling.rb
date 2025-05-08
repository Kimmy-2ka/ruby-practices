#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |shot|
  shot == 'X' ? shots.push(10, 0) : shots << shot.to_i
end

frames = shots[0..19].each_slice(2).to_a
frames << shots[20..] if shots[20] # 10フレーム目に3投目以降がある場合

point = 0
frames.each_with_index do |frame, idx|
  point += frame.sum
  next if idx > 8 || (frame[0] != 10 && frame.sum != 10)

  following_frame = frames[idx + 1]
  first_bonus = following_frame[0] || 0
  second_bonus = first_bonus == 10 ? frames[idx + 2][0] : following_frame[1]

  point += frame[0] == 10 ? first_bonus + second_bonus : first_bonus
end

puts point
