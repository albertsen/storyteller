module PdfHelper
  
  def has_pdf(item)
    not Medium.find_by_filename("#{item.slug}.pdf").blank?
  end
  
  def pdf_url_path_for(item)
    m = Medium.find_by_filename("#{item.slug}.pdf")
    if m
      m.url_path
    else
      nil
    end
  end
  
end