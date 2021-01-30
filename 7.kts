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
        parseInput("7.input")
        printTree()
        //printInverseTree()
        printDescendantCount("shiny gold")
        //printParents("shiny gold")
    }

    private fun printDescendantCount(parent: String) {
        var count = 0
        val queue = LinkedList<Pair<String, Int>>()
        queue.addLast(Pair(parent, 1))

        // this would be much more efficient if can cache the result
        // of subtrees
        while (queue.size > 0) {
            val currentPair = queue.removeFirst()
            val currentType = currentPair.first
            val currentCount = currentPair.second

            val children = tree[currentType]
            if (children == null) { continue }

            for ((childType, childCount) in children) {
                val childTotalCount = (currentCount * childCount)
                count += childTotalCount
                queue.addLast(Pair(childType, childTotalCount))
            }
        }

        println("$parent descendantCount: $count")
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

    private fun printTree() {
        println("tree:")
        for ((parent, children) in tree) {
            println("'$parent'")
            for ((childType, childValue) in children) {
                println("'$childType' $childValue")
            }
            println()
        }
    }

    private fun printInverseTree() {
        println("inverseTree:")
        for ((child, parents) in inverseTree) {
            println("'$child'")
            for (parent in parents) {
                println("'$parent'")
            }
            println()
        }
    }

    private fun parseInput(path: String) {
        File(path).forEachLine {
            val matchResult = lineRegex.find(it)
            val groups = matchResult!!.groups

            val parent = groups.get(1)!!.value
            val childStrings = groups.get(2)!!.value.split(", ")

            parseLine(parent, childStrings)
        }
    }

    private fun parseLine(parent: String, childStrings: Collection<String>) {
        //println(parent)
        var children = tree[parent]
        if (children == null) {
            children = HashMap<String, Int>()
            tree[parent] = children
        }

        for(childString in childStrings) {
            //println(childString)
            val matchResult = childRegex.find(childString)
            if (matchResult == null) { continue } // contain no other bags case

            val childCount = matchResult.groups.get(1)!!.value.toInt()
            val childType = matchResult.groups.get(2)!!.value
            //println(childType)

            children[childType] = childCount

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
