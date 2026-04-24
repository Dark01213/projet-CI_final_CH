#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Local Development Setup ===${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"

# Start the application
echo -e "${YELLOW}Starting application with Docker Compose...${NC}"
docker-compose up -d

# Wait for services to be ready
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Check if backend is healthy
echo -e "${YELLOW}Checking backend health...${NC}"
for i in {1..30}; do
    if curl -f http://localhost:5000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Backend is healthy${NC}"
        break
    fi
    echo "Attempt $i/30 - Waiting for backend..."
    sleep 2
done

# Check if frontend is accessible
echo -e "${YELLOW}Checking frontend...${NC}"
for i in {1..30}; do
    if curl -f http://localhost > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Frontend is accessible${NC}"
        break
    fi
    echo "Attempt $i/30 - Waiting for frontend..."
    sleep 2
done

echo -e "${GREEN}=== Application is running! ===${NC}"
echo -e "Frontend: ${GREEN}http://localhost${NC}"
echo -e "Backend API: ${GREEN}http://localhost:5000${NC}"
echo -e "Health Check: ${GREEN}http://localhost:5000/health${NC}"
echo ""
echo -e "To view logs: ${YELLOW}docker-compose logs -f${NC}"
echo -e "To stop: ${YELLOW}docker-compose down${NC}"
