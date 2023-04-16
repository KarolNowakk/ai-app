package interfaces

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/sirupsen/logrus"

	"app1/src/auth/infrastructure"
	"app1/src/exercises/domain"
	"app1/src/http/interfaces"
)

type (
	ExerciseDTO struct {
		ID       int64        `json:"id"`
		Text     string       `json:"text"`
		UseSRS   bool         `json:"use_srs"`
		Title    string       `json:"title"`
		Messages []MessageDTO `json:"messages"`
	}

	MessageDTO struct {
		Role    string `json:"role"`
		Content string `json:"content"`
	}

	Controller struct {
		adapter     domain.ExerciseAdapter
		authService infrastructure.AuthService
	}
)

func (dto *ExerciseDTO) toDomain() *domain.Exercise {
	messages := make([]domain.Message, len(dto.Messages))
	for i, message := range dto.Messages {
		messages[i].Role = message.Role
		messages[i].Content = message.Content
	}

	return &domain.Exercise{
		ID:       dto.ID,
		Text:     dto.Text,
		UseSRS:   dto.UseSRS,
		Title:    dto.Title,
		Messages: messages,
	}
}

func (dto *ExerciseDTO) fromDomain(exercise *domain.Exercise) {
	dto.ID = exercise.ID
	dto.Text = exercise.Text
	dto.UseSRS = exercise.UseSRS
	dto.Title = exercise.Title

	messages := make([]MessageDTO, len(exercise.Messages))
	for i, message := range exercise.Messages {
		messages[i].Role = message.Role
		messages[i].Content = message.Content
	}

	dto.Messages = messages
}

func ProvideExercisesController(
	adapter domain.ExerciseAdapter,
	authService infrastructure.AuthService,
) *Controller {
	c := new(Controller)
	c.adapter = adapter
	c.authService = authService

	return c
}

func (c *Controller) GetAll(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(interfaces.UserIDKey)
	exercises := c.adapter.GetAll(userID.(int64))

	dtoExercises := make([]ExerciseDTO, len(exercises))
	for i, exercise := range exercises {
		dtoExercises[i].fromDomain(&exercise)
	}

	exerciseJSON, _ := json.Marshal(dtoExercises)

	interfaces.SuccessResponse(w, string(exerciseJSON))
}

func (c *Controller) Create(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(interfaces.UserIDKey)

	var dtoExercise ExerciseDTO
	if err := json.NewDecoder(r.Body).Decode(&dtoExercise); err != nil {
		interfaces.BadRequestResponse(w, err.Error())
		return
	}

	exercise := dtoExercise.toDomain()
	if err := c.adapter.Create(userID.(int64), *exercise); err != nil {
		logrus.Error("error creating new exercise: " + err.Error())
		interfaces.InternalServerErrorResponse(w, err.Error())
		return
	}

	interfaces.SuccessResponse(w, "bravo!")
}

func (c *Controller) Update(w http.ResponseWriter, r *http.Request) {
	var dtoExercise ExerciseDTO
	if err := json.NewDecoder(r.Body).Decode(&dtoExercise); err != nil {
		interfaces.BadRequestResponse(w, err.Error())
		return
	}

	exercise := dtoExercise.toDomain()

	if err := c.adapter.Update(*exercise); err != nil {
		logrus.Error("error updating exercise: " + err.Error())
		interfaces.InternalServerErrorResponse(w, err.Error())
		return
	}

	interfaces.SuccessResponse(w, "bravo!")
}

func (c *Controller) Delete(w http.ResponseWriter, r *http.Request) {
	exerciseID := r.URL.Path[len("/exercises/delete/"):]
	if exerciseID == "" {
		interfaces.BadRequestResponse(w, "exercise_id param is missing")
		return
	}

	exerciseIDInt, err := strconv.ParseInt(exerciseID, 10, 64)
	if err != nil {
		interfaces.BadRequestResponse(w, err.Error())
		return
	}

	if err := c.adapter.Delete(exerciseIDInt); err != nil {
		logrus.Error("error deleting exercise: " + err.Error())
		interfaces.InternalServerErrorResponse(w, err.Error())
		return
	}

	interfaces.SuccessResponse(w, "bravo!")
}
