ActiveAdmin.register Experience do
  permit_params :title, :company, :start_date, :end_date, :current, :description, :order

  index do
    selectable_column
    id_column
    column :title
    column :company
    column :duration do |experience|
      experience.duration
    end
    column :current do |experience|
      status_tag experience.current, class: experience.current? ? 'green' : 'gray'
    end
    column :order
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :company
      row :start_date
      row :end_date
      row :current
      row :duration do |experience|
        experience.duration
      end
      row :years_experience do |experience|
        "#{experience.years_experience} years"
      end
      row :description do |experience|
        simple_format(experience.description)
      end
      row :order
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Experience Details" do
      f.input :title
      f.input :company
      f.input :start_date, as: :date_picker
      f.input :end_date, as: :date_picker, hint: "Leave blank if current position"
      f.input :current, hint: "Check if this is your current position"
      f.input :description, as: :text, input_html: { rows: 6 }
      f.input :order, hint: "Display order (lower numbers appear first)"
    end
    f.actions
  end

  filter :title
  filter :company
  filter :current
  filter :start_date
  filter :order
  filter :created_at

  sidebar "Experience Statistics", only: :index do
    div class: "stats" do
      h3 "Total Experiences: #{Experience.count}"
      h4 "Current Positions: #{Experience.current.count}"
      h4 "Past Positions: #{Experience.past.count}"
      h4 "Total Years: #{Experience.sum(&:years_experience).round(1)}"
    end
  end

  action_item :export_experiences, only: :index do
    link_to 'Export to CSV', export_experiences_admin_experiences_path(format: :csv)
  end

  collection_action :export_experiences, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Title', 'Company', 'Start Date', 'End Date', 'Current', 'Description', 'Order']
      Experience.all.each do |experience|
        csv << [experience.id, experience.title, experience.company, experience.start_date, experience.end_date, experience.current, experience.description, experience.order]
      end
    end
    
    send_data csv_data, filename: "experiences-#{Date.current}.csv"
  end

  # Add JavaScript for current position handling
  sidebar "Quick Actions", only: [:new, :edit] do
    div do
      para "💡 Tips:"
      ul do
        li "Set 'Current' to true for your current position"
        li "Leave end date blank for current positions"
        li "Use order to control display sequence"
        li "Add detailed descriptions of your responsibilities"
      end
    end
  end
end 