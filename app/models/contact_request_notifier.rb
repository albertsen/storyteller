class ContactRequestNotifier< ActionMailer::Base

  def notification(contact_request)
    recipients ["mail@juergenalbertsen.de"]
    from       "blog@juergenalbertsen.de"
    subject    "Kontakt-Anfrage von #{contact_request.sender}"
    reply_to   [contact_request.sender_email]
    body       :contact_request => contact_request
  end

end