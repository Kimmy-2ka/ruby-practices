#Fizzbuzzの課題。
(1..20).each do |x| #1~20までの数をプリントする
  if x % 3 == 0 && x % 5 == 0 #3と5両方の倍数の場合には｢FizzBuzz｣
    puts "FizzBuzz"
  elsif x % 3 == 0 #3の倍数のときは数の代わりに｢Fizz｣
    puts "Fizz"
  elsif x % 5 == 0 #5の倍数のときは｢Buzz｣とプリント
    puts "Buzz"
  else
    puts x
  end
end
