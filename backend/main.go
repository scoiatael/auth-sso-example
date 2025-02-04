package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
)

func handleRequest(w http.ResponseWriter, req *http.Request) {
	cookie, err := req.Cookie("visits")
	visits := 1
	if err == nil {
		fmt.Sscanf(cookie.Value, "%d", &visits)
		visits++
	}
	http.SetCookie(w, &http.Cookie{
		Name:    "visits",
		Value:   fmt.Sprintf("%d", visits),
		Expires: time.Now().Add(365 * 24 * time.Hour),
	})
	fmt.Fprintf(w, "It's now %s, you've visited this site %d times", time.Now().Format(time.DateTime), visits)
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		panic(fmt.Sprintf("environment variable not set: PORT"))
	}
	r := mux.NewRouter()
	r.HandleFunc("/", handleRequest)
	http.Handle("/", r)
	fmt.Println("Backend listening on port " + port)
	http.ListenAndServe(":"+port, nil)
}
