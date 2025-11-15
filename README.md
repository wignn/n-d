# Novel-S

A modern web novel platform built with Rust backend (Novel API) and Svelte.

## Quick Start

### Prerequisites

- Docker & Docker Compose
- Make (GNU Make)
- Git
- K6 (for load testing)

### Clone with Submodules

```bash
# Clone the repository with submodules
git clone --recursive https://github.com/wignn/novel-s.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### Available Commands

Run `make help` to see all available commands:

```bash
make help
```

### Common Commands

```bash
# Build and start all services
make build
make up

# Or rebuild everything
make rebuild

# View logs
make logs

# Stop all services
make down

# Check container status
make status
```

## Docker Services

The project uses Docker Compose to manage the following services:

- **Novel API** - Rust backend (from backend submodule)
- **PostgreSQL** - Database
- **Redis** - Caching
- **InfluxDB** - Metrics storage (for load testing)
- **Grafana** - Metrics visualization

## Testing

### Run Load Tests

```bash
make start-load-test
```

### Run Unit Tests

```bash
make test
```

## Development

### Start in Development Mode

```bash
make dev
```

### Format Code

```bash
make fmt
```

### Run Linter

```bash
make lint
```

## Database Operations

### Run Migrations

```bash
make db-migrate
```

### Reset Database (⚠️ Destroys all data)

```bash
make db-reset
```

## Utility Commands

### Open Shell in API Container

```bash
make shell
```

### Clean Up Docker Resources

```bash
# Remove all containers, volumes, and images
make clean

# Prune unused Docker resources
make prune
```

## Git Submodules

This project uses git submodules for the backend:

```bash
# Update submodules to latest commit
git submodule update --remote

# Pull latest changes including submodules
git pull --recurse-submodules
```

## Environment Variables

Create a `.env` file in the root directory for custom configuration
