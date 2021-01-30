import "wasi";
import { FileSystem } from "as-wasi";

// compile and run:
// asc 6.ts -b 6.wasm --runtime minimal && wasmtime --dir=. 6.wasm
//
// omit --runtime minimal for a really bad time

const solve = function (): void {
  const descriptor = FileSystem.open('6.input')
  if (!descriptor) { return }

  const input = descriptor.readString()
  if (input === null) { return }

  const lines = input.split("\n")

  let anyTotal = 0
  let allTotal = 0

  // {} as an empty object doesn't exist either
  let any = new Set<String>()
  let all = new Map<String, i32>()
  let personCount = 0

  // assemblyscript hasn't implemented closures nor iterator =(
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]

    if (line !== '') {
      personCount += 1

      const chars = line.split('')
      for (let j = 0; j < chars.length; j++) {
        const char = chars[j]

        any.add(char)

        const charCount = all.has(char) ? all.get(char) : 0
        all.set(char, charCount + 1)
      }
    } else {
      let anyCount = any.size
      console.log(anyCount.toString())
      anyTotal += anyCount
      any.clear()

      let allCount = 0
      const allValues = all.values()
      for (let j = 0; j < allValues.length; j++) {
        if (allValues[j] === personCount) {
          allCount += 1
        }
      }
      console.log(allCount.toString())
      allTotal += allCount
      all.clear()

      personCount = 0
    }
    console.log(line)
  }

  console.log(anyTotal.toString())
  console.log(allTotal.toString())
}

solve()
