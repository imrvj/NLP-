install.packages('tm')
install.packages('twitteR')
install.packages('wordcloud')
install.packages('RColorBrewer')
#install.packages('e1017')
#install.packages('class')
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

##Oauth
setup_twitter_oauth(consumer_key = "",consumer_secret = "",access_token = "",access_secret = "")
##Search topic on twitter
soccer.tweets <- searchTwitter("soccer", n=1000, lang="en")
soccer.text <- sapply(soccer.tweets, function(x) x$getText())


##clean text data
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII') # remove emoticons
soccer.corpus <- Corpus(VectorSource(soccer.text)) # create a corpus

##create  document term matrix
term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
                                      control = list(removePunctuation = TRUE,
                                                     stopwords = c("soccer","http", stopwords("english")),
                                                     removeNumbers = TRUE,tolower = TRUE))

##check out matrix
head(term.doc.matrix)
term.doc.matrix <- as.matrix(term.doc.matrix)

##get word count
word.freqs <- sort(rowSums(term.doc.matrix), decreasing=TRUE) 
dm <- data.frame(word=names(word.freqs), freq=word.freqs)

##create word cloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
