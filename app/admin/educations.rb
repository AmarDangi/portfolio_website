ActiveAdmin.register Education do
  permit_params :degree, :institution, :description, :start_date, :end_date, :gpa, :current

  index do
    selectable_column
    id_column
    column :degree
    column :institution
    column :duration do |education|
      education.duration
    end
    column :gpa_display do |education|
      education.gpa_display
    end
    column :current
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :degree
      row :institution
      row :description do |education|
        simple_format(education.description)
      end
      row :start_date
      row :end_date
      row :gpa
      row :current
      row :duration do |education|
        education.duration
      end
      row :gpa_display do |education|
        education.gpa_display
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Education Details" do
      f.input :degree
      f.input :institution
      f.input :description, as: :text, input_html: { rows: 4 }
      f.input :start_date, as: :date_picker
      f.input :end_date, as: :date_picker
      f.input :gpa, as: :number, step: 0.01, min: 0, max: 4.0
      f.input :current
    end
    f.actions
  end

  filter :degree
  filter :institution
  filter :current
  filter :start_date
  filter :end_date
  filter :gpa
  filter :created_at

  sidebar "Education Statistics", only: :index do
    div class: "stats" do
      h3 "Total Education: #{Education.count}"
      h4 "Current: #{Education.current.count}"
      h4 "Completed: #{Education.completed.count}"
    end
  end

  action_item :export_education, only: :index do
    link_to 'Export to CSV', export_education_admin_educations_path(format: :csv)
  end

  collection_action :export_education, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Degree', 'Institution', 'Start Date', 'End Date', 'GPA', 'Current', 'Description']
      Education.all.each do |education|
        csv << [education.id, education.degree, education.institution, education.start_date, education.end_date, education.gpa, education.current, education.description]
      end
    end
    
    send_data csv_data, filename: "education-#{Date.current}.csv"
  end
end 