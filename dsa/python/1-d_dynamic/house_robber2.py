'''
You are given an integer array nums where nums[i] represents the amount of money the ith house has. The houses are arranged in a circle, i.e. the first house and the last house are neighbors.

You are planning to rob money from the houses, but you cannot rob two adjacent houses because the security system will automatically alert the police if two adjacent houses were both broken into.

Return the maximum amount of money you can rob without alerting the police.

Example 1:

Input: nums = [3,4,3]

Output: 4
Explanation: You cannot rob nums[0] + nums[2] = 6 because nums[0] and nums[2] are adjacent houses. The maximum you can rob is nums[1] = 4.

Example 2:

Input: nums = [2,9,8,3,6]

Output: 15
'''
class Solution:
    def house_robber(self, nums: List[int]) -> int :
        memo = []
        for i in range(len(nums)):
            if i == 0:
                memo.append(nums[i])
            elif i == 1:
                memo.append(max(nums[i], nums[i-1]))
            else:
                memo.append(max(
                    nums[i] + memo[-2],
                    memo[-1]
                ))
                
        return max(memo)
    def rob(self, nums: List[int]) -> int:
        if len(nums) <3:
            return max(nums)
        return max(
            self.house_robber(nums[1:]),
            self.house_robber(nums[:-1])
        )

        


