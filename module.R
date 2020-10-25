#' Variable selection
#'
#' @param id, character used to specify namespace, see \code{shiny::\link[shiny]{NS}}
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements
varselect_mod_ui <- function(id) {
  ns <- NS(id)
  wp_id = paste0(id, '_wp')

  # assemble UI elements
  tagList(tags$head(tags$style(HTML('
                                #wp1 {background-color: #969cf2}
                                #wp2 {background-color: #fa984d}
                                #wp3 {background-color: #69dbb3}
                                #wp4 {background-color: #dce058}

                                #vars_tab_1_wp {background-color:#69dbb3;}
                                #vars_tab_2a_wp {background-color:#dce058;}
                                ')))

        # ,tags$style("#data_body {background-color:#69dbb3;}")  # selectize = F for colour to work
        ,wellPanel(id = wp_id
            ,selectInput(ns('data_body'), 'Selector Main Body', c(paste(id, '123'), paste(id, '456'), paste(id, '789')), selectize = F)

            ,fluidRow(
                 column(width = 3, 'Main selector',       br(), wellPanel(id = 'wp1', textOutput(ns('plot_ui_text_1'))))
                ,column(width = 3, 'Side panel selector', br(), wellPanel(id = 'wp2', textOutput(ns('plot_ui_text_2'))))
                ,column(width = 3, 'Tab 1 selector',      br(), wellPanel(id = 'wp3', textOutput(ns('plot_ui_text_3'))))
                ,column(width = 3, 'Tab 2a selector',     br(), wellPanel(id = 'wp4', textOutput(ns('plot_ui_text_4'))))
             )
        )
  )
}

#' Variable selection module server-side processing
#'
#' @param input,output,session standard \code{shiny} boilerplate
#'
#' @return list with following components
#' \describe{
#'   \item{mvar}{reactive character indicating variable selection}
#' }
varselect_mod_server <- function(input, output, session, other_vals) {

    plot_ui_text_obj <- reactive({
        return(other_vals())
    })

    output$plot_ui_text_1 <- renderText({
        plot_ui_text_obj()[[1]]()
    })

    output$plot_ui_text_2 <- renderText({
        plot_ui_text_obj()[[2]]()
    })

    output$plot_ui_text_3 <- renderText({
        plot_ui_text_obj()[[3]]()
    })

    output$plot_ui_text_4 <- renderText({
        plot_ui_text_obj()[[4]]()
    })

    return(list(mvar = reactive({ input$data_body })))
}

