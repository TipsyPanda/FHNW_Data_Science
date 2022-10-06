#C6.Term 
f <- factor(lcdata$term)
levels(f)
require("tm")
lcdata$term <- as.integer(removeWords(lcdata$term,"months"))

