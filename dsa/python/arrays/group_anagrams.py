#Given an array of strings strs, group all anagrams together into sublists. You may return the output in any order.

# An anagram is a string that contains the exact same characters as another string, but the order of the characters can be different.

# Example 1:

# Input: strs = ["act","pots","tops","cat","stop","hat"]

# Output: [["hat"],["act", "cat"],["stop", "pots", "tops"]]

class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        memo = {}

        for s in strs:
            bucket = [0] * 26
            for i in range(len(s)):
                bucket[ord(s[i]) - ord('a')] += 1
            memo[tuple(bucket)] = memo.get(tuple(bucket), []) + [s]

        return [v for v in memo.values()]