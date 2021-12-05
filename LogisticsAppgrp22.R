# Load required libraries
#install.packages("DT")
library(shiny)
library(shinyjs)
library(shinydashboard)
library(leaflet)
library(DBI)
library(odbc)
library(DT)
library(shinyWidgets)
library(rsconnect)
library(ggplot2)
library(wordcloud)


# Read database credentials
# source("./03_shiny_HW1/credentials_v3.R")
source("./credentials_v4.R")


ui <- fluidPage(
  
  dashboardPage( skin = "red",
  dashboardHeader(title = "Logistics Dashboard"),
  #Sidebar content
  dashboardSidebar(
    
   
  #Add sidebar menus here
    sidebarMenu(
      menuItem("Welcome", tabName = "HWSummary", icon = icon("home")),
      menuItem("Update Order", tabName = "oder", icon = icon("shopping-cart")),
      menuItem("Customer ID", tabName = "customer", icon = icon("user")),
      menuItem("Driver Information", tabName = "driver", icon = icon("user")),
      menuItem("Add/Remove Vehicle", tabName = "vehicle", icon = icon("car")),
      menuItem("Product Information", tabName = "product", icon = icon("bell")),
      menuItem("Activity Tracker", tabName = "activity", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    #.sidebar-menu {
    #  font-family: "Roboto";
    #  font-weight: bold;
    #  font-size: 15px
    #  background-color:yellow;    
    
    tags$head(tags$style(HTML('
    
          .skin-blue .main-header .logo {
           background-color: #5A7561;
           font-family: "Roboto";
            font-weight: bold;
            font-size: 25px;}
                              
                              
         .skin-blue .main-sidebar {
           font-family: "Roboto";
            font-weight: bold;
            font-size: 16px;
            font-color:white;
            background-color: #6D9A7A ;}
            
             .skin-blue .main-header .navbar {
                              background-color: #5A7561;}
                              
              .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                              background-color: #5A7561;
                               font-size: 18px;
                              }                
             .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                              background-color: #5A7561;
                              }
                              
                              
                              '))),
    
#################################################################################################################################################################################################################################################################################################################################################################################################              
    
    tabItems(
      # Add contents for first tab
      tabItem(tabName = "HWSummary",
              
              fluidPage(
                tags$head(tags$style(HTML('    .skin-blue .main-header .logo {
           background-color: #5A7561;
           font-family: "Roboto";
            font-weight: bold;
            font-size: 25px;}'))),
              fluidRow(
                column(2.5,
                       valueBoxOutput("OrderCount")),
                column(2.5,
                       valueBoxOutput("RevenueTotal")),
                column(2.5,
                       valueBoxOutput("OrdersTransit"))
              ),
                
              
              box(width=NULL, title="Search LoadID",solidHeader=TRUE,status="danger",
              h1("Welcome to your Logistics Dashboard!"),
              h4("Enter Load ID to See Status:"),
              textInput("text", "LOAD ID:", placeholder = "i.e AB123"),
              actionButton("Go1", label = "Check Load Status"),
              DT::dataTableOutput("welcome"),
              
             
              )
      )),
      # Add contents for second tab
#################################################################################################################################################################################################################################################################################################################################################################################################              
      
      tabItem(tabName = "oder",
              
              
              
              setBackgroundImage(src = "https://thumbor.forbes.com/thumbor/960x0/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1156528620%2F960x0.jpg%3Ffit%3Dscale", shinydashboard = TRUE),
              
              box(width=NULL,solidHeader=TRUE,status="danger",title="Update LoadID Status",
                  #textInput("RName", label = h2("Pattern of Name"), value = "Enter Name"),
                  #sliderInput("VoteRange", label = h3("Range of votes to search for"), min = 0, max = 100, value = c(0, 60)),

                  h1("Update Order Status Below"),              
                  textInput("UpdateLoadID", label = h3("Please Enter LoadID"), placeholder  = "i.e AC124"),
                  selectInput("NewStatus", label = h3("Please Enter New Load Status"), 
                              choices = list("Delivered" = "Delivered", "In-Transit" = "In-Transit", "Returned" = "Returned", "Delayed" ="Delayed", "Cancelled"="Cancelled"), 
                              selected = 1),
                  #dateInput("NewDate",label=h3("Enter new expected date"))
                  actionButton("Go", label = "Update:"),
                  
                  h2("Updated Order Status Below"),
                  
                  
                  DT::dataTableOutput("mytable"),
                 
 leafletOutput("mymap"),
 
 )
                  
              
              
 
 ################################################################################################################################
             
      ),
      
      
      #  Add contents for customer data
    
    tabItem(tabName = "customer",
          
        
      
          box(width=NULL,solidHeader=TRUE,collapsible=TRUE,status="danger",title="CustomerID Search",
          h1("Search 5 Most Recent Customer Purchases"),
          hr("Please Enter Customer ID"),
          
          textInput("text1", "Customer ID:", placeholder = "i.e RDRC01"),
          actionButton("do", label = "Recent Purchases"),
          DT::dataTableOutput("mytable1"))
    
              ),
    
 #################################################################################################################################################################################################################################################################################################################################################################################################              
 
  # Add Contents for Driver Tab
    
    
    tabItem(tabName = "driver",
            
            
            box(width=NULL,solidHeader=TRUE,status="danger",title="Driver Word Cloud",
               
                sidebarLayout(
                sidebarPanel(
                  
                dateRangeInput("dates", label = h3("Enter Date Range to Analyze:"),start = "2021-01-01", end = "2021-12-31"),
                actionButton("do2", label = "Analyze:")
                
                ),
                
                mainPanel(
                  h1("Word Cloud:"),
                  plotOutput("wordcloud"),
                  DT::dataTableOutput("mytable2")
                  )
                ))
             ),
    
 #################################################################################################################################################################################################################################################################################################################################################################################################              
 
     # Add Contents for Vehicle tab
    
    tabItem(tabName = "vehicle",
            
            box(width=NULL,solidHeader=TRUE,status="danger",title="Add or Delete Vehicle",
                
                #textinput for Vehicle Id.We aks user to enter Vehcile ID
                navbarPage("Add/Delete",
                
                tabPanel("Add Vehicle",
                
                textInput("VehicleID", label = h4("Please Enter New Vehicle ID"), placeholder  = "i.e 1A"),
                textInput("VehicleDesc", label = h4("Please Enter New Vehicle Description"), placeholder  = "i.e 26ft Truck"),
                textInput("VehicleWeight", label = h4("Please Enter New Vehicle Weight"), placeholder  = "i.e 26000"),
                textInput("vehicleCap", label = h4("Please Enter New Vehicle Capacity(#Orders/truck)"), placeholder  = "i.e 15"),
                textInput("VehicleFC", label = h4("Please Enter New Vehicle Fixed Cost(monthly)"), placeholder  = "i.e 3000"),
                textInput("VehicleMPG", label = h4("Please Enter New Vehicle Miles/Gal"), placeholder  = "i.e 10"),
                textInput("VehicleCPM", label = h4("Please Enter New Vehicle Cost/Mile"), placeholder  = "i.e 0.23"),
                actionButton("do3a", label = "Update Vehicle:"),
                hidden(
                  div(id='UpdateVehiceText',
                      verbatimTextOutput("text")
                  )),
                h4("Vehicle Table:"),
                DT::dataTableOutput("mytable3")
            
                ),
                tabPanel("Delete Vehicle",
                
                textInput("DelV", label = h3("Enter Vehicle ID to remove"), placeholder  = "i.e 1A"),
                actionButton("do3b", label = "Delete Vehicle:"),
                hidden(
                  div(id='DelVehicleText',
                      verbatimTextOutput("text1")
                  )),
                h4("Vehicle Table:"),
                DT::dataTableOutput("mytable3a")
                
                )
                
              )
                #actionButton("do3", label = "click3"),
                
                #h2("Search3"),
                #DT::dataTableOutput("mytable3"))
            
             )),
    
    #Add Contents for update Product Itemt Tab
    
  
 
 
 #################################################################################################################################################################################################################################################################################################################################################################################################              
 
 
 
   tabItem(tabName = "product",
           
            box(width=NULL,solidHeader=TRUE,status="danger",title="Search Product Table",
                
                titlePanel("Product Data Table"),
                fluidRow(
                column(5,
                       selectInput("Category",label=h4("Category:"),
                                   choices=list("All"="All","Building"="Building","Office"="Office","Kitchen"="Kitchen","Furniture"="Furniture","Industrial"="Industrial"),
                                   selected=1)),
                column(5,
                       selectInput("Color",label=h4("Color:"),
                                   choices=list("All"="All","black"="Black","Red"="Red","Blue"="Blue","Orange"="Orange","White"="White"),
                                   selected=1))
                #column(4,
                 #      selectInput("Color",label=h4("Color:"),
                  #                 choices=list("black"="Black","Red"="Red","Blue"="Blue","Orange"="Orange","White"="White"),
                   #                selected=1))
    
                ),
                       
                  
                #actionButton("do4", label = "click4"),
                
                h2("Product Table:"),
                DT::dataTableOutput("mytable4"))
            
            ),
    
  
 
 ################################################################################################################################
 
 
    tabItem(tabName = "activity",
            
            box(width=NULL,solidHeader=TRUE,status="danger",title="Customer Analytics",
   
           h1("Customer Metrics:"),
                
                h3("Please Enter Date Range to Analyze:"),
                dateRangeInput('dateRange2',
                 label = 'Date range input: yyyy-mm-dd',
                 start = "2021-01-01", end = "2021-12-31"),
                 
  
  
                actionButton("do5", label = "Analyze Customers"),
                fluidRow(
                 splitLayout(cellWidths = c("50%", "50%"), plotOutput("PlotCust"), plotOutput("PlotCust2"))),
                
                #plotOutput("PlotCust"),
                DT::dataTableOutput("mytable5"),
                              
                  
  
  
  
  
  
  
  
  )      
           
            )
      
    )
  )
)
)


################ ################## #########   SERVER CODE BELOW   #########   ######### ######### ######### ######### ######### 





server <- function(input, output) {
  
  #Develop your server side code (Model) here
  
  # Where to edit for order Item Tab
#########################################################################################################################################      
  
  db <- dbConnector(
    server   = getOption("database_server"),
    database = getOption("database_name"),
    uid      = getOption("database_userid"),
    pwd      = getOption("database_password"),
    port     = getOption("database_port")
  )
  on.exit(dbDisconnect(db), add = TRUE)
  
  
  queryOC <- paste0("select Count(LoadID) from Orders")
  print(queryOC)
  dataOC <- dbGetQuery(db, queryOC)
  
  queryRT <- paste0("select  sum((PD.price)*(1-PD.Discounts)*(OL.Quantity)) as TotalSpent
                      from Orders as O 
                      join OrderLineItems as OL
                      on OL.LoadID = O.LoadID
                      join ProductDescription as PD
                      on PD.ProductsID=OL.ProductsID
                      Join Customer as C 
                      on C.CustomerID = O.CustomerID
                     ")
  print(queryRT)
  dataRT <- dbGetQuery(db, queryRT)
  
  queryOT <- paste0("select count(loadID) from Orders
        where OrderStatus like '%In-Transit%';
                     ")
  print(queryOT)
  dataOT <- dbGetQuery(db, queryOT)
  
  
  output$OrderCount <- renderValueBox({
    valueBox(
      dataOC, "# Orders to date", icon = icon("list"),
      color = "red"
    )})
  
  output$RevenueTotal <- renderValueBox({
    valueBox(
      paste0("$",dataRT),"Revenue to date", icon = icon("money"),
      color = "red"
    )})
  
  output$OrdersTransit <- renderValueBox({
    valueBox(
      dataOT,"Orders in Transit", icon = icon("truck"),
      color = "red"
    )})
  
#########################################################################################################################################      
  
  
  observeEvent(input$Go1, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)

    query <- paste0("
                    
                    
              select O.LoadID,O.CustomerID,CONCAT( C.FirstName,' ',C.LastName) as FullName, O.OrderStatus,O.ExpectedDeliveryDate,O.ActualDeliveryDate,O.RouteID,O.VehicleID,O.CustomerID
              from Orders as O
              join Customer as C
              on O.CustomerID=C.CustomerID
              where loadID like '%",input$text,"%';
                    
                    
                    ")
    
    
    
    
    print(query)
    
    data <- dbGetQuery(db, query)
    
    output$welcome = DT::renderDataTable({
      data
 
    })
    
  })
  
  ##############################################################################################################################     
  
  
  
  
  
  observeEvent(input$Go, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    # browser()
    
   query <- paste0("UPDATE Orders SET OrderStatus ='" ,input$NewStatus, "' WHERE LoadID like '%" ,input$UpdateLoadID,  "%';")
    data <- dbGetQuery(db, query)
    
    query2<-paste0("Select O.loadID,O.CustomerID,O.OrderStatus,O.ExpectedDeliveryDate,O.RouteID,O.VehicleID
                   from Orders as O where LoadID like '%",input$UpdateLoadID,"%';")
    
    data <- dbGetQuery(db, query2)
    print(query2)
    output$mytable = DT::renderDataTable({
      data
     
    })
    
    output$mymap<-renderLeaflet({
      
      db <- dbConnector(
        server   = getOption("database_server"),
        database = getOption("database_name"),
        uid      = getOption("database_userid"),
        pwd      = getOption("database_password"),
        port     = getOption("database_port")
      )
      on.exit(dbDisconnect(db), add = TRUE)
      
      query1<-paste0("select * from Orders as O 
                    join Customer as C
                    on O.CustomerID = C.CustomerID
                    where O.LoadID like '%",input$UpdateLoadID,"%';")
      data1<-dbGetQuery(db, query1)
      
      leaflet(data=data1)%>%
        addProviderTiles(providers$CartoDB)%>%
        addMarkers(lng=data1$longitude,lat=data1$Latitude,popup = paste("Order Status:",data1$OrderStatus))
    })
    
   
  })
  
#########################################################################################################################################      

  #Where to Edit for customer Item Tab.
  
  observeEvent(input$do, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    
    # browser()
 
    query <- paste0("select TOP 5 C.CustomerID, C.FirstName, C.LastName, C. customerNetTerms, O.LoadId, O.OrderplacementDate, O.OrderStatus 
                    from Customer as C
                    join Orders as O
                    on C.CustomerID = O.CustomerID
                    where c.CustomerID like '%", input$text1, "%'
                    order by O.OrderplacementDate DESC
                    ;")
    
    
    
    
    print(query)
    
    data <- dbGetQuery(db, query)
    
    output$mytable1 = DT::renderDataTable({
      data
      
##############################################################################################################################
    })
    
  })
  
  
 #Where to Edit for Driver Item Tab 
  
  observeEvent(input$do2, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    # browser()
    
   
    query <- paste0("
                    Select D.DriverId,CONCAT( D.DriverFirstName,' ',D.DriverLastName) as FullName ,count(O.LoadID) as NumLoadID
                    from Driver as D
                    join Orders as O 
                    on D.DriverId = O.DriverID
                    where O.ActualDeliveryDate between '",input$dates[1],"' and '",input$dates[2],"'
                    
                    Group by D.DriverId, D.DriverLastName,D.DriverFirstName

                    
                    
                    ")
    
    
    print(query)
    
    data <- dbGetQuery(db, query)
    
    output$mytable2 = DT::renderDataTable({
      data})
   
    
    output$wordcloud<-renderPlot({
     wordcloud(words=data$FullName,freq=data$NumLoadID,min.freq=1,max.words=250,
               colors=brewer.pal(8,"Dark2"))
      
    })
    
  })
  
  
###############################################################################################################################
  
 #Where to edit for Vehicle Item Tab 
  
  observeEvent(input$do3a, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    # browser()

    query <- paste0("
                    
INSERT INTO [dbo].[Vehicle]
           ([VehicleID]
           ,[VehicleDesc]
           ,[VehicleWeight]
           ,[VehicleCapacity]
           ,[VehicleFixedCost]
           ,[VehicleMPG]
           ,[VehicleCPM])
     VALUES
           ('",input$VehicleID,"',
          '",input$VehicleDesc,"  ',
           ",input$VehicleWeight  ,",
           ", input$vehicleCap, ",
           ", input$VehicleFC, ",
           ", input$VehicleMPG , ",
           ", input$VehicleCPM,   ");
                    

                    ")
    
    query1<-paste0("select * from Vehicle;")
    print(query)
    print(query1)
    
    data1<-dbGetQuery(db, query)
    data <- dbGetQuery(db, query1)
    toggle('UpdateVehiceText')
    output$mytable3 = DT::renderDataTable({
      data})
    output$text<-renderText({"Succesfully Added Vehicle!"})
    
  })
  ########################################################################################################################################
  
  
  observeEvent(input$do3b, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    # browser()
    
    query <- paste0("
                    
                    delete Vehicle
                    where VehicleID = '",input$DelV,"'
                    ")
 
    query1<-paste0("select * from Vehicle")
    
    
    data <- dbGetQuery(db, query)
    data1<-dbGetQuery(db, query1)
    print(query)
    print(query1)
    
    toggle('DelVehicleText')
    output$mytable3a = DT::renderDataTable({
      data1})
    output$text1<-renderText({"Vehicle Deleted!"})
    
  })
  
  # Where to edit for Update Product 
  
  ########################################################################################################################################
  

    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
  
    query <- paste0("select * from ProductDescription 
                    ")
    print(query)
    
    data <- dbGetQuery(db, query)
    
    output$mytable4 = DT::renderDataTable(DT::datatable({
      
    
      if (input$Category != "All") {
        data <- data[data$Category == input$Category,]
      }
      if (input$Color != "All") {
        data <- data[data$Color == input$Color,]
      }
   
      data
      
   }))
    
    
    
  
  
  #Where to edit for the activity tracker( not sure what would look like yet, but I am making the database connection anyway)
################################################################################################################################## 
  observeEvent(input$do5, {
    # open DB connection
    db <- dbConnector(
      server   = getOption("database_server"),
      database = getOption("database_name"),
      uid      = getOption("database_userid"),
      pwd      = getOption("database_password"),
      port     = getOption("database_port")
    )
    on.exit(dbDisconnect(db), add = TRUE)
    
    # browser()
    

    query <- paste0("
      
  select O.CustomerID,CONCAT( C.FirstName,' ',C.LastName) as FullName,C.CustomerEntity,O.ActualDeliveryDate as DeliveryDate, sum((PD.price)*(1-PD.discounts)) as TotalSpent, Count(O.LoadID)as OrderCount, C.FirstName,C.LastName
        from Orders as O 
        join OrderLineItems as OL
        on OL.LoadID = O.LoadID
        join ProductDescription as PD
        on PD.ProductsID=OL.ProductsID
        Join Customer as C 
        on C.CustomerID = O.CustomerID
        where O.ActualDeliveryDate between '",input$dateRange2[1],"' and '",input$dateRange2[2],"' group by O.CustomerID, ActualDeliveryDate,C.FirstName,C.LastName,C.CustomerEntity
        Order by TotalSpent DESC;
                     
                   
                   ")
    
    
    #print(query)
    
    data <- dbGetQuery(db, query)
    print(query)
    
    #ggplot(data=data, aes(x=data$ActualDeliveryDate, y=Data$TotalSpent, group=Data$CustomerID)) +
     # geom_line()+
      #geom_point()
    
    
    output$mytable5=DT::renderDataTable({
      data
    }, 
    options = list(scrollX = TRUE))
    
    output$PlotCust = renderPlot({
      
      db <- dbConnector(
        server   = getOption("database_server"),
        database = getOption("database_name"),
        uid      = getOption("database_userid"),
        pwd      = getOption("database_password"),
        port     = getOption("database_port")
      )
      on.exit(dbDisconnect(db), add = TRUE)
      
      # browser()
     
      query <- paste0("

            select O.CustomerID,O.ActualDeliveryDate as DeliveryDate, sum((PD.price)*(1-PD.discounts)*OL.Quantity) as TotalSpent, Count(O.LoadID)as OrderCount, C.FirstName,C.LastName, CONCAT( C.FirstName,' ',C.LastName) as FullName
        from Orders as O 
        join OrderLineItems as OL
        on OL.LoadID = O.LoadID
        join ProductDescription as PD
        on PD.ProductsID=OL.ProductsID
        Join Customer as C 
        on C.CustomerID = O.CustomerID
        where O.ActualDeliveryDate between '",input$dateRange2[1],"' and '",input$dateRange2[2],"' group by O.CustomerID, ActualDeliveryDate,C.FirstName,C.LastName
        Order by TotalSpent DESC;
                     
                     
                     ")
          
      data <- dbGetQuery(db, query)
      ggplot(data=data, aes(x = reorder(data$FullName,-data$TotalSpent), y = data$TotalSpent)) +  
        labs(x = "Customer", y = "Total Spent", title = "Customer Spending") +
        geom_col(fill = "steelblue")
    })  
      output$PlotCust2 = renderPlot({
        
        db <- dbConnector(
          server   = getOption("database_server"),
          database = getOption("database_name"),
          uid      = getOption("database_userid"),
          pwd      = getOption("database_password"),
          port     = getOption("database_port")
        )
        on.exit(dbDisconnect(db), add = TRUE)
        
        # browser()
        
        query <- paste0("

            select C.CustomerEntity as Industry, O.ActualDeliveryDate as DeliveryDate, sum((PD.price)*(1-PD.Discounts)*OL.Quantity) as TotalSpent
            from Orders as O 
            join OrderLineItems as OL
            on OL.LoadID = O.LoadID
            join ProductDescription as PD
            on PD.ProductsID=OL.ProductsID
            Join Customer as C 
            on C.CustomerID = O.CustomerID
            where O.ActualDeliveryDate between '",input$dateRange2[1],"' and '",input$dateRange2[2],"' group by C.CustomerEntity, ActualDeliveryDate
            Order by TotalSpent Desc
                     
                     
                     ")
        
        data1 <- dbGetQuery(db, query)
        
        #library(treemap)
        #treemap(data1,
         #       index=c("Industry"),
          #      vSize=c("TotalSpent"),
           #     type="index",
            #    palette = "Blues",  
             #   title="Industry Spending",
              #  fontsize.title,
               # title.legend="Total Spending by Industry")
        
        #ggplot(data=data1, aes(x = reorder(data1$Industry,-data1$TotalSpent), y = data1$TotalSpent)) +  
          #labs(x = "Customer", y = "Total Spent", title = "Industries") +
          #geom_col(fill = "deepskyblue")
            ggplot(data=data1, aes(x = data$DeliveryDate, y = data1$TotalSpent, group=data1$Industry)) +
            geom_line(aes(color=Industry),)+
            geom_point()+
              labs(x = "Industries", y = "Total Spent", title = "Industry Spending Trend")
      
        
      
      
      
################################################################################################################################
################################################################################################################################
            
    })
    
  })
  
  



}

shinyApp(ui, server)

