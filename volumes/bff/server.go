package main

import (
	"log"
	"net/http"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/kuroweb/price-monitoring/volumes/bff/config"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph"
	"github.com/kuroweb/price-monitoring/volumes/bff/graph/services"
	"github.com/kuroweb/price-monitoring/volumes/bff/internal"
	// "github.com/rs/cors"
)

// TODO: ロギングを行う

func main() {
	cfg := config.NewConfig()

	srv := handler.NewDefaultServer(internal.NewExecutableSchema(internal.Config{Resolvers: &graph.Resolver{
		Srv: services.New(),
	}}))
	// TODO: CORSが動作していなさそうなので後で修正する
	// c := cors.New(cors.Options{
	// 	AllowedOrigins:   []string{cfg.AllowedOrigin},
	// 	AllowCredentials: true,
	// })

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	// TODO: CORSが動作していなさそうなので後で修正する
	// http.Handle("/query", c.Handler(srv))
	http.Handle("/query", srv)

	log.Printf("connect to http://localhost:%s/ for GraphQL playground", cfg.Port)
	log.Fatal(http.ListenAndServe(":"+cfg.Port, nil))
}
