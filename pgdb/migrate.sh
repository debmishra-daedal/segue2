#!/bin/bash

# Flyway Migration Helper Script for Segue2
# This script provides easy access to common Flyway commands

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed or not in PATH"
    exit 1
fi

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  migrate     - Run all pending migrations"
    echo "  info        - Show migration status and history"
    echo "  validate    - Validate applied migrations"
    echo "  baseline    - Baseline the database (use with caution)"
    echo "  clean       - Clean the database (use with extreme caution)"
    echo "  status      - Show current migration status"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 migrate"
    echo "  $0 info"
    echo "  $0 validate"
}

# Function to check if database is ready
check_db_ready() {
    print_status "Checking if PostgreSQL database is ready..."
    
    if docker-compose ps pgdb | grep -q "Up"; then
        if docker-compose exec pgdb pg_isready -U postgres -d postgres > /dev/null 2>&1; then
            print_success "Database is ready"
            return 0
        else
            print_warning "Database container is running but not ready yet"
            return 1
        fi
    else
        print_error "Database container is not running"
        return 1
    fi
}

# Function to run flyway command
run_flyway() {
    local command=$1
    local args=$2
    
    print_status "Running Flyway command: $command"
    
    if [ "$command" = "migrate" ]; then
        # For migrate, ensure database is ready first
        if ! check_db_ready; then
            print_warning "Database not ready, starting services..."
            docker-compose up -d pgdb
            print_status "Waiting for database to be ready..."
            sleep 10
        fi
    fi
    
    docker-compose run --rm flyway $command $args
    
    if [ $? -eq 0 ]; then
        print_success "Flyway $command completed successfully"
    else
        print_error "Flyway $command failed"
        exit 1
    fi
}

# Main script logic
case "${1:-help}" in
    migrate)
        run_flyway "migrate"
        ;;
    info)
        run_flyway "info"
        ;;
    validate)
        run_flyway "validate"
        ;;
    baseline)
        print_warning "Baseline will mark the database as migrated up to the specified version"
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            run_flyway "baseline"
        else
            print_status "Baseline cancelled"
        fi
        ;;
    clean)
        print_error "CLEAN WILL DELETE ALL DATA IN THE DATABASE!"
        read -p "Are you absolutely sure? Type 'YES' to confirm: " -r
        if [[ $REPLY == "YES" ]]; then
            run_flyway "clean"
        else
            print_status "Clean cancelled"
        fi
        ;;
    status)
        print_status "Checking migration status..."
        run_flyway "info" | grep -E "(Version|Description|State)"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac 