# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Statistics Cards
    columns do
      column do
        panel "Contact Statistics" do
          div class: "stats-container" do
            div class: "stat-card" do
              h3 Contact.count
              p "Total Contacts"
            end
            div class: "stat-card" do
              h3 Contact.where('created_at >= ?', 1.month.ago).count
              p "This Month"
            end
            div class: "stat-card" do
              h3 Contact.where('created_at >= ?', 1.week.ago).count
              p "This Week"
            end
            div class: "stat-card" do
              h3 Contact.where('created_at >= ?', 1.day.ago).count
              p "Today"
            end
          end
        end
      end

      column do
        panel "Portfolio Statistics" do
          div class: "stats-container" do
            div class: "stat-card" do
              h3 Project.count
              p "Total Projects"
            end
            div class: "stat-card" do
              h3 Skill.count
              p "Total Skills"
            end
            div class: "stat-card" do
              h3 About.count
              p "About Sections"
            end
          end
        end
      end

      column do
        panel "Content Statistics" do
          div class: "stats-container" do
            div class: "stat-card" do
              h3 Education.count
              p "Education Entries"
            end
            div class: "stat-card" do
              h3 Certification.active.count
              p "Active Certifications"
            end
            div class: "stat-card" do
              h3 FeaturedProject.featured.count
              p "Featured Projects"
            end
          end
        end
      end
    end

    # Additional Statistics
    columns do
      column do
        panel "Experience & Journey" do
          div class: "stats-container" do
            div class: "stat-card" do
              h3 Experience.count
              p "Total Experiences"
            end
            div class: "stat-card" do
              h3 Experience.current.count
              p "Current Positions"
            end
            div class: "stat-card" do
              h3 "#{Experience.sum(&:years_experience).round(1)}"
              p "Total Years"
            end
          end
        end
      end

      column do
        panel "Statistics Management" do
          div class: "stats-container" do
            div class: "stat-card" do
              h3 Statistic.count
              p "Total Statistics"
            end
            div class: "stat-card" do
              h3 Statistic.about_stats.count
              p "About Stats"
            end
            div class: "stat-card" do
              h3 Statistic.where(category: 'home').count
              p "Home Stats"
            end
          end
        end
      end
    end

    # Recent Contacts
    columns do
      column do
        panel "Recent Contacts" do
          if Contact.any?
            table_for Contact.order('created_at DESC').limit(5) do
              column "Name" do |contact|
                link_to contact.name, admin_contact_path(contact)
              end
              column "Email" do |contact|
                mail_to contact.email, contact.email
              end
              column "Message" do |contact|
                truncate(contact.message, length: 50)
              end
              column "Date" do |contact|
                contact.created_at.strftime("%B %d, %Y")
              end
            end
            div style: "margin-top: 10px;" do
              link_to "View All Contacts", admin_contacts_path, class: "button"
            end
          else
            para "No contacts yet."
          end
        end
      end

      column do
        panel "Recent Education & Certifications" do
          if Education.any? || Certification.any?
            div do
              h4 "Recent Education"
              if Education.any?
                ul do
                  Education.order('created_at DESC').limit(3).each do |education|
                    li link_to("#{education.degree} - #{education.institution}", admin_education_path(education))
                  end
                end
              else
                para "No education entries yet."
              end
            end
            
            div style: "margin-top: 15px;" do
              h4 "Recent Certifications"
              if Certification.any?
                ul do
                  Certification.order('created_at DESC').limit(3).each do |certification|
                    li link_to("#{certification.name} - #{certification.issuer}", admin_certification_path(certification))
                  end
                end
              else
                para "No certifications yet."
              end
            end
          else
            para "No education or certifications yet."
          end
        end
      end

      column do
        panel "Quick Actions" do
          ul do
            li link_to "Add New Project", new_admin_project_path
            li link_to "Add New Skill", new_admin_skill_path
            li link_to "Add Education", new_admin_education_path
            li link_to "Add Certification", new_admin_certification_path
            li link_to "Add Featured Project", new_admin_featured_project_path
            li link_to "Add Experience", new_admin_experience_path
            li link_to "Add Statistic", new_admin_statistic_path
            li link_to "Update About", admin_abouts_path
            li link_to "View All Contacts", admin_contacts_path
          end
        end

        panel "Recent Activity" do
          para "Last contact: #{Contact.order('created_at DESC').first&.created_at&.strftime('%B %d, %Y at %I:%M %p') || 'No contacts yet'}"
          para "Last project added: #{Project.order('created_at DESC').first&.created_at&.strftime('%B %d, %Y') || 'No projects yet'}"
          para "Last education added: #{Education.order('created_at DESC').first&.created_at&.strftime('%B %d, %Y') || 'No education yet'}"
          para "Last certification added: #{Certification.order('created_at DESC').first&.created_at&.strftime('%B %d, %Y') || 'No certifications yet'}"
          para "Last experience added: #{Experience.order('created_at DESC').first&.created_at&.strftime('%B %d, %Y') || 'No experiences yet'}"
        end
      end
    end
  end # content
end
