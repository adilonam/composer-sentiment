#!/bin/bash

# Docker Compose Management Script

set -e

COMPOSE_FILE="docker-compose.yml"

function show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  start     Start all services"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  logs      Show logs for all services"
    echo "  status    Show status of all services"
    echo "  clean     Stop and remove all containers, networks, and volumes"
    echo "  ssl       Generate SSL certificates"
    echo "  help      Show this help message"
    echo ""
}

function start_services() {
    echo "Starting services..."
    docker-compose up -d
    echo "Services started successfully!"
    echo ""
    echo "Access URLs:"
    echo "- Keycloak: https://localhost"
    echo "- Keycloak Admin: https://localhost/admin"
    echo "- Admin credentials: admin/admin"
}

function stop_services() {
    echo "Stopping services..."
    docker-compose down
    echo "Services stopped successfully!"
}

function restart_services() {
    echo "Restarting services..."
    docker-compose restart
    echo "Services restarted successfully!"
}

function show_logs() {
    docker-compose logs -f
}

function show_status() {
    docker-compose ps
}

function clean_all() {
    echo "Cleaning up all containers, networks, and volumes..."
    read -p "Are you sure? This will remove all data! (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v --remove-orphans
        docker system prune -f
        echo "Cleanup completed!"
    else
        echo "Cleanup cancelled."
    fi
}

function generate_ssl() {
    ./generate-ssl.sh
}

# Main script logic
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_all
        ;;
    ssl)
        generate_ssl
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac
