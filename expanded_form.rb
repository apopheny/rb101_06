def expanded_form(int)
  arr = []
  counter = 10
  loop do
    if ((int % counter) > 0) 
      arr << int % counter
    end
    counter * 10
    int -= arr.sum
    break if counter.to_s.size >= int.to_s.size
  end
  arr << int
  p arr.reverse
end

# p expanded_form(12)
# p expanded_form(42)
p expanded_form(70304)
