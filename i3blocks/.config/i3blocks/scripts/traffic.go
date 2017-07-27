package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/shirou/gopsutil/net"
)

type I3Block struct {
	ShortText string `json:"short_text"`
	FullText  string `json:"full_text"`
	Color     string `json:"color,omitempty"`
}

type Counter struct {
	curr CounterP
	last CounterP
}

type CounterP struct {
	Sent uint64
	Recv uint64
}

func (c *Counter) probe(sent, recv uint64) {
	c.last.Recv = c.curr.Recv
	c.last.Sent = c.curr.Sent
	c.curr.Recv = recv
	c.curr.Sent = sent
}

func (c *Counter) sample() CounterP {
	a := CounterP{}
	a.Sent = (c.curr.Sent - c.last.Sent)
	a.Recv = (c.curr.Recv - c.last.Recv)
	return a
}

func (c *Counter) getSample() {
	n, _ := net.IOCounters(true)
	for _, iface := range n {
                //if iface.Name == "wlp2s0" {
		if iface.Name == "eno1" {
			c.probe(iface.BytesSent, iface.BytesRecv)
		}
	}
}

func main() {
	var msg I3Block
	stats := Counter{}
	stats.getSample()
	for true == true {
		//fmt.Println(stats.sample())
		time.Sleep(1000 * time.Millisecond)
		stats.getSample()

		s := stats.sample()

		msg = I3Block{
			FullText:  fmt.Sprintf(" %3.1fkb/s  %3.1fkb/s", float64(s.Recv)/1024, float64(s.Sent)/1024),
			ShortText: fmt.Sprintf(" %3.1fkb/s", float64(s.Recv)/1024)}
		jsonMsg, _ := json.Marshal(msg)
		fmt.Printf("%s\n", jsonMsg)
	}
}
