class PagesController < ApplicationController
  def home; end

  def about
    @about = About.first
    @educations = Education.ordered
    @certifications = Certification.active.ordered
    @experiences = Experience.ordered
    @statistics = Statistic.about_stats.ordered
  end

  def projects
    @projects = Project.all
    @featured_projects = FeaturedProject.featured.ordered
  end

  def skills
    @skills = Skill.all
  end

  def contact
    @contact = Contact.new
  end

  def create_contact
    @contact = Contact.new(contact_params)
    
    if @contact.save
      begin
        ContactMailer.new_contact_notification(@contact).deliver_now
        ContactMailer.contact_confirmation(@contact).deliver_now
        redirect_to contact_path, notice: 'Thank you for your message! We will get back to you soon.'
      rescue => e
        redirect_to contact_path, notice: 'Message sent successfully! (Email notification failed)'
      end
    else
      redirect_to contact_path, alert: 'There was an error sending your message. Please try again.'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end