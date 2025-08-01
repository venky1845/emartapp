# ---------- Build Frontend ----------
FROM node:14 AS ui-build
WORKDIR /usr/src/app/client
COPY client/ .
RUN npm install && npm run build

# ---------- Build Backend ----------
FROM node:14 AS server-build
WORKDIR /usr/src/app/nodeapi
COPY nodeapi/ .
RUN npm install

# ---------- Final Runtime Image ----------
FROM node:14
WORKDIR /usr/src/app

# Copy backend files from build
COPY --from=server-build /usr/src/app/nodeapi/ ./

# Copy frontend build into backend's static directory
COPY --from=ui-build /usr/src/app/client/dist ./client/dist

# Optional: list files for verification (remove in production)
RUN ls -la && ls -la client/dist

# Expose backend (5000) and frontend (4200) ports (if needed separately)
EXPOSE 5000
EXPOSE 4200

# Start the backend server
CMD ["npm", "start"]

