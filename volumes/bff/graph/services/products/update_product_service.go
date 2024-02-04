package products

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IUpdateProductService interface {
	UpdateProduct(ctx context.Context, id string, input *model.UpdateProductInput) (model.UpdateProductResult, error)
}

type UpdateProductService struct{}

func (u *UpdateProductService) UpdateProduct(ctx context.Context, id string, input *model.UpdateProductInput) (model.UpdateProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s", cfg.BackendUrl, id)

	requestBody, err := json.Marshal(input)
	if err != nil {
		return u.handleServerError(), nil
	}

	req, err := http.NewRequest(http.MethodPatch, url, bytes.NewBuffer(requestBody))
	if err != nil {
		return u.handleServerError(), nil
	}

	req.Header.Set("Content-Type", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return u.handleServerError(), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return u.handleServerError(), nil
	}

	var response struct {
		ID   int    `json:"id"`
		Name string `json:"name"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return u.handleServerError(), nil
	}

	result := model.UpdateProductResultSuccess{
		Ok: true,
		Product: &model.Product{
			ID:   strconv.Itoa(response.ID),
			Name: response.Name,
		},
	}

	return result, nil
}

func (u *UpdateProductService) handleServerError() model.UpdateProductResultError {
	return model.UpdateProductResultError{
		Ok: false,
		Error: model.UpdateProductResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
