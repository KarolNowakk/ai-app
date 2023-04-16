package interfaces

import (
	"fmt"
	"net/http"
)

func UnauthorizedResponse(w http.ResponseWriter, errMsg string) {
	w.WriteHeader(http.StatusUnauthorized)
	fmt.Fprint(w, errMsg)
}

func InternalServerErrorResponse(w http.ResponseWriter, errMsg string) {
	w.WriteHeader(http.StatusInternalServerError)
	fmt.Fprint(w, errMsg)
}

func BadRequestResponse(w http.ResponseWriter, errMsg string) {
	w.WriteHeader(http.StatusBadRequest)
	fmt.Fprint(w, errMsg)
}

func SuccessResponse(w http.ResponseWriter, body string) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, body)
}
