import java.io.File
import java.util.LinkedList

// to run:
// kotlinc -script 7.kts

class Solver() {
    val inverseTree = HashMap<String, MutableSet<String>>()
    val tree = HashMap<String, MutableMap<String, Int>>()

    val lineRegex = Regex("""(.+) bags contain (.+).""")
    val childRegex = Regex("""(\d+) (.+) bags?""")

    fun solve() {
        parseInput()
        printInverseTree()
        printParents("shiny gold")
    }

    private fun printParents(child: String) {
        val allParents = HashSet<String>()
        val queue = LinkedList<String>()
        queue.addLast(child)

        while (queue.size > 0) {
            val current = queue.removeFirst()
            val currentParents = inverseTree[current]

            if (currentParents != null) {
                for (currentParent in currentParents) {
                    if (!allParents.contains(currentParent)) {
                        allParents.add(currentParent)
                        queue.addLast(currentParent)
                    }
                }
            }
        }

        println("$child allParents:")
        for (parent in allParents) {
            println(parent)
        }
        println(allParents.size)
    }

    private fun printInverseTree() {
        println("inverseTree:")
        for (child in inverseTree.keys) {
            println("'$child'")
            val parents = inverseTree[child]
            if (parents != null) {
                for (parent in parents) {
                    println("'$parent'")
                }
            }
            println()
        }
    }

    private fun parseInput() {
        File("7.input.sample").forEachLine {
            val matchResult = lineRegex.find(it)
            val groups = matchResult!!.groups

            val parent = groups.get(1)!!.value
            val childStrings = groups.get(2)!!.value.split(", ")

            parseLine(parent, childStrings)
        }
    }

    private fun parseLine(parent: String, childStrings: Collection<String>) {
        //println(parent)

        for(childString in childStrings) {
            //println(childString)
            val matchResult = childRegex.find(childString)
            if (matchResult == null) { continue } // contain no other bags case

            val childType = matchResult.groups.get(2)!!.value
            //println(childType)

            var parents = inverseTree[childType]
            if (parents == null) {
                parents = HashSet<String>()
                parents.add(parent)
                inverseTree[childType] = parents
            } else {
                parents.add(parent)
            }
        }

        //println()
    }
}

Solver().solve()
