package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.40

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	"net/http"
	"strconv"
	"strings"

	"github.com/kuroweb/price-monitoring/volumes/bff/graph/model"
)

func (r *mutationResolver) CreateTodo(ctx context.Context, input model.NewTodo) (*model.Todo, error) {
	//ランダムな数字の生成
	rand, _ := rand.Int(rand.Reader, big.NewInt(100))
	todo := &model.Todo{
		Text: input.Text,
		ID:   fmt.Sprintf("T%d", rand),
		User: &model.User{ID: input.UserID, Name: "user " + input.UserID},
	}
	//ここでのrはresolver.goで宣言したResolver型を示しているそのため、t.todosはresolver.goで先ほど記述したもの
	r.todos = append(r.todos, todo)
	return todo, nil
}

func (r *queryResolver) Todos(ctx context.Context) ([]*model.Todo, error) {
	return r.todos, nil
}

func (r *queryResolver) Users(ctx context.Context, id *int, name *string) ([]*model.User, error) {
	params := []string{}

	if id != nil {
		params = append(params, fmt.Sprintf("user[id]=%d", *id))
	}

	if name != nil {
		params = append(params, fmt.Sprintf("user[name]=%s", *name))
	}

	paramsStr := strings.Join(params, "&")

	url := "http://backend:3000/api/v1/users?" + paramsStr

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var response struct {
		Users []struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		} `json:"users"`
	}

	if err := json.Unmarshal(body, &response); err != nil {
		return nil, err
	}

	var users []*model.User
	for _, user := range response.Users {
		users = append(users, &model.User{
			ID:   strconv.Itoa(user.ID),
			Name: user.Name,
		})
	}

	return users, nil
}

// GetProduct is the resolver for the getProduct field.
func (r *queryResolver) GetProduct(ctx context.Context, id int) (*model.Product, error) {
	url := fmt.Sprintf("http://backend:3000/api/v1/products/%d", id)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("Failed to fetch product data")
	}

	var response struct {
		ID     int    `json:"id"`
		UserID int    `json:"user_id"`
		Name   string `json:"name"`
		Price  int    `json:"price"`
	}

	decoder := json.NewDecoder(resp.Body)
	if err := decoder.Decode(&response); err != nil {
		return nil, err
	}

	product := &model.Product{
		ID:     strconv.Itoa(response.ID),
		UserID: strconv.Itoa(response.UserID),
		Name:   response.Name,
		Price:  response.Price,
	}

	return product, nil
}

// Products is the resolver for the products field.
func (r *queryResolver) Products(ctx context.Context, id *int, userID *int, name *string, price *int) ([]*model.Product, error) {
	params := []string{}

	if id != nil {
		params = append(params, fmt.Sprintf("product[id]=%d", *id))
	}

	if userID != nil {
		params = append(params, fmt.Sprintf("product[user_id]=%d", *userID))
	}

	if name != nil {
		params = append(params, fmt.Sprintf("product[name]=%s", *name))
	}

	if price != nil {
		params = append(params, fmt.Sprintf("product[price]=%d", *price))
	}

	paramsStr := strings.Join(params, "&")

	url := "http://backend:3000/api/v1/products?" + paramsStr

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var response struct {
		Products []struct {
			ID     int    `json:"id"`
			UserID int    `json:"user_id"`
			Name   string `json:"name"`
			Price  int    `json:"price"`
		} `json:"products"`
	}

	if err := json.Unmarshal(body, &response); err != nil {
		return nil, err
	}

	var products []*model.Product

	for _, product := range response.Products {
		products = append(products, &model.Product{
			ID:     strconv.Itoa(product.ID),
			UserID: strconv.Itoa(product.UserID),
			Name:   product.Name,
			Price:  product.Price,
		})
	}

	return products, nil
}

// Mutation returns MutationResolver implementation.
func (r *Resolver) Mutation() MutationResolver { return &mutationResolver{r} }

// Query returns QueryResolver implementation.
func (r *Resolver) Query() QueryResolver { return &queryResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
