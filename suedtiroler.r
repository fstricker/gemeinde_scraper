install.packages("rvest")	
install.packages("xml2")	
library(rvest)
library(xml2)


# URL
base_path <- 'https://www.gvcc.net/'

# Gemeinde_Buchstaben
suedtirol_page <- read_html(paste0(base_path, 'de/Mitglieder/Informationen/Gemeinden'))
suedtiroler_letters <- html_nodes(suedtirol_page, ".abclist")
suedtiroler_atags <- html_attr(suedtiroler_letters, "href")

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

for (i in 1:1) {
# for (i in 1:length(suedtiroler_atags)) {
    #get the path/url of the gemeinde
    gemeinden_links_page <- read_html(paste0(base_path, suedtiroler_atags[i]))
    gemeinden_nodes <- html_nodes(gemeinden_links_page, ".gs_list_link")
    gemeinden_names <- html_text(gemeinden_nodes)
    gemeinden_paths <- html_attr(gemeinden_nodes, "href")

    print(gemeinden_names)
    print(gemeinden_nodes)
    print(gemeinden_paths)

    for (j in 1:1) {
    # for (j in 1:length(gemeinden_paths)) {
        # get the path/url of the gemeinde
        gemeinde_path <- paste0(base_path, gemeinden_paths[j])
        gemeinde_page <- read_html(gemeinde_path)
        print(gemeinde_page)

        # table_content <- html_nodes(gemeinde_page, "tbody")
        table_content <- html_nodes(gemeinde_page, ".verticaltable")
        tds <- html_nodes(table_content, "td")
        for (k in 1:length(tds)) {
            #write what you want from the data table of a gemeinde page
            email <- tds[4]
            telephone <- tds[3]
            print(html_text(tds[k]))
        }

        # now also get the lat/lng data
        # wegfinder_node <- html_nodes(gemeinde_page, ".extlink")
        # print(wegfinder_node)

        ris_node <- html_nodes(gemeinde_page, ".rismap3_map")
        print(ris_node)
        map_data <- html_attr(ris_node, "data-map3_pin")
        print(map_data)

        gemeinden_df <- rbind(gemeinden_df, c("A", "Gemeinde A", "Address A", "12345", telephone, email, "https://www.example.com", 12.345, 67.890))
        # gemeinden_df <- rbind(gemeinden_df, c("A", "Gemeinde A", "Address A", "12345", "123-456-7890", "email@example.com", "https://www.example.com", 12.345, 67.890))
    }



}
