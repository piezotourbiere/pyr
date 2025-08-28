my_ui <- shinyUI({
    fluidPage(
        titlePanel('GWL time series visual inspection application'),
        tags$style(HTML("\n    .tabbable > .nav > li > a                  {background-color: #EAECEA;  color:black}\n    .tabbable > .nav > li > a[data-value='map'] {background-color: #BCF0A8;   color:black}\n    .tabbable > .nav > li > a[data-value='Manual vs Automatic scatterplot'] {background-color: #EEC596;   color:black}\n    .tabbable > .nav > li > a[data-value='Sharp change plot'] {background-color: #B1BCE2;  color:black}\n    .tabbable > .nav > li > a[data-value='Repair plot'] {background-color: #03fc6f;  color:black}\n    .tabbable > .nav > li > a[data-value='Station wells plot'] {background-color: #F5F34A;  color:black}\n    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}\n  ")),
        fluidRow(
          column(1, actionButton("updateUnikalos", HTML("Refresh </br>well </br>list"))),
            column(2,
                   selectizeInput("station",
                                  "Station",
                                  choices = c("")),
                   selectizeInput("urbnr", "Well: ", choices = c(""))
            ),
            column(2, strong("Plot parameters"), 
                   checkboxInput("linijas", "Lines",FALSE),
                   checkboxInput("punkti", "Points", TRUE),
                   checkboxInput("inversey", "Reverse vertical", FALSE)
            ),
            column(2,
                   radioButtons("scalesFree", label = "For all plots:",
                                choices = list("free scale" = 1, "fixed scale" = 2), 
                                selected = 1),
                   actionButton("update", "update repair plot")
            ),
          column(2,
                 htmlOutput("urbumu_info")
          )),
        fluidRow(
            tabsetPanel(
              tabPanel("map",
                       h5("Map of the wells"),
                       leafletOutput("karte", height = "650px")),
              tabPanel("Data table", 
                         h5("RAW data for the selected well"), 
                         DT::dataTableOutput("table")),
              tabPanel("Statistics", 
                         h5("number of observations per measurement_type"),
                         tableOutput("smallTable")),
              tabPanel("Sharp change plot",
                         plotOutput('plot_gradients', height = "800px",
                                    click = "g3_click",
                                    brush = brushOpts(id = "g3_brush")),
                         fluidRow(
                           column(width = 6,
                                  p("clicked points:"),
                                  verbatimTextOutput("g3_click_info")
                           ),
                           column(width = 6,
                                  p("brushed points:"),
                                  DT::dataTableOutput("g3_brush_info")
                           ))),
              tabPanel("Manual vs Automatic scatterplot", 
                         h5("Manual vs Automatic scatterplot"),
                         h5("(red line indicates 1:1, thus deviation from the line is a possible error)"),
                         strong(textOutput("novirze")),
                         plotOutput('plot3', width = '450px', height = '450px'),
                         h5("Red line = 1:1"),
                         h5("observations aggregated by days")),
              tabPanel("Repair plot", 
                       plotly::plotlyOutput("plot_edited_plotly", height = '600px'),
                       fluidRow(
                         column(width = 2,
                                sliderInput("bins", "Bins:",
                                            min = 0, max = 100,
                                            value = 20)
                         ),
                         column(width = 1,
                                prettySwitch(
                                  inputId = "poga_specific",
                                  label = "specific", 
                                  status = "success",
                                  fill = TRUE, 
                                  value = FALSE
                                ),
                                prettySwitch(
                                  inputId = "poga_nolidz",
                                  label = "no-lidz", 
                                  status = "success",
                                  fill = TRUE,
                                  value = FALSE
                                )),
                         column(width = 8,
                                plotOutput("plot_hist", height = "350px", width = '600px')
                         )),
                       tableOutput("tabulaLabojumi2")),
              tabPanel("Station wells plot",
                       plotly::plotlyOutput("plot_visiUrb_plotly", height = "850px"))
            )
        )
    )
})
