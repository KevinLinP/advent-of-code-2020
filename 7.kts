import java.io.File

// to run:
// kotlinc -script 7.kts


class Solver() {
    val map = HashMap<String, MutableSet<String>>()

    val lineRegex = Regex("""(.+)\scontain\s(.+).""")
    val rightRegex = Regex("""(\d)\s(.+)""")

    fun solve() {
        parseInput()
    }

    fun parseInput() {
        File("7.input.sample").forEachLine {
            val matchResult = lineRegex.find(it)
            val groups = matchResult!!.groups

            val left = groups.get(1)!!.value
            val rightArray = groups.get(2)!!.value.split(", ")

            parseLine(left, rightArray)
        }
    }

    // TODO: holy shit come up with better names for this crap
    fun parseLine(left: String, rightArray: Collection<String>) {
        println(left)

        for(right in rightArray) {
            val matchResult = rightRegex.find(right)
            if (matchResult == null) { continue } // contain no other bags case

            val rightType = matchResult.groups.get(2)!!.value
            println(rightType)

            var parentSet = map[right]
            if (parentSet == null) {
                parentSet = HashSet<String>()
                parentSet.add(left)
                map[rightType] = parentSet
            } else {
                parentSet.add(left)
            }
        }

        println()
    }
}

Solver().solve()
