ActiveAdmin.register FeaturedProject do
  permit_params :title, :description, :technologies, :live_url, :github_url, :featured, :order

  index do
    selectable_column
    id_column
    column :title
    column :technologies do |project|
      project.technologies_list.join(', ')
    end
    column :featured
    column :order
    column :has_live_demo? do |project|
      status_tag project.has_live_demo?, class: project.has_live_demo? ? 'green' : 'gray'
    end
    column :has_github? do |project|
      status_tag project.has_github?, class: project.has_github? ? 'green' : 'gray'
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description do |project|
        simple_format(project.description)
      end
      row :technologies do |project|
        project.technologies_list.join(', ')
      end
      row :live_url do |project|
        link_to project.live_url, project.live_url, target: '_blank' if project.live_url.present?
      end
      row :github_url do |project|
        link_to project.github_url, project.github_url, target: '_blank' if project.github_url.present?
      end
      row :featured
      row :order
      row :has_live_demo? do |project|
        status_tag project.has_live_demo?, class: project.has_live_demo? ? 'green' : 'gray'
      end
      row :has_github? do |project|
        status_tag project.has_github?, class: project.has_github? ? 'green' : 'gray'
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Featured Project Details" do
      f.input :title
      f.input :description, as: :text, input_html: { rows: 6 }
      f.input :technologies, as: :text, input_html: { rows: 3 }, hint: "Enter technologies separated by commas (e.g., React, Node.js, MongoDB)"
      f.input :live_url, hint: "URL to live demo"
      f.input :github_url, hint: "URL to GitHub repository"
      f.input :featured
      f.input :order, hint: "Display order (lower numbers appear first)"
    end
    f.actions
  end

  filter :title
  filter :featured
  filter :order
  filter :created_at

  sidebar "Featured Project Statistics", only: :index do
    div class: "stats" do
      h3 "Total Projects: #{FeaturedProject.count}"
      h4 "Featured: #{FeaturedProject.featured.count}"
      h4 "With Live Demo: #{FeaturedProject.where.not(live_url: [nil, '']).count}"
      h4 "With GitHub: #{FeaturedProject.where.not(github_url: [nil, '']).count}"
    end
  end

  action_item :export_projects, only: :index do
    link_to 'Export to CSV', export_projects_admin_featured_projects_path(format: :csv)
  end

  collection_action :export_projects, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Title', 'Description', 'Technologies', 'Live URL', 'GitHub URL', 'Featured', 'Order']
      FeaturedProject.all.each do |project|
        csv << [project.id, project.title, project.description, project.technologies, project.live_url, project.github_url, project.featured, project.order]
      end
    end
    
    send_data csv_data, filename: "featured-projects-#{Date.current}.csv"
  end
end 