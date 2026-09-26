class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []

        def backtrack(open_left, close_left, current):
            if open_left == 0 and close_left == 0:
                result.append(current)
                return
            
            if open_left > 0:
                backtrack(open_left - 1, close_left, current + "(")
            
            if close_left > open_left :
                backtrack(open_left, close_left - 1, current +")")

        backtrack(n, n, "")
        return result    