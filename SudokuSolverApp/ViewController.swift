//#program  that solves a sudoku puzzle for you
//#bmp: solves a a precoded sudoku puzzle thats stored as a 2D list, prints everything out into terminal
//#bike ver: adds a graphical component
//#car ver: can take a user inputted sudoku puzzle


//#made by George Aoyagi 1/8/20



import UIKit

class ViewController: UIViewController,  UITextFieldDelegate{
    
    @IBOutlet weak var test1: UITextField!
    
    
    
    
    
    //#sample sudoku puzzle as 2d list
    var sudoku:[[Int]] = [[0,0,0,2,6,0,7,0,1], [6,8,0,0,7,0,0,9,0], [1,9,0,0,0,4,5,0,0],
              [8,2,0,1,0,0,0,4,0], [0,0,4,6,0,2,9,0,0], [0,5,0,0,0,3,0,2,8],
              [0,0,9,3,0,0,0,7,4], [0,4,0,0,5,0,0,3,6], [7,0,3,0,1,8,0,0,0]]
    //#answer to the sudoku for testing purposes
    var finish:[[Int]] = [[4,3,5,2,6,9,7,8,1], [6,8,2,5,7,1,4,9,3], [1,9,7,8,3,4,5,6,2],
              [8,2,6,1,9,5,3,4,7], [3,7,4,6,8,2,9,1,5], [9,5,1,7,4,3,6,2,8],
              [5,1,9,3,2,6,8,7,4], [2,4,8,9,5,7,1,3,6], [7,6,3,4,1,8,2,5,9]]
    //#https://dingo.sbs.arizona.edu/~sandiway/sudoku/examples.html
    
    

    //#Number Node class, each node holds the value of a guess at a set of coordinates
    class Node{
        var value:Int
        var row:Int
        var col:Int
        var old:[Int]
        var next:Node!
        var prev:Node!
        init(_ row:Int, _ col:Int, _ value:Int){
            self.value = value
            self.row = row
            self.col = col
            self.old = []
            self.next = nil
            self.prev = nil
        }
    }

    //#Doubley Linked List class
    class LinkedList{
        var head:Node!
        var tail:Node!
        var size:Int
        init(){
            self.head = nil
            self.tail = nil
            self.size = 0

        }
    }

    //#text display for the sudoku puzzle
    //#pram:nil
    //#return: nil:
    func display(){
        for x in 0..<9{
            if x%3==0{
                for _ in 0..<23{
                    print("_", terminator:"")
                }
                print("")
            }
            for y in 0..<9{
                if y%3 == 0{
                    print("| ", terminator:"")
                }
                print(String(sudoku[x][y]) + " ", terminator:"")
            }
            print("")
        }
        for _ in 0..<23{
            print("_", terminator:"")
        }
    }

    //#check if a guess is valid in the current row
    //#param: int(current col)
    //#return: bool(True if valid)
    func checkRow(_ rowNum:Int, _ value:Int)->Bool{
        //#loops through the entire column
        for x in 0..<9{
            if sudoku[rowNum][x] == value{
                return false
            }
        }
        return true
    }

    //#check if the guess is valid in the curret column
    //#param: int(current row)
    //#return: bool(True if valid)
    func checkCol(_ colNum:Int, _ value:Int)->Bool{
        //#loops through entire row
        for x in 0..<9{
            if sudoku[x][colNum] == value{
                return false
            }
        }
        return true
    }

    //#check if the guess is valid in the current square by checking every value in the square except the specified coordinates
    //#param: int(current row), int(current col), int(guess)
    //#return: bool(True if valid)
    func checkSquare(_ rowNum:Int, _ colNum:Int, _ value:Int)->Bool{
        //#the while's should set the coordinates the square's bottom right coordinate
        var tempRow = rowNum
        var tempCol = colNum
        while (tempRow+1)%3 != 0{
            tempRow+=1
        }
        while (tempCol+1)%3 != 0{
            tempCol+=1
        }
        //#loops through the entire square
        for a in stride(from:tempRow, to:tempRow-3, by:-1){
            for b in stride(from:tempCol, to:tempCol-3, by:-1){
                //#dont check the the square that your trying to check for
                if (a != rowNum) && (b != colNum){
                    if sudoku[a][b] == value{
                        return false
                    }
                }
            }
        }
        return true
    }

    //#calls all the guess validity checks at once
    //#param: Node(the current  guess)
    //#return: bool (True if valid)
    func check(_ guess:Node)->Bool{
        if checkRow(guess.row, guess.value) && checkSquare(guess.row, guess.col, guess.value) && checkCol(guess.col, guess.value){
            return true
        } else{
            return false
        }
    }

    //#returns the node from ther guesses linked lsit that matches the param's row, col, and value
    //#param: int(row number), int(column number), int(number value)
    //#return: node(guess)
    func find(_ rowNum:Int, _ colNum:Int, _ lList:LinkedList)->Node?{
        var found:Node! = lList.head
        while found != nil{
            if found.row == rowNum && found.col == colNum{
                break
            }
            found = found.next
        }
        return found
    }

    //#solves the puzzle by going through every empoty spot and finding a valid number for it;
    //    #if no valid number can be found, se the current value to 0 and back track to the previous guessed num and find another valid num for that spot
    //    #repeat the prev until a new valid number can be found
    //#param: node(object for the currently guessed spot)
    //#return: nil
    func solve(_ current:Node!){
        if current != nil{
            var temp = current
            var backtrack = true
            current.old.append(current.value)
            //#checks all possible values for the spot for the first valid number except the one it already is
            for value in 1...9{
                if current.old.contains(value){
                    current.value = value
                    if check(current){
                        backtrack = false
                        display()
                        sudoku[current.row][current.col] = current.value
                        print("guess for \(current.row), \(current.col) is \(current.value)")
                        break
                    }
                }
            }
            if backtrack{
                print("BACKTRACK")
                current.old.removeAll()
                current.value = 0
                sudoku[current.row][current.col] = 0
                temp = current.prev
                print("{current.row}, {current.col} is {current.value}")
            } else{
                print("Advance")
                temp = current.next
            }
            solve(temp)
        } else{
            print("Done")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        test1.delegate = self
        let toGuess = LinkedList()
        //#sentinal node
        toGuess.head = Node(-1,-1,-1)
        toGuess.tail = toGuess.head
        //#iterate through the puzzle to find all the spots to guess and adds them to the linked list
        for row in 0..<9{
            for col in 0..<9{
                if sudoku[row][col] == 0{
                    toGuess.tail.next = Node(row, col, 0)
                    let temp = toGuess.tail
                    toGuess.tail = toGuess.tail.next
                    toGuess.tail.prev = temp
                }
            }
        }
//        //test to see if I get all the spots  to guess correctly
//        var temp:Node! = toGuess.head.next
//        while temp != nil{
//            print("row: " + String(temp.row))
//            print("col: " + String(temp.col))
//            print("")
//            temp = temp.next
//        }
        //
        //    # #test to see if i implemented the doubly linked list correctly
        //    # temp = toGuess.tail
        //    # while temp.value != -1:
        //    #     print("row: "+ str(temp.row))
        //    #     print("col: "+ str(temp.col))
        //    #     print("")
        //    #     temp = temp.prev


        print("""
                rules of Sudoku: Your goal is to fill the grid with numbers. Each spot must be a  number within 1-9.
                    A guess is valid if all 3 of the following things are satisfied:
                    1) there is no identical number within the sub square
                    2) there is no identical number in the same row
                    3) there is now identical number in the same column
        """)
       
        var solved = false
        while !solved{
            display()
            print("")
            var guess:Node = Node(0,0,0)
            print("Do you give up and want it solved for you? (press y for yes, anything else for no): ")
            
          
            if test1.text == "y"{
                solve(toGuess.head.next)
                print("this was the answer: ")
                display()
                break
            }

            //#checks if the user's guess is valid
            var valid = false
            while !valid{
                print("Enter a guess (in order of row, then column, then value): \n")
                while let row = readLine(){
                    if Int(row)! > 9 || Int(row)! < 1{
                        print("Invalid Row Number")
                        continue
                    }
                    guess.row = Int(row)!
                }
                 while let col = readLine(){
                    if Int(col)! > 9 || Int(col)! < 1{
                       print("Invalid Col Number")
                       continue
                   }
                   guess.col = Int(col)!
               }
                let coordinates:Node? = find(guess.row-1, guess.col-1, toGuess)
                if coordinates == nil{
                    print("that spot doesn't need to be guessed")
                    continue
                }

                while let value = readLine(){
                    if Int(value)!>9 || Int(value)!<1{
                        print("invalid Value")
                        continue
                    }
                    guess.value = Int(value)!
                }
                valid = true
            }

            if check(guess){
                print("Success!")
                sudoku[guess.row][guess.col] = guess.value
            } else{
                print("Doesn't work")
            }

            if sudoku == finish{
                solved = true
                print("You've solved it!")
            }
        }
    }
    

}



extensionViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(test1.text)
    }
}
