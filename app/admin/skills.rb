ActiveAdmin.register Skill do
  permit_params :name, :proficiency

  index do
    selectable_column
    id_column
    column :name
    column :proficiency do |skill|
      "#{skill.proficiency}%"
    end
    column :proficiency_bar do |skill|
      div class: "progress-bar-container" do
        div class: "progress-bar", style: "width: #{skill.proficiency}%; background-color: #{skill.proficiency >= 80 ? '#10b981' : skill.proficiency >= 60 ? '#f59e0b' : '#ef4444'};" do
          span skill.proficiency.to_s + "%"
        end
      end
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :proficiency do |skill|
        "#{skill.proficiency}%"
      end
      row :proficiency_bar do |skill|
        div class: "progress-bar-container" do
          div class: "progress-bar", style: "width: #{skill.proficiency}%; background-color: #{skill.proficiency >= 80 ? '#10b981' : skill.proficiency >= 60 ? '#f59e0b' : '#ef4444'};" do
            span skill.proficiency.to_s + "%"
          end
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Skill Details" do
      f.input :name
      f.input :proficiency, as: :range, input_html: { min: 0, max: 100, step: 5 }, hint: "Drag to set proficiency level (0-100%)"
      div class: "proficiency-display" do
        span "Proficiency: "
        span id: "proficiency-value", style: "font-weight: bold; color: #fbbf24;" do
          "#{f.object.proficiency || 0}%"
        end
      end
    end
    f.actions
  end

  filter :name
  filter :proficiency
  filter :created_at

  sidebar "Skill Statistics", only: :index do
    div class: "stats" do
      h3 "Total Skills: #{Skill.count}"
      h4 "Expert Level (90%+): #{Skill.where('proficiency >= ?', 90).count}"
      h4 "Advanced (70-89%): #{Skill.where(proficiency: 70..89).count}"
      h4 "Intermediate (50-69%): #{Skill.where(proficiency: 50..69).count}"
      h4 "Beginner (<50%): #{Skill.where('proficiency < ?', 50).count}"
      h4 "Average Proficiency: #{Skill.average(:proficiency).to_i}%"
    end
  end

  action_item :export_skills, only: :index do
    link_to 'Export to CSV', export_skills_admin_skills_path(format: :csv)
  end

  collection_action :export_skills, method: :get do
    csv_data = CSV.generate do |csv|
      csv << ['ID', 'Name', 'Proficiency', 'Created At']
      Skill.all.each do |skill|
        csv << [skill.id, skill.name, skill.proficiency, skill.created_at]
      end
    end
    
    send_data csv_data, filename: "skills-#{Date.current}.csv"
  end

  # Add JavaScript for real-time proficiency display
  sidebar "Quick Actions", only: [:new, :edit] do
    div do
      para "💡 Tips:"
      ul do
        li "Use descriptive skill names (e.g., 'React.js' instead of 'React')"
        li "Be honest about your proficiency levels"
        li "Group related skills together"
        li "Update skills regularly as you improve"
      end
    end
  end
end 