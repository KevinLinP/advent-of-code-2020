import "wasi";
import { Console, FileSystem } from "as-wasi";

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

  let count = 0
  let current = new Set<String>()

  // assemblyscript hasn't implemented closures nor iterator =(
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]

    if (line === '') {
      let currentCount = current.size
      console.log(currentCount.toString())
      count += currentCount
      current.clear()
    } else {
      const chars = line.split('')
      for (let j = 0; j < chars.length; j++) {
        const char = chars[j]
        current.add(char)
      }
    }
    Console.log(line)
  }

  console.log(count.toString())
}

solve()
