// implementation notes: parsing sucks, debugging is tricky, looks nice otherwise

import Foundation

class Solver {
    var operations = [(String, Int)]()

    var pointer = 0
    var acc = 0
    var visited = [Bool]()

    func solve() {
        parseInput()
        print("\(operations.count) operations")
        visited = Array(repeating: false, count: operations.count)

        for (op, num) in operations {
            if (op == "acc") { continue }

            let success = runUntilLoop(opToFlip: num)
            if (success) {
                break
            }
        }
    }

    func resetState() {
        pointer = 0
        acc = 0

        for (i, _) in visited.enumerated() {
            visited[i] = false
        }
    }

    func runUntilLoop(opToFlip: Int) -> Bool {
        resetState()

        while (!visited[pointer]) {
            visited[pointer] = true
            var (op, num) = operations[pointer]
            /*print("\(op) \(num)")*/

            if (pointer == opToFlip) {
                op = (op == "jmp") ? "nop" : "jmp"
            }

            switch op {
            case "acc":
                acc += num
                pointer += 1
            case "jmp":
                pointer += num
            case "nop":
                pointer += 1
            default:
                print("unrecognized operator \(op)")
            }

            if (pointer > operations.count || pointer < 0) {
                return false
            } else if (pointer == operations.count) {
                print("unlooped acc:\(acc) pointer:\(pointer) opToFlip:\(opToFlip)")
                return true
            }
        }

        return false
    }

    func printOperations() {
        for (op, num) in operations {
            print("\(op) \(num)")
        }
    }

    func parseInput() {
        let contents = try! String(contentsOfFile: "8.input")
        let regex = try? NSRegularExpression(
          pattern: #"(\w{3}) ([\+-]\d+)"#
        )

        let lines = contents.split(separator:"\n")
        for lineSubstring in lines {
            let line = String(lineSubstring)

            // https://whatdidilearn.info/2018/07/29/how-to-capture-regex-group-values-in-swift.html
            let match = regex!.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count))
            let op = line[Range(match!.range(at: 1), in: line)!]
            let num = Int(line[Range(match!.range(at: 2), in: line)!])!

            operations.append((String(op), num))
        }
    }
}

Solver().solve()
