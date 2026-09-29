#Given a square n x n matrix of integers matrix, rotate it by 90 degrees clockwise.

#You must rotate the matrix in-place. Do not allocate another 2D matrix and do the rotation.

#Input: matrix = [
#   [1,2],
#   [3,4]
# ]

# Output: [
#   [3,1],
#   [4,2]
# ]

#Input: matrix = [
#   [1,2,3],
#   [4,5,6],
#   [7,8,9]
# ]

# Output: [
#   [7,4,1],
#   [8,5,2],
#   [9,6,3]
# ]


class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        if len(matrix)==1:
            return matrix
        
        num_rows = len(matrix)
        num_cols = len(matrix[0])

        #transpose the matrix
        for row in range(num_rows):
            for column in range(row + 1, num_cols):
                matrix[row][column], matrix[column][row] = matrix[column][row], matrix[row][column]

        #invert rows
        for row in range(num_rows):
            matrix[row] = matrix[row][::-1]
        
        