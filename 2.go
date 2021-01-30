// it was strange to write, but feels fine reading.
// feels like a barebones language

package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "regexp"
    "strconv"
    //"strings"
)

var regex = regexp.MustCompile(`(\d+)-(\d+) (.): (.*)`)

func main() {
    numValidStrings := 0

    file, err := os.Open("2.input")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        if isValid(scanner.Text()) {
          numValidStrings += 1
        }
    }

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }

    fmt.Println(numValidStrings)
}

func isValid(line string) bool {
    matches := regex.FindStringSubmatch(line)

    num1, _ := strconv.Atoi(matches[1])
    num2, _ := strconv.Atoi(matches[2])
    char := matches[3][0]
    password := matches[4]

    //count := strings.Count(password, char)

    fmt.Printf("%d %d %s %#v %d\n", num1, num2, char, password)

    first_char := password[num1 - 1]
    second_char := password[num2 - 1]

    return ((first_char == char) || (second_char == char)) && (first_char != second_char)
}
