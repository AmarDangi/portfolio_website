ActiveAdmin.register Certification do
  permit_params :name, :issuer, :description, :issue_date, :expiry_date, :credential_id, :url

  index do
    selectable_column
    id_column
    column :name
    column :issuer
    column :status do |certification|
      status_tag certification.status, class: certification.status_color
    end
    column :issue_date
    column :expiry_date
    column :credential_id
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :issuer
      row :description do |certification|
        simple_format(certification.description)
      end
      row :issue_date
      row :expiry_date
      row :credential_id
      row :url do |certification|
        link_to certification.url, certification.url, target: '_blank' if certification.url.present?
      end
      row :status do |certification|
        status_tag certification.status, class: certification.status_color
      end
      row :validity_period do |certification|
        certification.validity_period
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Certification Details" do
      f.input :name
      f.input :issuer
      f.input :description, as: :text, input_html: { rows: 4 }
      f.input :issue_date, as: :date_picker
      f.input :expiry_date, as: :date_picker
      f.input :credential_id
      f.input :url
    end
    f.actions
  end

  filter :name
  filter :issuer
  filter :issue_date
  filter :expiry_date
  filter :credential_id
  filter :created_at

  sidebar "Certification Statistics", only: :index do
    div class: "stats" do
      h3 "Total Certifications: #{Certification.count}"
      h4 "Active: #{Certification.active.count}"
      h4 "Expired: #{Certification.expired.count}"
    end
  end

  action_item :export_certifications, only: :index do
    link_to 'Export to CSV', export_certifications_admin_certifications_path(format: :csv)
  end

  collection_action :export_certifications, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Name', 'Issuer', 'Issue Date', 'Expiry Date', 'Credential ID', 'URL', 'Status']
      Certification.all.each do |certification|
        csv << [certification.id, certification.name, certification.issuer, certification.issue_date, certification.expiry_date, certification.credential_id, certification.url, certification.status]
      end
    end
    
    send_data csv_data, filename: "certifications-#{Date.current}.csv"
  end
end 