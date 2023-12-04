# Function to clean penguins dataset
clean_penguins_data <- function(data) {
  # Check for missing values in the original dataset
  cat("Missing values in the original dataset:\n")
  print(summary(is.na(data)))
  
  # Remove NAs from 'species' and 'flipper_length_mm', and ensure flipper length is always positive
  cleaned_data <- data[complete.cases(data$species, data$flipper_length_mm) & data$flipper_length_mm >= 0, ]
  
  # Check the cleaned dataset
  cat("\nMissing values in the cleaned dataset:\n")
  print(summary(is.na(cleaned_data)))
  
  return(cleaned_data)
}
