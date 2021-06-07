## House Price Prediction in Jakarta by Reza Lutfi Ismail 

# Introduction
Project ini adalah berisikan dashboard mengenai prediksi harga rumah di jakarta. problem yang saya angkat pada project ini adalah untuk memberikan insight referensi dalam penentuan harga rumah dengan spesifikasi dan lokasi tertentu, berdasarkan data pada website property yaitu lamudi.com 

Data yang saya ambil adalah data hasil Extract, Transform dan Load (web scraping) yang saya lakukan pada website lamudi.com. karena seperti yang kita ketahui, untuk mendapatkan data yang kita inginkan di Indonesia sangatlah sulit

# Dependencies
Menggunakan software R Studio dengan menggunakan package: 

- rvest (web scraping HTML)
- Leaflet (Plot Map)
- Plotly (Interactive Plot)
- randomForest (Modeling with Random Forest Algorithm)
- tidyverse (data wrangling)

# ETL (Extract, Transform dan Load)
<img src = 'asset/1.jpg'>
<img src = 'asset/2.jpg'>

melakukan extracting pada website 

# Scraping
menarik data pada URL dengan memilih area pada HTML. lalu disajikan dengan menggunakan beautifulsoup. output dari proses ini adalah 
berupa list yang nantinya akan diproses lebih lanjut oleh pandas

<img src='asset/SC.png'>

# Data Wrangling
memproses data yang sebelumnya berupa list, menjadi dataframe dengan tipe data yang sesuai dengan menggunakan pandas. dilakukan juga 
sorting untuk menentukan film dengan rating tertinggi. output dari proses ini adalah data yang bersih dan siap untuk divisualisasikan

# Data Visualization
tahap ini yaitu menyajikan datframe kedalam bentuk plot (bar) agar data lebih menarik dan mudah untuk dipahami

<img src='plot1.png'>

## Conclusion
pada projek ini, dapat kita ketahui bahwa pada URL: https://www.imdb.com/search/title/?release_date=2019-01-01,2019-12-31, 7 film 
dengan rating tertinggi secara urut adalah: Chernobyl, The Boys, The Mandalorian, Gisaengchung, Joker, What We Do in the Shadows dan 
The Morning Show

untuk lebi lanjut, anda dapat mengunjungi link dashboard saya pada link berikut: 
https://rezalutfi40.shinyapps.io/DCD_house_price_prediction/



