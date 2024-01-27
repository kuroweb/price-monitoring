package products

import (
	"context"
	"fmt"
	"net/http"

	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

type IDeleteService interface {
	DeleteById(ctx context.Context, id string) (model.DeleteProductResult, error)
}

type DeleteService struct{}

func (d *DeleteService) DeleteById(ctx context.Context, id string) (model.DeleteProductResult, error) {
	cfg := config.NewConfig()
	url := fmt.Sprintf("%s/api/v1/products/%s", cfg.BackendUrl, id)
	client := &http.Client{}

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		result := model.DeleteProductResultError{
			Ok: false,
			Error: model.DeleteProductResultValidationFailed{
				Code:    "503",
				Message: "Service is currently unavailable.",
				Details: []*model.ErrorDetail{},
			},
		}

		return result, nil
	}

	resp, err := client.Do(req)
	if err != nil {
		return d.handleServerError(), nil
	}
	defer resp.Body.Close()

	switch resp.StatusCode {
	case http.StatusOK:
		return model.DeleteProductResultSuccess{Ok: true}, nil
	case http.StatusNotFound:
		return model.DeleteProductResultError{
			Ok: false,
			Error: model.DeleteProductResultValidationFailed{
				Code:    "404",
				Message: "Requested resource was not found.",
				Details: []*model.ErrorDetail{},
			},
		}, nil
	default:
		return d.handleServerError(), nil
	}
}

func (d *DeleteService) handleServerError() model.DeleteProductResultError {
	return model.DeleteProductResultError{
		Ok: false,
		Error: model.DeleteProductResultValidationFailed{
			Code:    "503",
			Message: "Service is currently unavailable.",
			Details: []*model.ErrorDetail{},
		},
	}
}
