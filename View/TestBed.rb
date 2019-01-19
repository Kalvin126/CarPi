
# x = "413365"
# y = "410B4C"

# x_val = x[4..-1].to_i(16) * 0.145038
# y_val = y[4..-1].to_i(16) * 0.145038

puts (Time.new - Time.new).is_a?(Float)

o = "4106ABCDEFGH"
t = o[4..-1]

s = t.chars.each_slice(2).to_a.map(&:join)

A = s[0]
B = s[1]
C = s[2]
D = s[3]

puts A
puts B
puts C
puts D