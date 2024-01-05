# Gunakan gambar Node.js versi 16 berbasis Debian Buster
FROM node:16-buster

# Setel direktori kerja ke /app
WORKDIR /app

# Salin seluruh konten proyek ke direktori kerja
COPY . .

# Expose port yang digunakan oleh aplikasi React (misalnya, port 3000)
EXPOSE 3400

# Perintah yang akan dijalankan saat container dijalankan
CMD ["npm", "start"]