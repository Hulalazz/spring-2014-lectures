require(ggplot2)
require(shiny)
require(scales)

# create RELATIVE path to data
# uses proper slashes for operating system
datapath <- file.path(".", "data", "lung.csv")
lungmelt <- read.csv(datapath)

grey <- "#dddddd"

plotOverview <- function(start = 1974, num = 12) {
    xmin <- start
    xmax <- start + (num / 12)

    ymin <- 1200
    ymax <- 4000
    
    lungdata <- subset(lungmelt, variable == "deaths")
    
    p <- ggplot(lungdata, aes(x = series, y = value))

    p <- p + geom_rect(
        xmin = xmin, xmax = xmax,
        ymin = ymin, ymax = ymax,
        fill = grey)

    p <- p + geom_line()
    
    p <- p + scale_x_continuous(
        limits = range(lungdata$series),
        expand = c(0, 0),
        breaks = seq(1974, 1980, by = 1))
    
    p <- p + scale_y_continuous(
        limits = c(ymin, ymax),
        expand = c(0, 0),
        breaks = seq(ymin, ymax, length.out = 3))
    
    p <- p + theme(panel.border = element_rect(
        fill = NA, colour = grey))
    
    p <- p + theme(axis.title = element_blank())
    p <- p + theme(panel.grid = element_blank())
    p <- p + theme(panel.background = element_blank())

    return(p)
}

plotArea <- function(start = 1974, num = 12) {
    xmin <- start
    xmax <- start + (num / 12)
    
    ymin <- 0
    ymax <- 4000
    
    p <- ggplot(
        subset(lungmelt, variable != "deaths"),
        aes(x = series, y = value, 
            group = variable,
            fill = variable))
    
    p <- p + geom_area()
    
    minor_breaks <- seq(
        floor(xmin), 
        ceiling(xmax), 
        by = 1/ 12)
    
    p <- p + scale_x_continuous(
        limits = c(xmin, xmax),
        expand = c(0, 0),
        oob = rescale_none,
        breaks = seq(floor(xmin), ceiling(xmax), by = 1),
        minor_breaks = minor_breaks)
    
    p <- p + scale_y_continuous(
        limits = c(ymin, ymax),
        expand = c(0, 0),
        breaks = seq(ymin, ymax, length.out = 5))
    
    p <- p + theme(axis.title = element_blank())
    
    p <- p + theme(
        legend.text = element_text(
            colour = "white",
            face = "bold"),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.direction = "horizontal", 
        legend.position = c(0, 0),
        legend.justification = c(0, 0),
        legend.key = element_rect(
            fill = NA,
            colour = "white",
            size = 1))
    
    return(p)
}

# test_start = 1979.35
# print(plotOverview(start = test_start))
# print(plotArea(start = test_start))