#Name: Alison Chen
#Email: alison.y.chen@vanderbilt.edu
#VUnet ID: chenay
#Class: CS270
#Date: 11/17/12
#Sudoku solver in Ruby

# Ruby is fully object oriented, even base types are objects.
# To keep things simple for this lab, we will not make our own class, 
# rather will we simply define some methods/functions.
# Ruby dynamically adds these methods to the base Object class.

# Again, for the purpose of keeping things simple, we will define our 
# board to be a global variable so that all the methods have acces to it.
# The $ declares sudokuBoard as a global var
$sudokuBoard = [[0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0]]


# printSudokuBoard will print the globally accessible board
def printSudokuBoard
  for row in 0..8
    for col in 0..8
      print $sudokuBoard[row][col].to_s + " "
      if col == 2 or col == 5 then
        print "| "
      end
    end
    print "\n"
    if row == 2 or row == 5 then
      print "------+-------+------\n"
    end
  end
end

def checkCol(col,num)
   0.upto(8) do |row| 
      if $sudokuBoard[row][col] == num then
        return false 
      end
   end
   return true
end

def checkRow(row, num) 
   disjointSet = $sudokuBoard[row] - [num]
   if disjointSet.length == 9 then
      #safe to add 5 to the row
      return true
   else
     #unsafe to add 5 to the row, since it already existed there
     return false
   end
   return false
end

def checkSubgrid(row,col,num)
  startRow = row/3*3
  startColumn = col/3*3
  centerBox = $sudokuBoard[startRow][startColumn..startColumn+2]+$sudokuBoard[startRow+1][startColumn..startColumn+2]+$sudokuBoard[startRow+2][startColumn..startColumn+2]
  disjointSet = centerBox - [num]
  if disjointSet.length == 9 then
     return true
  else
     return false
  end
   return false
end

def check(row,col,num) 
   if checkSubgrid(row,col,num)&&checkRow(row,num)&&checkCol(col,num) then
      return true
   else
      return false
   end
   return false
end

def solve(row,col)
 if row == 9 then
    return true
 end
 if col == 9 then
    return solve(row+1,0)
 end
 if $sudokuBoard[row][col] !=0 then
    return solve(row,col+1) 
 end

  1.upto(9) do |value| 
    if check(row,col,value) then
       $sudokuBoard[row][col] = value
       if solve(row,col+1) then
          return true
       end
       $sudokuBoard[row][col] = 0
    end
  end
    return false
end


# main starts here:
inFile = File.new("C:\\cs3270\\ruby\\sudoku.txt","r")
index = 0
#iterate over the lines from the file
inFile.each_line do |line|
 #line is a string containing one line from the file.
 #code to process the line goes here.
 vals = line.split
 if vals.length != 9
   print "Each line of the input file must have 9 numbers.\n"
   exit
 end
 #the collect block will iterate over each item in vals (strings)
 #and perform the function (convert to int) returning the set as a new array
 $sudokuBoard[index] = vals.collect { |x| x.to_i}

 index = index + 1 # last line of loop body
end

if index != 9
 print "Input file must have 9 rows.\n"
 exit
end
inFile.close

print "Here is the initial board:\n"
printSudokuBoard
t1 = Time.now.to_f
if solve(0,0) 
   t2 = Time.now.to_f
   timeElapsed=(t2 - t1) * 1000.0
   print "Time elapsed (milliseconds): " + timeElapsed.to_s + "\n"
   printSudokuBoard
else
   print "No solution."
exit
end


