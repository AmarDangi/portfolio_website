 # app/admin/projects.rb
  ActiveAdmin.register Project do
    permit_params :title, :description, :link, :image
  
    form do |f|
      f.inputs do
        f.input :title
        f.input :description
        f.input :link
        f.input :image, as: :file
      end
      f.actions
    end
  end