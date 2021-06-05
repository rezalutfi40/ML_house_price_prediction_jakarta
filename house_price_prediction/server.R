options(shiny.maxRequestSize = 30*1024^2, expressions = 500000)

function(input, output, session){

    prediksi <- eventReactive(input$submit,{
        if(is.null(input$pilih_kota)){
            return()
        }
        validation_2 <- data.frame(
            kecamatan = input$pilih_kecamatan,
            kota = input$pilih_kota,
            Taman = input$taman,
            Garasi = "yes",
            Keamanan.24.jam = "yes",
            kamar = input$jumlah_kamar,
            luas_bangunan = input$luas_bangunan,
            luas_lahan = input$luas_lahan
            
        )
        
        val3 <- rbind(validation, validation_2)
        
        pred <- predict(model_rf, tail(val3, 1), type = "response")
        paste("Rp.", prettyNum(pred, big.mark = ",")) 
        
    })
    
    output$selection2 <- renderUI({
        
        selectInput(inputId = "pilih_kecamatan", 
                    label = "Pilih Kecamatan", 
                    choices = sort(unique(jkt_viz[jkt_viz$kota == input$pilih_kota, ]$kecamatan)
                    )
        )
    })
    
    output$plot_var_importance <- renderPlot({
        
        plot_var_importance <- var_importance %>% 
            mutate(Gini = round(Nilai/max(Nilai),2)) %>% 
            ggplot(aes(Gini, reorder(Variabel, Gini), fill = Gini))+
            geom_col()+
            scale_fill_gradient(low = "bisque", high = "darkred") +
            labs(x = NULL, 
                 y = NULL, title = "Variabel Importance")+
            # scale_x_continuous(labels = NULL) +
            theme_minimal()+
            theme(legend.position = "none",
                  plot.title = element_text(hjust = 0.5))
        
        plot_var_importance
        
    })
    
    output$plot_sebaran_data_lb <- renderPlot({
        
        plot_sebaran_data_lb <- jkt_int_no_out %>%
            ggplot(aes(price, luas_bangunan, col = luas_bangunan))+
            geom_jitter()+
            geom_smooth()+
            labs(x = "Harga Rumah",
                 y = "Luas Bangunan (m^2)",
                 title = "Luas Bangunan vs Harga",
                 color = "Luas Bangunan")+
            scale_color_gradient(high = "blue", low = "black")+
            scale_x_continuous(labels = dollar_format(accuracy = 1, scale = 1e-9, suffix = "M", prefix = "Rp "))+
            theme_minimal()+
            theme(legend.position = "none")+
            theme(plot.title = element_text(hjust = 0.5))
        
        plot_sebaran_data_lb
        
    })
    
    output$plot_sebaran_data_ll <- renderPlot({
        
        plot_sebaran_data_ll <- jkt_int_no_out %>%
            ggplot(aes(price, luas_lahan, col = luas_lahan))+
            geom_jitter()+
            geom_smooth()+
            labs(x = "Harga Rumah",
                 y = "Luas Lahan (m^2)",
                 title = "Luas Lahan vs Harga",
                 color = "Luas Lahan")+
            scale_color_gradient(high = "red", low = "black")+
            scale_x_continuous(labels = dollar_format(accuracy = 1, scale = 1e-9, suffix = "M", prefix = "Rp "))+
            theme_minimal()+
            theme(legend.position = "none")+
            theme(plot.title = element_text(hjust = 0.5))
        
        plot_sebaran_data_ll
        
    })
    
    output$plot_top_kec <- renderPlotly({
        
        kec_agg <- jkt_viz %>% 
            filter(kota == input$pilih_kota_ovr) %>% 
            group_by(kota, kecamatan) %>% 
            summarise(rerata_harga = median(price)) %>% 
            arrange(-rerata_harga) %>% 
            head(6)
        
        plot_top_kec <- kec_agg %>%  
            ggplot(aes(reorder(kecamatan, rerata_harga), rerata_harga,
                       text = glue("Kecamatan: {kecamatan}
                               Rerata Harga: {rerata_harga}")))+
            geom_col(aes(fill = rerata_harga))+
            coord_flip()+
            labs(title = glue("Kota {input$pilih_kota_ovr}"), 
                 x = NULL, 
                 y = NULL)+
            scale_y_continuous(labels = dollar_format(accuracy = 1, scale = 1e-9, suffix = "M", prefix = "Rp."))+
            scale_fill_gradient(low = "grey", high = "black") +
            theme_minimal()+
            theme(legend.position = "none",
                  axis.text.x = element_text(angle = 45))+
            theme(plot.title = element_text(hjust = 0.5))
        
        ggplotly(plot_top_kec, tooltip = "text")
    })
    
    output$data_set <- renderDataTable({
        
        data_jkt <- jkt_viz %>% 
            filter(kota == input$pilih_kota_ovr) %>% 
            arrange(-price) %>% 
            select(-nama)
        
        colnames(data_jkt) <- str_to_title(colnames(data_jkt)) 
        datatable(data_jkt, options = list(scrollX = T))
        
    })
    
    output$plot_prediksi <- renderLeaflet({
        
        agg_prediksi <- jkt_viz %>% 
            filter(kota == input$pilih_kota & kecamatan == input$pilih_kecamatan) %>% 
            group_by(kota, kecamatan) %>% 
            summarise(rerata_harga = median(price), 
                      harga_min = min(price), 
                      harga_max = max(price)) %>% 
            arrange(-rerata_harga) 
        
        rerata_label <- jkt_int_no_out %>% 
            filter(kecamatan == input$pilih_kecamatan, luas_lahan == input$luas_lahan) %>% 
            summarise(rerata_harga = median(price))
        
        lokasi_agg_prediksi <- jakarta_rds %>% 
            left_join(agg_prediksi, by = c("NAME_3" = "kecamatan")) %>% 
            st_as_sf()
        
        labels<- paste("Kecamatan: ", agg_prediksi$kecamatan, 
                       ", Rerata Harga: Rp", prettyNum(rerata_label$rerata_harga, big.mark = ",")) 
        
        pal <- colorNumeric(palette = "Reds", 
                            domain = log(lokasi_agg_prediksi$rerata_harga, base = 10))
        
        plot_prediksi <- leaflet(lokasi_agg_prediksi) %>% 
            addProviderTiles(providers$CartoDB.DarkMatter) %>% 
            addPolygons(
                fillColor = ~pal(log(rerata_harga, base = 10)),
                label = labels, 
                fillOpacity = .8,
                weight = 2,
                color = "white",
                highlight = highlightOptions(
                    weight = 10,
                    color = "black", 
                    bringToFront = TRUE,
                    opacity = 0.8)
            ) 
    })
    
    output$prediksi_harga <- renderText({
        
        validation_2 <- data.frame(
            kecamatan = input$pilih_kecamatan,
            kota = input$pilih_kota,
            Taman = input$taman,
            #Garasi = input$garasi,
            #Keamanan.24.jam = input$keamanan,
            kamar = input$jumlah_kamar,
            luas_bangunan = input$luas_bangunan,
            luas_lahan = input$luas_lahan
        )
        
        val3 <- rbind(validation, validation_2)
        
        predict(model_rf, tail(val3, 1), type = "response")
        
    })
    
    output$prediksi_harga <- renderText({
        
        prediksi()
        
    })
    
    output$data_set <-  renderDataTable({
        
        datatable(jkt_int_no_out, options = list(scrollx = T))
    })
    
}