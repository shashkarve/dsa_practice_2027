# You are given two strings num1 and num2 that represent non-negative integers.

# Return the product of num1 and num2 in the form of a string.

# Assume that neither num1 nor num2 contain any leading zero, unless they are the number 0 itself.

# Note: You can not use any built-in library to convert the inputs directly into integers.

# Example 1:

# Input: num1 = "3", num2 = "4"

# Output: "12"
# Example 2:

# Input: num1 = "111", num2 = "222"

# Output: "24642"

#   1 1 1
# X 2 2 2
# _________
#   2 2 2
#   2 2 2
#   2 2 2

# For this problem we can consider that the product of a number with m and n digits will be at most m+n

class Solution:
    def multiply(self, num1: str, num2: str) -> str:
        memo = [0 for _ in range(len(num1) + len(num2))]

        if "0" in [num1, num2]:
            return "0"

        for i in range(len(num1) -1, -1, -1):
            for j in range(len(num2) - 1, -1, -1):
                product = (ord(num1[i]) - ord("0")) * (ord(num2[j]) - ord("0"))
                total = memo[j + i + 1] + product
                ones_num = total % 10
                carry_num = total // 10
                memo[j + i + 1] = ones_num
                memo[j + i] += carry_num

        for idx in range(len(memo)):
            if memo[idx] != 0 :
                return "".join([str(x) for x in memo[idx::]])
        return "0" 
