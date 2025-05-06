FROM node:20-alpine AS base

# Install bun
RUN npm install -g bun

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json bun.lock ./

# Install dependencies
RUN bun install

# Copy the rest of the app
COPY . .

# Build the app
RUN bun run build

# Production stage
FROM node:20-alpine AS production

# Install bun
RUN npm install -g bun

WORKDIR /app

# Copy built assets from the build stage
COPY --from=base /app/build /app/build
COPY --from=base /app/node_modules /app/node_modules
COPY --from=base /app/package.json /app/package.json

# Expose port
EXPOSE 3000

# Start the app
CMD ["bun", "run", "preview", "--host", "0.0.0.0"]
