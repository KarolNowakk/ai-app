package interfaces

import (
	"encoding/json"
	"net/http"
	"strconv"

	"app1/src/http/interfaces"
	"app1/src/words/domain"
)

type Controller struct {
	wordAdapter domain.WordAdapter
}

type WordDTO struct {
	ID         int64   `json:"id"`
	Word       string  `json:"word"`
	LastReview string  `json:"last_review"`
	Interval   int     `json:"interval"`
	EaseFactor float32 `json:"ease_factor"`
	Repetition int     `json:"repetition"`
}

func ProvideWordController(wordAdapter domain.WordAdapter) *Controller {
	return &Controller{wordAdapter: wordAdapter}
}

func (w *Controller) GetAll(wr http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(interfaces.UserIDKey)
	words := w.wordAdapter.GetAll(userID.(int64))

	wordDTOs := make([]WordDTO, len(words))
	for i, word := range words {
		wordDTOs[i] = WordDTO{
			ID:         word.ID,
			Word:       word.Word,
			LastReview: word.LastReview,
			Interval:   word.Interval,
			EaseFactor: word.EaseFactor,
			Repetition: word.Repetition,
		}
	}

	resp, err := json.Marshal(wordDTOs)
	if err != nil {
		interfaces.InternalServerErrorResponse(wr, err.Error())
		return
	}

	interfaces.SuccessResponse(wr, string(resp))
}

func (w *Controller) Create(wr http.ResponseWriter, r *http.Request) {
	var wordDTO WordDTO
	if err := json.NewDecoder(r.Body).Decode(&wordDTO); err != nil {
		interfaces.BadRequestResponse(wr, err.Error())
		return
	}

	userID := r.Context().Value(interfaces.UserIDKey)
	word := domain.Word{
		ID:         wordDTO.ID,
		Word:       wordDTO.Word,
		LastReview: wordDTO.LastReview,
		Interval:   wordDTO.Interval,
		EaseFactor: wordDTO.EaseFactor,
		Repetition: wordDTO.Repetition,
	}

	if err := w.wordAdapter.Create(userID.(int64), word); err != nil {
		interfaces.InternalServerErrorResponse(wr, err.Error())
		return
	}

	interfaces.SuccessResponse(wr, "Word created successfully!")
}

func (w *Controller) Update(wr http.ResponseWriter, r *http.Request) {
	var wordDTO WordDTO
	if err := json.NewDecoder(r.Body).Decode(&wordDTO); err != nil {
		interfaces.BadRequestResponse(wr, err.Error())
		return
	}

	word := domain.Word{
		ID:         wordDTO.ID,
		Word:       wordDTO.Word,
		LastReview: wordDTO.LastReview,
		Interval:   wordDTO.Interval,
		EaseFactor: wordDTO.EaseFactor,
		Repetition: wordDTO.Repetition,
	}

	if err := w.wordAdapter.Update(word); err != nil {
		interfaces.InternalServerErrorResponse(wr, err.Error())
		return
	}

	interfaces.SuccessResponse(wr, "Word updated successfully!")
}

func (w *Controller) Delete(wr http.ResponseWriter, r *http.Request) {
	wordIDStr := r.URL.Path[len("/words/delete/"):]
	if wordIDStr == "" {
		interfaces.BadRequestResponse(wr, "word id param is missing")
		return
	}

	wordID, err := strconv.ParseInt(wordIDStr, 10, 64)
	if err != nil {
		interfaces.BadRequestResponse(wr, err.Error())
		return
	}

	if err := w.wordAdapter.Delete(wordID); err != nil {
		interfaces.InternalServerErrorResponse(wr, err.Error())
		return
	}

	interfaces.SuccessResponse(wr, "Word deleted successfully!")
}
