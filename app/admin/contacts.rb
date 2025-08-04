ActiveAdmin.register Contact do
  permit_params :name, :email, :message

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :message do |contact|
      truncate(contact.message, length: 100)
    end
    column :created_at
    actions do |contact|
      item "View Details", admin_contact_path(contact), class: "member_link"
      item "Reply via Email", "mailto:#{contact.email}?subject=Re: Your message from #{contact.name}", class: "member_link"
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email do |contact|
        mail_to contact.email, contact.email
      end
      row :message do |contact|
        simple_format(contact.message)
      end
      row :created_at
      row :updated_at
    end

    panel "Quick Actions" do
      div class: "quick-actions" do
        link_to "Reply via Email", "mailto:#{resource.email}?subject=Re: Your message from #{resource.name}", class: "button"
        link_to "Copy Email", "#", onclick: "navigator.clipboard.writeText('#{resource.email}'); alert('Email copied!');", class: "button"
      end
    end
  end

  form do |f|
    f.inputs "Contact Details" do
      f.input :name
      f.input :email
      f.input :message, as: :text, input_html: { rows: 5 }
    end
    f.actions
  end

  filter :name
  filter :email
  filter :created_at
  filter :message

  sidebar "Contact Statistics", only: :index do
    div class: "stats" do
      h3 "Total Contacts: #{Contact.count}"
      h4 "This Month: #{Contact.where('created_at >= ?', 1.month.ago).count}"
      h4 "This Week: #{Contact.where('created_at >= ?', 1.week.ago).count}"
    end
  end

  action_item :export_contacts, only: :index do
    link_to 'Export to CSV', export_contacts_admin_contacts_path(format: :csv)
  end

  collection_action :export_contacts, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Name', 'Email', 'Message', 'Created At']
      Contact.all.each do |contact|
        csv << [contact.id, contact.name, contact.email, contact.message, contact.created_at]
      end
    end
    
    send_data csv_data, filename: "contacts-#{Date.current}.csv"
  end

  controller do
    def create
      @contact = Contact.new(permitted_params[:contact])
      
      if @contact.save
        # Send email notification
        ContactMailer.new_contact_notification(@contact).deliver_now
        redirect_to admin_contact_path(@contact), notice: 'Contact created and email sent!'
      else
        render :new
      end
    end
  end
end 