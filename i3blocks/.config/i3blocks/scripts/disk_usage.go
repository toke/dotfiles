package main

import (
    "fmt"
    "os"

    "github.com/shirou/gopsutil/disk"
)


func main() {
    instance := os.Getenv("BLOCK_INSTANCE")
    d, _ := disk.Usage(instance)

    alert := d.UsedPercent >= 90

    // fmt.Println(d)
    if (alert) {
        fmt.Printf("%.1fGB (%.1f%%)\n", float64(d.Free) / 1000 / 1000 / 1000, d.UsedPercent)
    } else {
        fmt.Printf("%.1f%%\n", d.UsedPercent)
    } 
    fmt.Printf("%.1f\n", d.UsedPercent)
    if (alert) {
        fmt.Println("#FF0000")
        os.Exit(33)
    }
}
