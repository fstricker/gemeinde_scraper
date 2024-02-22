#install.packages("rvest")
# install.packages("xml2")
library(rvest)
library(xml2)

# URL
vorarl <- 'https://www.gemeindeverband.at/'
vorarl_page <- read_html(paste0(vorarl, 'Unsere_Gemeinden'))
print(vorarl_page)

vorarl_atags <- html_nodes(vorarl_page, ".abclist")
vorarl_links <- html_attr(vorarl_atags, "href")
vorarl_letters <- html_text(vorarl_atags)

# create a dataframe with the following columns: buchstabe, name, address, areacode, telephone, email, url, longitude and latitude
# Create an empty dataframe
gemeinden_df <- data.frame(buchstabe = character(),
                           name = character(),
                           address = character(),
                           areacode = character(),
                           telephone = character(),
                           email = character(),
                           url = character(),
                           longitude = numeric(),
                           latitude = numeric(),
                           stringsAsFactors = FALSE)

# Loop the letter link sites
for (i in 1:1) {
# for (i in 1:length(vorarl_links)) {
  # Get the letter link
  letter_link <- paste0(vorarl, vorarl_links[i])
  # Read the letter link
  letter_page <- read_html(letter_link)
  # Get the gemeinde links
  gemeinde_links <- html_nodes(letter_page, ".gs_info")

  # Loop the gemeinde links
      for (j in 1:length(gemeinde_links)) {
        # the data attributes aren't always filled (can be confirmed when printing the below lines of code)
        # although theoretically possible for all of area/zip code, street name, house number, latitude and longitude
    gemeinde_p_tag <- html_node(gemeinde_links[j], "p")
    
    # gemeinde_p_tag_html <- gemeinde_p_tag
    # cat(gemeinde_p_tag) doesn't work
    print(gemeinde_p_tag)
    gemeinde_text <- html_text(gemeinde_p_tag)
    
    string_between_br <- strsplit(gemeinde_text, "<br>")[[1]][2]
    # that doesn't work yet, because the html structure isn't present when parsing the gemeinde_p_tag as text using html_text
    print(gemeinde_text)
    print(string_between_br)

    #     # Get the gemeinde name
    gemeinde_a_tag <- html_node(gemeinde_links[j], ".gs_list_link")
    gemeinde_a_string <- html_text(gemeinde_a_tag)
    gemeinde_name <- strsplit(gemeinde_a_string, ",")[[1]][1]
    print(gemeinde_name)

    wegfinder <- html_node(gemeinde_links[j], ".wegfinder")
    zipcode <- html_attr(wegfinder, "data-dzip")
    print(zipcode)
    address <- paste0(html_attr(wegfinder, "data-dstr"), " ", html_attr(wegfinder, "data-dhnr"))
    print(address)
    latitude <- html_attr(wegfinder, "data-dlat")
    print(latitude)
    longitude <- html_attr(wegfinder, "data-dlng")
    print(longitude)

    #     # Get the gemeinde link
    #     gemeinde_link <- paste0(vorarl, html_attr(gemeinde_links[j], "href"))
    #     # Read the gemeinde link
    #     gemeinde_page <- read_html(gemeinde_link)
    #     # Get the gemeinde name
    #     gemeinde_name <- html_text(html_nodes(gemeinde_page, "h1"))
    #     # Get the gemeinde address
    #     gemeinde_address <- html_text(html_nodes(gemeinde_page, ".address"))
    #     # Get the gemeinde areacode
    #     gemeinde_areacode <- html_text(html_nodes(gemeinde_page, ".areacode"))
    #     # Get the gemeinde telephone
    #     gemeinde_telephone <- html_text(html_nodes(gemeinde_page, ".telephone"))
    #     # Get the gemeinde email
    #     gemeinde_email <- html_text(html_nodes(gemeinde_page, ".email"))
    #     # Get the gemeinde url
    #     gemeinde_url <- html_text(html_nodes(gemeinde_page, ".url"))
    #     # Get the gemeinde longitude
    #     gemeinde_longitude <- html_text(html_nodes(gemeinde_page, ".longitude"))
    #     # Get the gemeinde latitude
    #     gemeinde_latitude <- html_text(html_nodes(gemeinde_page, ".latitude"))
    #     # Add the gemeinde to the dataframe
    #     gemeinden_df <- rbind(gemeinden_df, c(vorarl_letters[i], gemeinde_name, gemeinde_address, gemeinde_areacode, gemeinde_telephone, gemeinde_email, gemeinde_url, gemeinde_longitude, gemeinde_latitude))
}
}

# Add your desired code here to populate the dataframe

# Example code to add a row to the dataframe
# gemeinden_df <- rbind(gemeinden_df, c("A", "Gemeinde A", "Address A", "12345", "123-456-7890", "email@example.com", "https://www.example.com", 12.345, 67.890))
