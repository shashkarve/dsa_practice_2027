#Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] where nums[i] + nums[j] + nums[k] == 0, and the indices i, j and k are all distinct.

# The output should not contain any duplicate triplets. You may return the output and the triplets in any order.

# Example 1:

# Input: nums = [-1,0,1,2,-1,-4]

# Output: [[-1,-1,2],[-1,0,1]]

from typing import List

class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        sorted_nums = sorted(nums)
        results = []
        for x in range(len(sorted_nums) - 2):
            #As we are sorting, the array will only increase left to right. 
            # If the first number we have encountered is greater than 0, then our sum will always be > 0
            # This way we will neven find a triplet that sums to 0, 
            # so we can break the loop and return the results we have found so far.
            if sorted_nums[x] > 0:
                break
            if x > 0 and sorted_nums[x] == sorted_nums[x-1]:
                continue
            target = sorted_nums[x] * -1
            left = x + 1
            right = len(sorted_nums) -1

            while(left < right):
                calc = sorted_nums[left] + sorted_nums[right]
                if calc > target:
                    right -= 1
                elif calc < target:
                    left +=1
                else:
                    results.append([sorted_nums[x], sorted_nums[left], sorted_nums[right]])
                    left += 1
                    right -= 1
                    while left < right and sorted_nums[left] == sorted_nums[left - 1]:
                        left += 1
                    while left < right and sorted_nums[right] == sorted_nums[right + 1]:
                        right -= 1
        return results
   