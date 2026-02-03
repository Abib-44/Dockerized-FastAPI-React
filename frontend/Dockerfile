# Usa immagine Node ufficiale
FROM node:18-alpine

# Imposta la working directory
WORKDIR /app

# Copia package.json e package-lock.json
COPY package.json package-lock.json ./

# Installa le dipendenze
RUN npm install

# Copia il resto del codice
COPY . .

# Esponi porta di default React
EXPOSE 5173

CMD ["npm", "run", "dev"]

