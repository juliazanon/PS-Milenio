require "crystagiri"

def get_image_url(env)
    id = env.params.url["id"].to_i32
    res = HTTP::Client.get("https://rickandmortyapi.com/api/location/#{id}")
    location = JSON.parse(res.body)
    name = location["name"].to_s

    # not all of them work because some names are different on the website than on the database
    # here's a few of them corrected (the first ones)
    # solution would be to write small ai to find by enough similarities (TODO)
    if (name.includes?("Earth ("))
        fixed = name.gsub(%r{.*([Cc]-\d+).*}, "\\1")
        name = fixed
    end
    case name
    when "Abadango"
        name = "Abadongo"
    when "Citadel of Ricks"
        name = "The Citadel"
    when "Post-Apocalyptic Earth"
        name = "Post-Apocalyptic Dimension"
    when "Cronenberg Earth"
        name = "Cronenberg World"
    end

    url = "https://rickandmorty.fandom.com/wiki/Category:Locations"

    # Parse the HTML content
    doc = Crystagiri::HTML.from_url url

    img_url = ""
    imgs = [] of Crystagiri::Tag
    doc.where_tag("img") { |tag| imgs << tag }
    imgs.each do |tag|
        if tag.node.attributes["alt"] && tag.node.attributes["alt"].to_s.includes?(name)
            img_url = tag.node.attributes["src"].to_s.gsub(%r{/width/\d+/height/\d+|smart}, "")
        end
    end

    # Search on next page
    if img_url == ""
        url = "https://rickandmorty.fandom.com/wiki/Category:Locations?from=The+Wishing+Portal"
        doc = Crystagiri::HTML.from_url url

        imgs = [] of Crystagiri::Tag
        doc.where_tag("img") { |tag| imgs << tag }
        imgs.each do |tag|
            if tag.node.attributes["alt"] && tag.node.attributes["alt"].to_s.includes?(name)
                img_url = tag.node.attributes["src"].to_s.gsub(%r{/width/\d+/height/\d+|smart}, "")
            end
        end
    end

    if img_url == "" 
        img_url = "Location #{name} not found"
    end
    img_url
end