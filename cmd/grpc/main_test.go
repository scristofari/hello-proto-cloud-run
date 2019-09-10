package main_test

import (
	"testing"
)

func TestSayHello(t *testing.T) {
	message := ""
	expected := ""

	if message != expected {
		t.Errorf("failed to say hello, expected %s, got %s", expected, message)
	}
}
