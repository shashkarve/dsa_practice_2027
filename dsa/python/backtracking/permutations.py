#Input: nums = [1,2,3]

#Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        result = []
        memo = [False] * len(nums)

        def backtrack(current):
            if len(current) == len(nums):
                result.append(current[:])
                return

            for x in range(len(nums)):
                if memo[x]:
                    continue

                memo[x] = True
                current.append(nums[x])
                backtrack(current)
                current.pop()
                memo[x] = False

        backtrack([])
        return result
    
                
