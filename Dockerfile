# Stage 1: Install dependencies on Alpine (builder stage)
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy the application files
COPY . .

# Stage 2: Create a lightweight runtime image
FROM node:18-alpine AS runtime

WORKDIR /app

# Install SQLite in the runtime stage (minimal)
RUN apk add --no-cache sqlite

# Copy built application and dependencies from builder stage
COPY --from=builder /app /app

# Set environment variables
ENV SQLITE_DB_LOCATION=/etc/todos/todo.db

# Expose port
EXPOSE 3000

# Start application
CMD ["node", "src/index.js"]
