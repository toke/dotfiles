package main

import (
    "fmt"
    "os"

    "github.com/shirou/gopsutil/load"
    "github.com/shirou/gopsutil/cpu"
)



func main() {
    l, _ := load.Avg()
    co, _ := cpu.Counts(true)


    fmt.Println(l.Load1)
    fmt.Println(l.Load1)
    if (l.Load1 >= float64(co)) {
        fmt.Println("#FF0000")
        os.Exit(33)
    }
}
