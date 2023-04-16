package interfaces

import (
	"context"
	"net/http"
	"strings"

	"app1/src/auth/infrastructure"
)

const UserIDKey = "userID"

type (
	AuthMiddleware struct {
		authService infrastructure.AuthService
	}
)

func ProvideAuthMiddleware(authService infrastructure.AuthService) *AuthMiddleware {
	return &AuthMiddleware{authService: authService}
}

func (c *AuthMiddleware) WithAuth(next http.HandlerFunc) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		id, err := c.authorize(req.Context(), req)
		if err != nil {
			UnauthorizedResponse(w, "unauthorized, sorry")
			return
		}

		ctx := context.WithValue(req.Context(), UserIDKey, id)
		next.ServeHTTP(w, req.WithContext(ctx))
	})
}

func (c *AuthMiddleware) authorize(ctx context.Context, r *http.Request) (int64, error) {
	token := r.Header.Get("Authorization")
	token = splitTokenHeader(token)

	return c.authService.GetUserID(ctx, token)
}

func splitTokenHeader(authHeader string) string {
	splitValues := strings.Split(authHeader, " ")
	if len(splitValues) > 1 {
		return splitValues[1]
	}
	return ""
}
