package main
import (
	"fmt"
	"log"
	"net/http"
	"github.com/google/uuid"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello World! UUID:", uuid.New())
}

func main(){
	http.HandleFunc("/", helloHandler)
	port := "8080"
	log.Printf("starting server on port %s...\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal(err)
	}
}
