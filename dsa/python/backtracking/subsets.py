#Input: nums = [1,2,3]

#Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]

class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        result = []

        def backtrack(start, current):
            if start == len(nums):
                result.append(current[:])
                return
            
            backtrack(start + 1, current)
            current.append(nums[start])
            backtrack(start + 1, current)
            current.pop()
            
        backtrack(0,[])
        return result
        