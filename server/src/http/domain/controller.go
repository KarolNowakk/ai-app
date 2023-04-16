package domain

import (
	"net/http"
)

type (
	Controller interface {
		RegisterRoutes(mux *http.ServeMux) *http.ServeMux
	}
)
