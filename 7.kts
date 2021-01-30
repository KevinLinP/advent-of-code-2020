import java.io.File
import java.util.LinkedList

// to run:
// kotlinc -script 7.kts

class Solver() {
    val inverseTree = HashMap<String, MutableSet<String>>()
    val tree = HashMap<String, MutableMap<String, Int>>()
    val selfAndDescendantCounts = HashMap<String, Int>()

    val lineRegex = Regex("""(.+) bags contain (.+).""")
    val childRegex = Regex("""(\d+) (.+) bags?""")

    fun solve() {
        parseInput("7.input")
        printTree()
        //printInverseTree()
        printDescendantCount("shiny gold")
        //printParents("shiny gold")
    }

    private fun printDescendantCount(type: String) {
        val count = selfAndDescendantCount(type) - 1
        println("$type descendantCount: $count")
    }

    private fun selfAndDescendantCount(type: String): Int {
        val cachedCount = selfAndDescendantCounts[type]
        if (cachedCount !== null) { return cachedCount }

        var count = 1

        val children = tree[type]
        if (children != null) {
            for ((childType, childCount) in children) {
                count += (childCount * selfAndDescendantCount(childType))
            }
        }

        selfAndDescendantCounts[type] = count
        return count
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
