rollercoaster<-read.csv("/Users/vikki/Desktop/STAT Research Fall22/RollerCoasterDataRATINGS.csv")

# testing on the original data set
rollercoaster1<-read.csv("/Users/vikki/Desktop/STAT Research Fall22/Roller Coasters.csv")

# creating new variable age
rollercoaster$Age<- 2022 -rollercoaster$Year_Opened

library(tidyverse)
library(hrbrthemes) 
library(viridis)
library(tidygeocoder)
library(ggmap)

#-------------------------------------------------------------
#Scatterplot
rollercoaster %>%
  dplyr::arrange(desc(Age)) %>%
  ggplot(aes(as.numeric(Max_Height),Top_Speed)) +
  geom_point(aes(size=Age,color=Type),alpha=0.5) + 
  scale_size(range = c(1, 8))+
  #geom_smooth(aes(color=Type),method='loess',se=F) +
  labs(x = "Maximum Height (in feet)",
       y = "Top Speed (in MPH)",
       title = "Vanessa's Scatterplot",
       cex.lab=10) +
  theme_classic() +
  theme(plot.title=element_text(hjust=0.5), 
        axis.title = element_text(size = 16), axis.text = element_text(size = 14))
  
## Scatterplot with loess
rollercoaster %>%
  dplyr::arrange(desc(Age)) %>%
  ggplot(aes(as.numeric(Max_Height),Top_Speed)) +
  geom_point(aes(size=Age,color=Type),alpha=0.5) + 
  #scale_size(range = c(1, 8))+
  geom_smooth(aes(color=Type),method='loess',se=F) +
  labs(x = "Maximum Height (in feet)",
       y = "Top Speed (in MPH)",
       title = "Vanessa's Scatterplot") +
  theme_classic() +
  theme(plot.title=element_text(hjust=0.5),axis.title = element_text(size = 16), axis.text = element_text(size = 16))
  
## SLR ##

m1 <- lm(Top_Speed~as.numeric(Max_Height),data=rollercoaster %>%
           dplyr::filter(Type == 'Steel'))

m2 <- lm(Top_Speed~as.numeric(Max_Height),data=rollercoaster %>%
           dplyr::filter(Type == 'Wooden'))

m1$coefficients
m2$coefficients

dat <- data.frame(Type = c("Steel","Wooden"),
                  Top_Speed = c(125,75),
                  Max_Height = c(350,100),
                  label = c("y = 31.74 + 0.20x",
                            "y = 32.44 + 0.22x"))
# stratified scatteplot with the equation - didnt use for proj
rollercoaster %>%
  dplyr::arrange(desc(Age)) %>%
  ggplot(aes(as.numeric(Max_Height),Top_Speed)) +
  geom_point(aes(size=Age,color=Type),alpha=0.5) + 
  geom_smooth(aes(color=Type),method='lm',se=F) +
  geom_text(data = dat,aes(label=label,color=Type)) + 
  labs(x = "Maximum Height (in feet)",
       y = "Top Speed (in MPH)",
       title = "Vanessa's Scatterplot") +
  theme_classic() +
  theme(plot.title=element_text(hjust=0.5))

## Boxplot ##
rollercoaster %>%
  ggplot(aes(factor(Any_Top_10),Rating)) +
  geom_boxplot(aes(color=Type)) +
  labs(x = "Top 10 Coaster Status",
       title = "Vanessa's Boxplot") +
  theme_classic() + 
  theme(plot.title=element_text(hjust=0.5),axis.title = element_text(size = 16), axis.text = element_text(size = 16)) +
  scale_x_discrete(labels = c("Not Top 10","Top 10"))

#-----------------------------------------------------------------------------------
# creating new variable age
rollercoaster$age<- as.numeric(as.numeric(2022)) -
  as.numeric(as.numeric(rollercoaster$Year_Opened))
rollercoaster$age <- as.numeric(rollercoaster$age)

##-----------------------------TIME SERIES-------------------------
# MAX HEIGHT AND YEAR
datamhyr<- rollercoaster %>% drop_na(Max_Height,Year_Opened)
## Connected scatterplot - Speed increase with year
datatsyr%>%
  # tail(10) %>%
  ggplot( aes(Year_Opened, as.numeric(Max_Height)))+
  ##remove geom_line 
  geom_line( color="#72A3AB") +
  #geom_point(shape=21, color="black", fill="#0000FF", size=2) +
  theme_classic() +labs(x = "Year_Opened(in years)",
                        y = "Max_Height (in mph)",
                        title = "Change in Roller Coaster Height over the Years")+
  theme(plot.title=element_text(hjust=0.5),axis.title = element_text(size = 16), axis.text = element_text(size = 16))

#TOP SPEED AND YEAR
datatsyr<- rollercoaster %>% drop_na(Top_Speed,Year_Opened)
## Connected scatterplot - Speed increase with year
datatsyr%>%
#  tail(10) %>%
  ggplot( aes(Year_Opened, as.numeric(Top_Speed)))+
 ##remove geom_line 
   geom_line( color="#72A3AB") +
  #geom_point(shape=21, color="black", fill="#0000FF", size=2) +
  theme_classic() +labs(x = "Year_Opened(in years)",
                        y = "Top_Speed (in mph)",
                        title = "Change in Roller Coaster Speed over the Years")+
  theme(plot.title=element_text(hjust=0.5),axis.title = element_text(size = 16),axis.text = element_text(size = 16))

summary(datatsyr)
summary(rollercoaster)

##---------------------------Geospatial Map of US---------------------------------------
##data frame needed
## longitude and lattitude
dataLatLong<- read.csv ("/Users/vikki/Desktop/STAT Research Fall22/RollerCoasterDataRATINGS_with_city_state_latlon.csv")

ggplot() + 
  geom_point(aes(longitude, latitude), data = dataLatLong)

# Get map at zoom level 13: corvallis_map

library(pacman)
p_load(ggmap)
us <- c(lon = 97, lat = 38)
us_map <- get_map(us, zoom = 5, scale = 1)

# Plot map at zoom level 13
ggmap(us_map)

ggmap(us_map) +
  geom_point(aes(longitude, latitude), data = dataLatLong)

# plot
ggmap(bw_map) +
  geom_point(data = dataLatLong,
             aes(x = longitude, y = lat, size = count),
             color = "red", alpha = 0.5) 
  geom_point(data = geo_per_source,
             aes(x = lon, y = lat, size = count),
             color = "purple", alpha = 0.5)

##-----------------------------WORKING VIOLIN PLOT--------------------
## drop everything with 1
df2<-rollercoaster[!(rollercoaster$Design=="4th Dimension" | rollercoaster$Design=="Pipeline" | 
                       rollercoaster$Design=="Suspended" |
                    rollercoaster$Design=="Wing"),]

#plot 
p <- ggplot(df2, aes(Design, Top_Speed, fill = Design))
p + geom_violin() + theme_classic() +geom_boxplot(width = .3)+
  theme(plot.title=element_text(hjust=0.5),axis.title = element_text(size = 16), axis.text = element_text(size = 16))


##------------Checking for frquencies---------------------
table(rollercoaster$Design)
table(rollercoaster$Type,rollercoaster$Design)

##-------------------------WORD CLOUD CODE------------------------------------
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm) 

#Create a vector containing only the text
text <- read_csv("/Users/vikki/Desktop/textCoaster.csv")
          
# Create a corpus  
docs <- Corpus(VectorSource(text))

docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)

docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))

# Create a document term matrix
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)

set.seed(1234) # for reproducibility 
wordcloud(words = df$word, freq = df$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35,
          scale=c(3.5,0.25),
          colors=brewer.pal(8, "Dark2"))

set.seed(1234) # for reproducibility 
wordcloud(words = df$word, freq = df$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35,
          scale=c(3.5,0.25),
          colors=brewer.pal(8, "Dark2"))