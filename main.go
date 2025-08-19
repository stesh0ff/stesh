package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/gorilla/mux"
)

// staticFileServer serves static files with proper caching headers.
func staticFileServer(w http.ResponseWriter, r *http.Request) {
	// Get the file path from the URL
	filePath := r.URL.Path
	if filePath == "/" {
		filePath = "/index.html"
	}

	// Remove the leading slash
	filePath = filePath[1:]

	// Security check to prevent directory traversal
	if filepath.IsAbs(filePath) || filepath.Clean(filePath) != filePath {
		http.Error(w, "Invalid file path", http.StatusBadRequest)
		return
	}

	// Check if file exists
	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		http.Error(w, "File not found", http.StatusNotFound)
		return
	}

	// Set appropriate content type based on file extension
	ext := filepath.Ext(filePath)
	switch ext {
	case ".html":
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
	case ".css":
		w.Header().Set("Content-Type", "text/css")
	case ".js":
		w.Header().Set("Content-Type", "application/javascript")
	case ".ico":
		w.Header().Set("Content-Type", "image/x-icon")
	}

	// Set caching headers for static assets
	if ext == ".css" || ext == ".js" || ext == ".ico" {
		w.Header().Set("Cache-Control", "public, max-age=86400") // 24 hours
	}

	// Serve the file
	http.ServeFile(w, r, filePath)
}

// healthCheck endpoint for monitoring.
func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"status":"ok","timestamp":"%s"}`, time.Now().Format(time.RFC3339))
}

// loggingMiddleware logs all HTTP requests.
func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		// Call the next handler
		next.ServeHTTP(w, r)

		// Log the request
		log.Printf(
			"%s %s %s %v",
			r.Method,
			r.RequestURI,
			r.RemoteAddr,
			time.Since(start),
		)
	})
}

func main() {
	// Create router
	r := mux.NewRouter()

	// Add logging middleware
	r.Use(loggingMiddleware)

	// Health check endpoint
	r.HandleFunc("/health", healthCheck).Methods("GET")

	// Serve static files
	r.PathPrefix("/").HandlerFunc(staticFileServer)

	// Get primary port from environment variable or use default
	primaryPort := os.Getenv("PORT")
	if primaryPort == "" {
		primaryPort = "8080"
	}

	// Define all ports to listen on
	ports := []string{primaryPort}

	// Add port 80 if not already included and if we're not in development mode
	if primaryPort != "80" && os.Getenv("ENABLE_PORT_80") != "false" {
		ports = append(ports, "80")
	}

	log.Printf("🚀 Запуск серверов на портах: %v", ports)
	log.Printf("🌐 Сайт будет доступен по адресам:")
	for _, port := range ports {
		log.Printf("   - http://localhost:%s", port)
		log.Printf("   - http://stesh.net:%s", port)
	}
	log.Printf("❤️  Health check: http://localhost:%s/health", primaryPort)
	log.Printf("🔒 Для HTTPS через Cloudflare: https://stesh.net")

	// Channel to collect errors from servers
	errorChan := make(chan error, len(ports))

	// Start servers for each port
	for i, port := range ports {
		go func(p string, isFirst bool) {
			srv := &http.Server{
				Handler:      r,
				Addr:         ":" + p,
				WriteTimeout: 15 * time.Second,
				ReadTimeout:  15 * time.Second,
				IdleTimeout:  60 * time.Second,
			}

			if isFirst {
				log.Printf("🎯 Основной сервер запущен на порту %s", p)
			} else {
				log.Printf("🔄 Дополнительный сервер запущен на порту %s", p)
			}

			if err := srv.ListenAndServe(); err != nil {
				errorChan <- fmt.Errorf("ошибка сервера на порту %s: %v", p, err)
			}
		}(port, i == 0)
	}

	// Wait for any server to fail
	err := <-errorChan
	log.Fatal(err)
}
