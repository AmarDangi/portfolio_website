class ContactMailer < ApplicationMailer
  def new_contact_notification(contact)
    @contact = contact
    @admin_email = "admin@yourportfolio.com" # Change this to your admin email
    
    mail(
      to: @admin_email,
      subject: "New Contact Message from #{@contact.name}",
      from: @contact.email
    )
  end

  def contact_confirmation(contact)
    @contact = contact
    
    mail(
      to: @contact.email,
      subject: "Thank you for your message - Portfolio",
      from: "noreply@yourportfolio.com"
    )
  end
end 