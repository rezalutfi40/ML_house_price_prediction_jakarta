dashboardPage(
  title = "House Price Prediction", 
  skin = "black", 
  dashboardHeader(
    title = span(img(src = "home-solid.svg", 
                     height = 35), 
                 "House Price Prediction"), 
    titleWidth = 300), 
  dashboardSidebar(
    width = 300, 
    sidebarMenu(
      menuItem(
        text = "Home", 
        tabName = "home", 
        icon = icon("fas fa-home")
      ), 
      menuItem(
        text = "EDA", 
        tabName = "EDA", 
        icon = icon("fas fa-search")
      ), 
      menuItem(
        text = "Prediksi Harga", 
        tabName = "prediksi_harga", 
        icon = icon("fas fa-dollar-sign")
      ), 
      menuItem(
        text = "Data Set", 
        tabName = "data", 
        icon = icon("database")
      ), 
      menuItem(
        text = "Profile", 
        tabName = "profil", 
        icon = icon("user")
      )
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "home", 
        fluidRow(
          column(
            width = 12, 
            img(src = "logo_4.jpg")
          )
        )
      ), 
      tabItem(
        tabName = "EDA", 
        fluidRow(
          tabBox(width = 12, height = 700,
                 tabPanel(title = "Variabel Importance", 
                          column(width = 12, 
                                 valueBox(value = "Rp 13.7 Milliar", subtitle = "Harga Maksimum", color = "red", icon = icon("money"), width = 4), 
                                 valueBox(value = "Rp 2.95 Milliar", subtitle = "Harga Rerata", color = "yellow", icon = icon("money"), width = 4),
                                 valueBox(value = "Rp 200 Juta", subtitle = "Harga Minimum", color = "green", icon = icon("money"), width = 4), 
                                 box(width = 12)
                                 ), 
                          column(width = 12, 
                                 plotOutput(outputId = "plot_var_importance")
                                 )
                          ), 
                 tabPanel(title = "Sebaran Data",
                          column(width = 12, 
                                 valueBox(value = "1000", subtitle = "Maksimum Luas Bangunan (m^2)", color = "green", icon = icon("money"), width = 3), 
                                 valueBox(value = "1000", subtitle = "Maksimum Luas Lahan (m^2)", color = "yellow", icon = icon("money"), width = 3), 
                                 valueBox(value = "Jakarta Pusat", subtitle = "Kota Termahal", color = "red", icon = icon("money"), width = 3), 
                                 valueBox(value = "Menteng", subtitle = "Kecamatan Termahal", color = "blue", icon = icon("money"), width = 3), 
                          ), 
                          column(width = 4,
                                 plotOutput(outputId = "plot_sebaran_data_lb")
                          ),
                          column(width = 4, 
                                 plotOutput(outputId = "plot_sebaran_data_ll")
                          ),
                          column(width = 4, 
                                 plotlyOutput(outputId = "plot_top_kec"), 
                                 radioButtons(inputId = "pilih_kota_ovr", inline = T, label = "Pilih Kota", choices = sort(unique(jkt_viz$kota)))
                                 )
                          )
                 )
          )
        ), 
      tabItem(
        tabName = "prediksi_harga", 
        fluidRow(
          column(
            width = 3,
            box(
              width = 12,height = 750, 
              h5(em("*Tentukan spefisikasi rumah sesuai dengan range yang ditentukan")),
              h5(em("Desclaimer:")),
              h5(em("Variabel utama yang menunjang model machine learning adalah kota, kecamatan, luas lahan dan luas bangunan")),
              selectInput(inputId = "pilih_kota", label = "Pilih Kota", choices = sort(unique(jkt_viz$kota))), 
              uiOutput(outputId = "selection2"),
              sliderInput(inputId = "luas_bangunan", label = "Luas Bangunan (max. 600m^2)", value = 0, min = 20, max = 500, step = 5), 
              sliderInput(inputId = "luas_lahan", label = "Luas Lahan (max. 600^m2)", value = 0, min = 20, max = 500, step = 5), 
              sliderInput(inputId = "jumlah_kamar", label = "Jumlah Kamar (max. 5)", value = 0, min = 2, max = 4, step = 1), 
              #radioButtons(inputId = "garasi", label = "Garasi", choices = sort(unique(jkt_viz$Garasi)), inline = T), 
              radioButtons(inputId = "taman", label = "Taman", choices = sort(unique(jkt_viz$Taman)), inline = T), 
              #radioButtons(inputId = "keamanan", label = "Kemanan 24 jam", choices = sort(unique(jkt_viz$Keamanan.24.jam)), inline = T), 
              actionButton(inputId = "submit",label = "Submit")
              )
            ),
          fluidRow(
            column(width = 8, height = 750, 
                   box(width = 12, 
                       valueBox(value = "24.5%",
                                subtitle = "MAPE", 
                                color = "blue", 
                                icon = icon("th"), 
                                width = 6), 
                       valueBox(value = 0.81,  
                                subtitle = "R-Squared", 
                                color = "yellow", 
                                icon = icon("book"), 
                                width = 6),
                       valueBox(value = valueBoxOutput(outputId = "prediksi_harga", width = 20), 
                                width = 12, 
                                subtitle = h3(strong("Hasil Prediksi"), align = "center"), 
                                color = "green"), 
                       h3(strong("Rerata Harga Berdasarkan Iklan Rumah"), align = "center"), 
                       leafletOutput(outputId = "plot_prediksi"), 
                       h5(em("*NA: Spesifikasi rumah tidak tersedia"))
                       )
                   )
            )
          )
        ), 
      tabItem(
        tabName = "data", 
        dataTableOutput(outputId = "data_set")
      ), 
      tabItem(
        tabName = "profil",
        column(width = 12, 
               h2(strong("Linkedin:")), 
               
               a(href="Linkedin", "https://www.linkedin.com/in/reza-lutfi-ismail-4b0238b1/"),
               h2(strong("Github:")), 
               a(href = "", "https://github.com/rezalutfi40"), 
               h2(strong("Twitter:")), 
               a(href = "", "https://twitter.com/rezalutfii")
        )
      )
      )
    )
  )