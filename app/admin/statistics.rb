ActiveAdmin.register Statistic do
  permit_params :name, :value, :description, :category, :order

  index do
    selectable_column
    id_column
    column :name
    column :value
    column :display_value do |stat|
      stat.display_value
    end
    column :category
    column :order
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :value
      row :display_value do |stat|
        stat.display_value
      end
      row :description do |stat|
        simple_format(stat.description)
      end
      row :category
      row :order
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Statistic Details" do
      f.input :name, hint: "e.g., Years Experience, Projects Completed"
      f.input :value, hint: "e.g., 5, 50 (the + will be added automatically)"
      f.input :description, as: :text, input_html: { rows: 3 }, hint: "Optional description"
      f.input :category, as: :select, collection: ['about', 'home', 'skills'], hint: "Category for grouping statistics"
      f.input :order, hint: "Display order (lower numbers appear first)"
    end
    f.actions
  end

  filter :name
  filter :category
  filter :order
  filter :created_at

  sidebar "Statistics Overview", only: :index do
    div class: "stats" do
      h3 "Total Statistics: #{Statistic.count}"
      h4 "About Stats: #{Statistic.about_stats.count}"
      h4 "Home Stats: #{Statistic.where(category: 'home').count}"
      h4 "Skills Stats: #{Statistic.where(category: 'skills').count}"
    end
  end

  action_item :export_statistics, only: :index do
    link_to 'Export to CSV', export_statistics_admin_statistics_path(format: :csv)
  end

  collection_action :export_statistics, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Name', 'Value', 'Description', 'Category', 'Order']
      Statistic.all.each do |stat|
        csv << [stat.id, stat.name, stat.value, stat.description, stat.category, stat.order]
      end
    end
    
    send_data csv_data, filename: "statistics-#{Date.current}.csv"
  end

  sidebar "Quick Actions", only: [:new, :edit] do
    div do
      para "💡 Tips:"
      ul do
        li "Use 'about' category for About page stats"
        li "Value should be just the number (e.g., '5' not '5+')"
        li "The '+' will be added automatically"
        li "Use order to control display sequence"
      end
    end
  end
end 