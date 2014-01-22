require "hpricot"

module TextHelper
    
  def prepare_text(text, options = { :sanitize => false, :embed => true })
    options.assert_valid_keys(:sanitize, :embed)
    rc = RedCloth.new(text)
    if options[:sanitize]
      options[:embed] = false
      rc.sanitize_html = true
    end
    html = rc.to_html
    html = auto_link(html)
    doc = Hpricot(html)
    (doc/"img").each { |img| absolutize_url_attribute img, :src }
    (doc/"a").each { |a| absolutize_url_attribute a, :href }
    if options[:embed]
      (doc/"a").each do |a|
        url = a[:href]
        if a.inner_text == a[:href]
          begin
            uri = URI.parse(url)
            if uri.host == "www.youtube.com"            
              params = parse_query(uri.query || "")
              video_id = params["v"]
              a.swap (render :partial => "partials/youtube", :locals => { :video_id => video_id })
            end
          rescue URI::InvalidURIError
          end
        end
      end
    end
    doc.to_s
  end
  
  private

  def absolutize_url_attribute(elem, attribute)
    if elem[attribute]
      elem[attribute] = absolutize_url(elem[attribute])
    end
  end
  
  def absolutize_url(url)
    begin
      uri = URI.parse(url)
      if uri.absolute?
        url
      else
        unless url.start_with?("/")
          url = "/#{request.path}/#{url}"
        end
        "#{request.protocol}#{request.host_with_port}#{url}"
      end
    rescue URI::InvalidURIError
      url
    end
  end
  
  def parse_query(query)
    query.split(/\?/).inject({}) do |hash,e|
      k,v = e.split(/\=/)
      hash[k] = v
      hash
    end
  end
  
end