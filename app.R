# load packages
library(shiny)
library(shinydashboard)

# load module scripts
source('module.R')

ui <- dashboardPage(
         skin = 'purple',
         dashboardHeader(title = 'Modular app demo'
                        ,tags$li(class = "dropdown"
                                ,tags$a(icon("github")
                                    ,href = "https://github.com/M3IT/shiny_modular_code_demo"
                                    ,title = "See the code on github"
                                    )
                        ))
        ,dashboardSidebar(sidebarMenuOutput('menu') #),  #sidebarMenu(id = 'sbmnu')  #,
                         ,hr()
                         ,tags$style("#si_sidebar {background-color:#fa984d;}")    # selectize = F for colour to work
                         ,selectInput('si_sidebar', 'Selector Sidebar', c('sb_abc', 'sb_def', 'sb_ghi'), selectize = F)
                         ,hr()
                         ,textOutput('sidebar_text_1'), br()
                         ,textOutput('sidebar_text_2'), br()
                         ,textOutput('sidebar_text_3'), br()
                         ,textOutput('sidebar_text_4'), br()
                         )
        ,dashboardBody(
                  tags$head(tags$style(HTML('
                                /* body */
                                .content-wrapper, .right-side {
                                    /* background-color: #7da2d1; */
                                    padding-top: 0px;
                                    padding-left: 10px;
                                    padding-right: 10px;
                                    padding-bottom: 0px;
                                }

                                #wp_1 {background-color: #969cf2}
                                #wp_2 {background-color: #fa984d}
                                #wp_3 {background-color: #69dbb3}
                                #wp_4 {background-color: #dce058}

                                #sidebar_text_1 {color: #000000; background-color: #969cf2}
                                #sidebar_text_2 {color: #000001; background-color: #fa984d}
                                #sidebar_text_3 {color: #000000; background-color: #69dbb3}
                                #sidebar_text_4 {color: #000000; background-color: #dce058}

                                ')))
                  ,h3('Main body content')
                  ,tags$style("#si_main_body {background-color:#969cf2;}")
                  ,selectInput('si_main_body', 'Selector Main Body', c('main_ui_ABC', 'main_ui_DEF', 'main_ui_GHI'), selectize = F)
                  ,fluidRow(
                         column(width = 3, 'Main selector',       br(), wellPanel(id = 'wp_1', textOutput('main_ui_text_1')))
                        ,column(width = 3, 'Side panel selector', br(), wellPanel(id = 'wp_2', textOutput('main_ui_text_2')))
                        ,column(width = 3, 'Tab 1 selector',      br(), wellPanel(id = 'wp_3', textOutput('main_ui_text_3')))
                        ,column(width = 3, 'Tab 2a selector',     br(), wellPanel(id = 'wp_4', textOutput('main_ui_text_4')))
                  )
                  ,tags$hr(style = "border-color: purple;")
                  ,fluidRow(
                         tabItems(
                             tabItem(tabName = 'dashboard1'
                                     ,h4('Dashboard tab 1 content')
                                     ,fluidRow(
                                           column(width = 12, wellPanel(varselect_mod_ui('vars_tab_1')))
                                      )
                             )
                            ,tabItem(tabName = 'dashboard2', h4('Dashboard tab 2 content'))
                                ,tabItem(tabName = 'dashboard2A'
                                        ,h4('Dashboard tab 2a content')
                                        ,column(width = 8, wellPanel(varselect_mod_ui('vars_tab_2a')))
                                 )
                            )
                    )
        )
)

# server logic
server <- function(input, output, session) {

    session$onSessionEnded(stopApp)          # End session if browser tab closed

    output$menu <- renderMenu({
        sidebarMenu(
                   id = 'sbmnu'
                  ,menuItem(text = 'Tab 1',     tabName = 'dashboard1')
                  ,menuItem(text = 'Tab 2',     tabName = 'dashboard2'
                        ,menuSubItem(text = 'Sub Tab 2A', tabName = 'dashboard2A')
                            )
                  )
        })

    # execute variable selection modules
    varsTab1  <- callModule(varselect_mod_server, 'vars_tab_1',  other_vals = other_mod_vals)
    varsTab2a <- callModule(varselect_mod_server, 'vars_tab_2a', other_vals = other_mod_vals)

    other_mod_vals <- reactive({
         list(omv_main, omv_sidebar, omv_tab_1, omv_tab_2b)
    })

    # Other_mod_vals
    omv_main <- reactive({
        return(input$si_main_body)
    })

    omv_sidebar <- reactive({
        return(input$si_sidebar)
    })

    omv_tab_1 <- reactive({
        return(varsTab1$mvar())
    })

    omv_tab_2b <- reactive({
        return(varsTab2a$mvar())
    })

    # Outputs
    output$main_ui_text_1 <- renderText({
        omv_main()
    })

    output$main_ui_text_2 <- renderText({
        omv_sidebar()
    })

    output$main_ui_text_3 <- renderText({
        omv_tab_1()
    })

    output$main_ui_text_4 <- renderText({
        omv_tab_2b()
    })

    output$sidebar_text_1 <- renderText({
        omv_main()
    })

    output$sidebar_text_2 <- renderText({
        omv_sidebar()
    })

    output$sidebar_text_3 <- renderText({
        omv_tab_1()
    })

    output$sidebar_text_4 <- renderText({
        omv_tab_2b()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
