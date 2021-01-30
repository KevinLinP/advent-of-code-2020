import java.io.File
import java.util.LinkedList

// to run:
// kotlinc -script 7.kts

class Solver() {
    val containees = HashMap<String, MutableSet<String>>()

    val lineRegex = Regex("""(.+) bags contain (.+).""")
    val rightRegex = Regex("""(\d+) (.+) bags?""")

    fun solve() {
        parseInput()
        printContainees()
        printDescendants("shiny gold")
    }

    private fun printDescendants(start: String) {
        val descendants = HashSet<String>()
        val queue = LinkedList<String>()
        queue.addLast(start)

        while (queue.size > 0) {
            val current = queue.removeFirst()
            val containers = containees[current]

            if (containers != null) {
                for (container in containers) {
                    if (!descendants.contains(container)) {
                        descendants.add(container)
                        queue.addLast(container)
                    }
                }
            }
        }

        println("descendants:")
        for (descendant in descendants) {
            println(descendant)
        }
        println(descendants.size)
    }

    private fun printContainees() {
        println("containees:")
        for (containee in containees.keys) {
            println("'$containee'")
            val containers = containees[containee]
            if (containers != null) {
                for (container in containers) {
                    println("'$container'")
                }
            }
            println()
        }
    }

    private fun parseInput() {
        File("7.input").forEachLine {
            val matchResult = lineRegex.find(it)
            val groups = matchResult!!.groups

            val left = groups.get(1)!!.value
            val rightArray = groups.get(2)!!.value.split(", ")

            parseLine(left, rightArray)
        }
    }

    // TODO: holy shit come up with better names for this crap
    private fun parseLine(left: String, rightArray: Collection<String>) {
        println(left)

        for(right in rightArray) {
            //println(right)
            val matchResult = rightRegex.find(right)
            if (matchResult == null) { continue } // contain no other bags case

            val rightType = matchResult.groups.get(2)!!.value
            println(rightType)

            var containers = containees[rightType]
            if (containers == null) {
                containers = HashSet<String>()
                containers.add(left)
                containees[rightType] = containers
            } else {
                containers.add(left)
            }
        }

        println()
    }
}

Solver().solve()
