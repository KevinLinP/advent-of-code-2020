import Foundation

class Solver {
    var operations = [(String, Int)]()

    func solve() {
        parseInput()
        /*printOperations()*/
        runUntilLoop()
    }

    func runUntilLoop() {
        var pointer = 0
        var acc = 0
        var visited = Array(repeating: false, count: operations.count)

        while (!visited[pointer]) {
            visited[pointer] = true
            let (op, num) = operations[pointer]
            print("\(op) \(num)")

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
        }

        print("loop acc:\(acc) pointer:\(pointer)")
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
