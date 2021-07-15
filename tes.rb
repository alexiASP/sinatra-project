require 'colorize'
# @param {Integer[]} nums
# @param {Integer} target
# @return {Integer[]}
def two_sum(nums, target)
  nums.each_with_index do |el1, i1|
    arr = nums.map(&:clone)
    arr.slice!(i1)
    arr.each_with_index do |el2, i2|
      if el1 + el2 == target
        return [i1, i2+1]
      end
    end
  end
end

nums = [3, 4, 13, 12, 2, 8]
target = 10

# p two_sum(nums, target)

l1 = [9,9,9,9,9,9,9]
l2 = [9,9,9,9]

def add_two_numbers(l1, l2)
  (l1.map(&:to_s).reverse.join.to_i + l2.map(&:to_s).reverse.join.to_i).to_s.split('').map(&:to_i).reverse
end

a = {
  a: 10,
  r: 20
}