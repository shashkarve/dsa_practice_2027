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
        
        