#!/usr/bin/env sh

# Pengecekan apakah Vercel CLI sudah terinstal
if ! command -v vercel &> /dev/null; then
    echo "Vercel CLI belum terinstal. Melakukan instalasi..."
    npm install  vercel
else
    echo "Vercel CLI sudah terinstal."
fi

# Menampilkan versi Vercel CLI
vercel --version